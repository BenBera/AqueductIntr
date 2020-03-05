import 'package:aqueduct/aqueduct.dart';
import 'package:heroes/heroes.dart';
import 'package:heroes/model/hero.dart';

class HeroesController extends ResourceController {
  HeroesController(this.context);
  final ManagedContext context;//context is an example of a service object


  @Operation.get()
  Future<Response>getAllHeroes()async{
    final heroeQuery = Query<Hero>(context);
    final heroes = await heroeQuery.fetch();

    return Response.ok(heroes);

  }
  @Operation.get('id')
  Future<Response>getHeroeByID(@Bind.path('id') int id)async{
    final heroeQuery = Query<Hero>(context)
     ..where((h) => h.id).equalTo(id);
    final hero = await heroeQuery.fetchOne();
    if (hero == null) {
      return Response.notFound();
    }

    return Response.ok(hero);
  }
  // assignining one by one value from a request body

  // @Operation.post()
  // Future<Response> createHero() async {
  //   final Map<String, dynamic> body = await request.body .decode();
  //   final query = Query<Hero> (context)
  //   ..values.name = body ['name']as String;
  //   final insertedHero = await query.insert();

  //   return Response.ok(insertedHero);
  // }

// auto-magically ingest a request body into a managed object and assign it to the values of a query

  // @Operation.post()
  // Future<Response> createHero() async {
  //   final hero = Hero()
  //   ..read(await  request.body.decode(),ignore:['id']);
  //   final query = Query<Hero> (context)..values = hero;
  //   final insertedHero = await query.insert();

  //   return Response.ok(insertedHero);
  // }
  ///Values in the request body object are decoded into a Hero object -
  /// each key in the request body maps to a property of our Hero. 
  ///For example, the value for the key 'name' is stored in the inputHero.name. 
  ///If decoding the request body into a Hero instance fails for any reason, 
  ///a 400 Bad Request response is sent and the operation method is not called
  //bind the body of a request to an operation method parameter, binding a Hero instance into the body of a request

  @Operation.post()
  Future<Response> createHero(@Bind.body(ignore:['id'])Hero inputHero)async{
    final query = Query<Hero> (context)..values = inputHero;
    final insertedHero = query.insert();
    return Response.ok(insertedHero);
  }

  
}

