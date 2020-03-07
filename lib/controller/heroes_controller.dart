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

   @Operation.post()
  Future<Response> createHero(@Bind.body(ignore:['id'])Hero inputHero)async{
    final query = Query<Hero> (context)..values = inputHero;
    final insertedHero = query.insert();
    return Response.ok(insertedHero);
  }
  
}

