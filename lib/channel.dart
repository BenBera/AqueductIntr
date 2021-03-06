import 'package:heroes/controller/heroes_controller.dart';
import 'package:heroes/controller/register_controller.dart';
import 'package:heroes/model/user.dart';
import 'dart:io';

import 'heroes.dart';
import 'package:aqueduct/managed_auth.dart';

/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://aqueduct.io/docs/http/channel/.
class HeroesChannel extends ApplicationChannel {
  ManagedContext context;

  /// Initialize services in this method.
  AuthServer authServer;
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


  final   authStorage =ManagedAuthDelegate<User>(context);
  authServer = AuthServer(authStorage);
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

   

 router
    .route('/auth/token')
    .link(() => AuthController(authServer));


  router
    .route('/register')
    .link(() => RegisterController(context, authServer));

    
    router
  .route('/heroes/[:id]')
  // .link(() => Authorizer.bearer(authServer))
  .link(() => HeroesController(context));


  router
  .route('/clientswagger')
  .linkFunction((request) async{
    final clientswagger = await File('client.html').readAsString();

    return Response.ok(clientswagger)..contentType = ContentType.html;

  } );


    

    // // See: https://aqueduct.io/docs/http/request_controller/

    // router.route("/example").linkFunction((request) async {
    //   return Response.ok({"key": "value"});
    // });

    return router;
  }

  
}
class HeroConfig extends Configuration{
  HeroConfig(String path): super.fromFile(File(path));
  DatabaseConfiguration database;

  
}
