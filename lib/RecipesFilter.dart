import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class RecipesFilter {
  List<ParseObject> allRecipesList = [];

  RecipesFilter(List<ParseObject> list){
    allRecipesList = list;
  }

  List<ParseObject> recipeFilter( List<String> inputs){
    List<ParseObject> filteredRecipesList = [];

    for(int loop = 0; loop < allRecipesList.length; loop++){
      var recipeName = allRecipesList[loop].get<String>('RecipeTitle');
      var recipeIngredients = allRecipesList[loop].get<String>('Ingredients');
      var recipeSteps = allRecipesList[loop].get<String>('Steps');

      for(int i = 0; i< inputs.length ; i++) {
        if(recipeName!.contains(inputs[0].trim()) || recipeIngredients!.contains(inputs[0].trim()) || recipeSteps!.contains(inputs[0].trim())){
          filteredRecipesList.add(allRecipesList[loop]);
        }

      }
    }
    return filteredRecipesList;
  }
}