import 'package:heroes/heroes.dart';
import 'package:http/http.dart'
    as http; // Must include http: any package in your pubspec.yaml
import 'dart:async';
import 'dart:convert';

Future main() async {
  
  final app = Application<HeroesChannel>()
      ..options.configurationFilePath = "config.yaml"
      ..options.port = 8888;

  final count = Platform.numberOfProcessors ~/ 2;
  await app.start(numberOfInstances: count > 0 ? count : 1);

  print("Application started on port: ${app.options.port}.");
  print("Use Ctrl-C (SIGINT) to stop running the application.");


   const clientID = "org.hasenbalg.zeiterfassung";
  const body = "username=bob&password=password&grant_type=password";

// Note the trailing colon (:) after the clientID.
// A client identifier secret would follow this, but there is no secret, so it is the empty string.
  final String clientCredentials =
      const Base64Encoder().convert("$clientID:".codeUnits);

  final http.Response response =
      await http.post("http://localhost:8888/auth/token",
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Basic $clientCredentials"
          },
          
          body: body);
  print(response.body);



}



