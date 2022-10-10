import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late File _image;
  late List _results;
  bool imageSelect = false;
  bool showProgressBar = false;
  @override
  void initState() {
    loadModel();
    super.initState();
  }

  Future loadModel() async {
    Tflite.close();
    String res;
    res = (await Tflite.loadModel(
        model: "assets/model.tflite", labels: "assets/labels.txt"))!;
    print("Models loading status: $res");
  }

  Future imageClassification(File image) async {
    final List? recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _results = recognitions!;
      _image = image;
      imageSelect = true;
      showProgressBar = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Disease Detection'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 30, left: 30, right: 30),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.purple,
              ),
              onPressed: pickImage,
              child: const Text("Upload Images for Processing"),
            ),
          ),
          (imageSelect)
              ? Container(
                  margin: const EdgeInsets.all(10),
                  child: Image.file(_image),
                )
              : Container(
                  margin: const EdgeInsets.all(10),
                  child: const Opacity(
                    opacity: 0.8,
                    child: Center(
                      child: Text("No image selected"),
                    ),
                  ),
                ),
          showProgressBar
              ? Container(
                width: 40,
                height: 40,
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: (imageSelect)
                        ? _results.map((result) {
                            return Card(
                              child: Container(
                                margin: EdgeInsets.all(10),
                                child: Text(
                                  "${result['label']} - ${result['confidence'].toStringAsFixed(2)}",
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 20),
                                ),
                              ),
                            );
                          }).toList()
                        : [],
                  ),
                )
        ],
      ),
    );
  }

  Future pickImage() async {
   
    final _imagePicker = ImagePicker();
    final XFile? pickerFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
        
      
    File image = File(pickerFile!.path);
    print(image.path);
    imageClassification(image);
  }
}
