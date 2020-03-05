import 'package:heroes/controller/heroes_controller.dart';

import 'heroes.dart';

/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://aqueduct.io/docs/http/channel/.
class HeroesChannel extends ApplicationChannel {
  ManagedContext context;

  /// Initialize services in this method.
  ///
  /// Implement this method to initialize services, read values from [options]
  /// and any other initialization required before constructing [entryPoint].
  ///
  /// This method is invoked prior to [entryPoint] being accessed.
  

  @override
Future prepare() async {
  logger.onRecord.listen(
      (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));

  final config = HeroConfig(options.configurationFilePath);
  final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
  final persistentStore = PostgreSQLPersistentStore.fromConnectionInfo(
      config.database.username,
      config.database.password,
      config.database.host,
      config.database.port,
      config.database.databaseName);

  context = ManagedContext(dataModel, persistentStore);
}

  // @override
  // Future prepare() async {
  //   logger.onRecord.listen(
  //       (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));

  //       // the data models initialization 

  //   final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
  //   final persistentStore = PostgreSQLPersistentStore.fromConnectionInfo(
  //       "heroes_user", "password", "localhost", 5432, "heroes");

  //   context = ManagedContext(dataModel, persistentStore);
  // }

  /// Construct the request channel.
  ///
  /// Return an instance of some [Controller] that will be the initial receiver
  /// of all [Request]s.
  ///
  /// This method is invoked after [prepare].
  /// 
// @override
// Controller get entryPoint {
//   return Router()
//     ..route("/organizations/[:orgName]")
//       .link(() => OrganizationController());
//     ..route("/organizations/:orgName/heroes/[:heroID]")
//       .link(() => OrgHeroesController());
//     ..route("/organizations/:orgName/buildings/[:buildingID]")
//       .link(() => OrgBuildingController());
// }

  @override
  Controller get entryPoint {
    final router = Router();

    // Prefer to use `link` instead of `linkFunction`.

    router.route('/heroes/[:id]').link(() => HeroesController(context));// context is an example of a service object
    // service encopsulate logic into a single object that can be used in multiple controllers
    // Services are passed into a controller's contructor (dependencies enjection)
    // router.route('/users')
    // .link(() => APIkeyValidator())
    // .link(() => Authorizer.bearer()) 
    // .link(() => UsersController());

    // router.route('/poats')
    // .link(() => APIkeyValidator())
    // .link(() => PostsConntroller());

    

    // See: https://aqueduct.io/docs/http/request_controller/

    router.route("/example").linkFunction((request) async {
      return Response.ok({"key": "value"});
    });

    return router;
  }

  
}
class HeroConfig extends Configuration{
  HeroConfig(String path): super.fromFile(File(path));
  DatabaseConfiguration database;

  
}
