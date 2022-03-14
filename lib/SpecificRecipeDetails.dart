import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class SpecificRecipeDetails extends StatefulWidget {
  final String recipeId;
  const SpecificRecipeDetails({Key? key, required this.recipeId}) : super(key: key);

  @override
  State<SpecificRecipeDetails> createState() => _SpecificRecipeDetailsState();
}

class _SpecificRecipeDetailsState extends State<SpecificRecipeDetails> {

  @override
  Widget build(BuildContext context) {
    Future<List<ParseObject>> getSpecificRecipe() async {
      QueryBuilder<ParseObject> querySpecificRecipe =
      QueryBuilder<ParseObject>(ParseObject('Recipes'))
        ..whereEqualTo('objectId', widget.recipeId);
      final ParseResponse apiResponse = await querySpecificRecipe.query();

      if (apiResponse.success && apiResponse.results != null) {
        return apiResponse.results as List<ParseObject>;
      } else {
        return [];
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Selected Recipe'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<ParseObject>>(
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

                final recipePic = snapshot.data![0].get<ParseFileBase>('RecipePic')!;
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(5),
                      child: Center(
                        child: Image.network(recipePic.url!,
                        width: 300,
                        height: 300,
                          fit: BoxFit.fitHeight,
                        ),
                      ),),
                      const SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: Text(snapshot.data![0].get<String>('RecipeTitle')!
                        , style: const TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Center(
                        child: Text(
                          'Ingredients \n', style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.clip
                        ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(snapshot.data![0].get<String>('Ingredients')!,
                        style: const TextStyle(
                          fontSize: 20.0, overflow: TextOverflow.clip
                        ), textAlign: TextAlign.justify,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Center(
                        child: Text(
                          'Steps \n', style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.clip
                        ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(snapshot.data![0].get<String>('Steps')!,
                        style: const TextStyle(
                            fontSize: 20.0, overflow: TextOverflow.clip
                        ), textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

