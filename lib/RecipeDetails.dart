import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class RecipeDetails {
  final ParseFileBase recipePic;
  final String recipeTitle, ingredients, steps;

  RecipeDetails(this.recipePic, this.recipeTitle, this.ingredients, this.steps);
}

