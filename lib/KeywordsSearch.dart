import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import 'KeywordsSearchResult.dart';

class KeywordsSearch extends StatefulWidget {
  const KeywordsSearch({Key? key}) : super(key: key);

  @override
  State<KeywordsSearch> createState() => _KeywordsSearchState();
}

class _KeywordsSearchState extends State<KeywordsSearch> {
  var input1 = '';
  var input2 = '';
  var input3 = '';
  var firstInput = '';
  var secondInput = '';
  var thirdInput = '';



  Future<List<ParseObject>> getRecipe() async {
    QueryBuilder<ParseObject> queryRecipe =
    QueryBuilder<ParseObject>(ParseObject('RecipeDetails'));
    final ParseResponse apiResponse = await queryRecipe.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController firstInputController = TextEditingController();
    TextEditingController secondInputController = TextEditingController();
    TextEditingController thirdInputController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

          SizedBox(
            width: 170,
            height: 30,
            child: TextFormField(
            controller: firstInputController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                labelText: "First Ingredient",
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40.0),
                  borderSide: const BorderSide(),
                )
              ),
          )
              ),
              const SizedBox(height: 10),

              SizedBox(
                  width: 170,
                  height: 30,
                  child: TextFormField(
                    controller: secondInputController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                        labelText: "Second Ingredient",
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40.0),
                          borderSide: const BorderSide(),
                        )
                    ),
                  )
              ),
              const SizedBox(height: 10),

              SizedBox(
                  width: 170,
                  height: 30,
                  child: TextFormField(
                    controller: thirdInputController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                        labelText: "Third Ingredient",
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40.0),
                          borderSide: const BorderSide(),
                        )
                    ),
                  )
              ),
              const SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0)
                        )
                      )),
                  child: const Text('Search'),
                  onPressed: () {
                    final List<String> ingredientsInput = [];
                    ingredientsInput.add(firstInputController.text.toString());
                    ingredientsInput.add(secondInputController.text.toString());
                    ingredientsInput.add(thirdInputController.text.toString());
                    Navigator.push(context,
                        MaterialPageRoute(
                          builder: (context) => KeywordsSearchResult(ingredientsInputResult: ingredientsInput)
                        ));
                  }
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}