import 'package:flutter/material.dart';
import 'package:super_chef_back4app/ImageSearch.dart';
import 'package:super_chef_back4app/KeywordsSearch.dart';

class SearchingPage extends StatefulWidget {
  const SearchingPage({Key? key}) : super(key: key);

  @override
  State<SearchingPage> createState() => _SearchingPageState();
}

class _SearchingPageState extends State<SearchingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Features'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  child: const Text('Keywords Search'),
                  onPressed: () => navToKeywordsSearch(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  child: const Text('Image Search'),
                  onPressed: () => navToImageSearch(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navToKeywordsSearch() {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const KeywordsSearch())
    );
  }

  void navToImageSearch() {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ImageSearch())
    );
  }
}