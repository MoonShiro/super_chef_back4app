import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class ImageSearchResult extends StatefulWidget {
  const ImageSearchResult({Key? key, required this.label}) : super(key: key);
  final Category? label;

  @override
  State<ImageSearchResult> createState() => _ImageSearchResultState();
}

class _ImageSearchResultState extends State<ImageSearchResult> {
  late List<ParseObject> recipesList = [];
  late List<ParseObject> specificRecipeList = [];

  @override
  Widget build(BuildContext context) {
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

                var notIngredient = false;

                var removedString = widget.label!.label.toString().substring(2, widget.label!.label.toString().length);
                specificRecipeList.clear();
                for(var index = 0; index < snapshot.data!.length; index++) {
                  final tempStore = snapshot.data![index];
                  final recipeTitle = tempStore.get<String>('recipeTitle')!;
                  if (recipeTitle.contains(removedString.toString())) {
                    specificRecipeList.add(tempStore);
                  }
                  else if (removedString.contains('Not ingredient')) {
                    notIngredient = true;
                  }
                }
                if (!notIngredient) {
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
                  }else {
                  return const Center(
                    child: Text("Sorry, there is no match found. Please try again.",
                    style: TextStyle(
                      fontSize: 18.0, overflow: TextOverflow.clip
                    ), textAlign: TextAlign.center,),
                  );
                }
            }
          },
        ),
      ),
    );
  }
}