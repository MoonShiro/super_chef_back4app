import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:super_chef_back4app/Classifier.dart';
import 'package:super_chef_back4app/ImageSearchResult.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import 'ClassifierQuant.dart';

class ImageSearch extends StatefulWidget {
  const ImageSearch({Key? key}) : super(key: key);

  @override
  State<ImageSearch> createState() => _ImageSearchState();
}

class _ImageSearchState extends State<ImageSearch> {
  late Classifier classifier;

  var logger = Logger();

  File? _image;
  final picker = ImagePicker();

  Image? imageWidget;

  img.Image? fox;

  Category? category;

  @override
  void initState() {
    super.initState();
    classifier = ClassifierQuant();
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile!.path);
      imageWidget = Image.file(_image!);

      predict();
    });
  }

  void predict() async{
    img.Image imageInput = img.decodeImage(_image!.readAsBytesSync())!;
    img.Image imageResized = img.copyResize(imageInput, width:224, height: 224);
    var pred = classifier.predict(imageResized);

    setState(() {
      category = pred;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Image'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: IconButton(
              icon: const Icon(Icons.add_photo_alternate),
              onPressed: getImage,
              tooltip: 'Select an Image',
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              child: const Text('Sign Up'),
              onPressed: () {
                if(category != null) {
                  navToSpecificImageResult();
                } else {
                  errorMsg();
                }
              },
            ),
          )
        ],
      )
    );
  }

  void navToSpecificImageResult() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ImageSearchResult(label: category,)),
    );
  }

  errorMsg() async {
    await Future.delayed(const Duration(microseconds: 1));

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Sorry :('),
            content: const Text('Please select an Image'),
            actions: [
              ElevatedButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }
}