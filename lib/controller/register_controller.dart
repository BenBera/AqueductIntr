import 'dart:async';

import 'package:aqueduct/aqueduct.dart';
import 'package:heroes/model/user.dart';

class RegisterController extends ResourceController {
  RegisterController(this.context, this.authServer);

  final ManagedContext context;
  final AuthServer authServer;

  @Operation.post()
  Future<Response> createUser(@Bind.body() User user) async {
    // Check for required parameters before we spend time hashing
    if (user.username == null || user.password == null) {
      return Response.badRequest(
          body: {"error": "username and password required."});
    }

    user
      ..salt = AuthUtility.generateRandomSalt()
      ..hashedPassword = authServer.hashPassword(user.password, user.salt);

    return Response.ok(await Query(context, values: user).insert());
  }

  // @Operation.post()
  // Future<Response> getAllUsers() async {
  //   final query = Query<User>(context);
  //   final allUsers = await query.fetch();
  //   return Response.ok(allUsers);
  // }

  // @Operation.get('id')
  // Future<Response> getAUser() async { 
  //   final query = Query<User>(context)
  //   ..where((u) => u.id).equalTo(1);
  //   final oneUser = await query.fetchOne();
  //   if (oneUser == null) {
  //     return Response.notFound();
  //   }

  //   return Response.ok(oneUser);
  // }
}
