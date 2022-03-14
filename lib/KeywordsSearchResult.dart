import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:super_chef_back4app/BottomNavBar.dart';
import 'package:super_chef_back4app/RecipesFilter.dart';
import 'package:super_chef_back4app/SpecificRecipeDetails.dart';

class KeywordsSearchResult extends StatefulWidget {
  final List<String> ingredientsInputResult;

  const KeywordsSearchResult({Key? key, required this.ingredientsInputResult}) : super(key: key);

  @override
  State<KeywordsSearchResult> createState() => _KeywordsSearchResultState();
}

class _KeywordsSearchResultState extends State<KeywordsSearchResult> {
  late List<ParseObject> recipesList = [];
  late List<ParseObject> recipesDetailFilter = [];

  Future<List<ParseObject>> getRecipe() async {
    QueryBuilder<ParseObject> queryRecipe =
    QueryBuilder<ParseObject>(ParseObject('Recipes'));
    final ParseResponse apiResponse = await queryRecipe.query();

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
        title: const Text('Searched Recipes List'),
      ),
      body: FutureBuilder<List<ParseObject>> (
        future: getRecipe(),
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

              RecipesFilter recipesFilter = RecipesFilter(recipesList);
              List<ParseObject> filteredList = recipesFilter.recipeFilter(widget.ingredientsInputResult);
              Map<String, ParseObject> map = {};
              for (var item in filteredList) {
                map[item.get<String>('objectId')!] = item;
              }
              recipesDetailFilter = map.values.cast<ParseObject>().toList();
              if(filteredList.isEmpty) {
                [
                AlertDialog(
                title: const Text("No match found."),
                content: const Text('Please try again.'),
                actions: <Widget>[
                  ElevatedButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const BottomNavBar()),
                        (Route<dynamic> route) => false);
          }, )
          ],
                )
              ];
              }

              return
              ListView.builder(

                  itemCount: recipesDetailFilter.length,
                  itemBuilder: (context,index) {
                    final recipePic = recipesDetailFilter[index].get<ParseFileBase>('RecipePic')!;
                    return Card(
                      child: ListTile(
                        title: Text(recipesDetailFilter[index].get<String>('RecipeTitle')!),
                        leading: SizedBox(
                          width: 50,
                          height: 50,
                          child: Image.network(recipePic.url!,),
                        ),
                        onTap: () {
                          var recipeId = recipesDetailFilter[index].get<String>('objectId');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SpecificRecipeDetails(recipeId: recipeId!)
                              ));
                        },
                      ),
                    );
                  });
          }
        },
      )
    );
  }
}

