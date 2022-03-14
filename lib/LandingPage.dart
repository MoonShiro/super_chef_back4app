import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import 'SpecificRecipeDetails.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late List<ParseObject> recipesList = [];

  Future<List<ParseObject>> getSpecificRecipe() async {
    QueryBuilder<ParseObject> querySpecificRecipe =
    QueryBuilder<ParseObject>(ParseObject('Recipes'));
    final ParseResponse apiResponse = await querySpecificRecipe.query();

    if (apiResponse.success && apiResponse.results != null) {
      recipesList = apiResponse.results as List<ParseObject>;
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('SuperChef'),
      ),
      body: FutureBuilder<List<ParseObject>>(
        future: getSpecificRecipe(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            return const Center(
                child: SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator()),
            );
            default:
              
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 190,
                  childAspectRatio: 1.15,
                  crossAxisSpacing: 0.5,
                  mainAxisSpacing: 20
                ),

                itemCount: recipesList.length,
                itemBuilder: (context, index) {
                  final recipePic = snapshot.data![index].get<ParseFileBase>('RecipePic')!;
                  var recipeId = snapshot.data![index].get<String>('objectId');
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SpecificRecipeDetails(recipeId: recipeId!)
                      ));
                    },

                  child: Container(
                    child: Image.network(recipePic.url!,
                      width: 400,
                      height: 400,
                      fit: BoxFit.fitHeight,),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15)
                    ),
                  ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}