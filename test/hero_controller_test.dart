import 'package:heroes/model/hero.dart';

import 'harness/app.dart';

void main() {
  final harness = Harness()..install();

  test("GET /heroes returns 200 OK", () async {
    final query = Query<Hero>(harness.application.channel.context)
      ..values.name = "Bob";

    await query.insert();

    // this is a matcher 
    final response = await harness.agent.get("/heroes");
    expectResponse(response, 200,
        body: allOf([
          hasLength(greaterThan(0)),
          everyElement({
            "id": greaterThan(0),
            "name": isString,
          })
        ]));
  });
  test("Get /heroes returns 200 Ok",
  () async {
    final query = Query<Hero>(harness.application.channel.context)
    ..values.name = "Ben"; await query. insert();
     //  a matcher for the expected response
     final response = await harness.agent.get("/heroes");
     expectResponse(response,200, 
     body: allOf([
       hasLength(greaterThan(0)),
       everyElement({
         "id": greaterThan(0),
         "name" : isString,
       })
     ]));

  });

  test("POST /heroes returns 200 OK", () async {
  final response = await harness.agent.post("/heroes", body: {
    "name": "Ben"
  });
  expectResponse(response, 200, body: {
    "id": greaterThan(0),
    "name": "Ben"
  });
});



  // this is a POST test , showing the results expecte when a request is made to from the consumer
  // test("POST/ heroes returns 200 OK", () async {
  //   final response = await harness.agent.post("/heroes", body: {
  //     "name": "Bob"
  //   });
  //   expectResponse(response, 200 , body: {
  //     "id": greaterThan(0),
  //     "name": "Bob"
  //   });
  // });

//   test("POST /heroes returns 200 OK", () async {
//   await harness.agent.post("/heroes", body: {
//     "name": "Fred"
//   });

//   final badResponse = await harness.agent.post("/heroes", body: {
//     "name": "Fred"
//   });
//   expectResponse(badResponse, 409);
// });


}
