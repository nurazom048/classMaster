// ignore_for_file: prefer_const_constructors_in_immutables, unused_local_variable, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:table/ui/auth_Section/auth_ui/login_sceen.dart';

void main() => runApp(ProviderScope(child: MyApp()));

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(),
      //  home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker and Compressor'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (imagePath != null)
                Container(
                    height: 350,
                    width: 350,
                    child: Image.file(File(imagePath!))),
              ElevatedButton(
                onPressed: () async {
                  String? path = await _pickAndCompressImage();
                  setState(() {
                    imagePath = path;
                  });
                },
                child: Text('Pick and Compress Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _pickAndCompressImage() async {
    // Define a method that compresses the image and returns the compressed image path
    Future<String?> compressAndReturnImagePath() async {
      // Pick an image from the gallery
      final picker = ImagePicker();
      final pickedFile = await picker.getImage(source: ImageSource.gallery);

      // If no image was picked, return null
      if (pickedFile == null) {
        return null;
      }

      // Read the image bytes and get the original size
      final imageBytes = await pickedFile.readAsBytes();
      final originalSize = imageBytes.length;

      // Compress the image with the specified dimensions and quality
      final compressedBytes = await FlutterImageCompress.compressWithList(
        imageBytes,
        minHeight: 800,
        minWidth: 800,
        quality: 70,
      );

      // If compression failed, return a default image path
      if (compressedBytes == null) {
        return 'assets/images/default_image.jpg';
      }

      // Save the compressed image to temporary directory
      final directory = await getTemporaryDirectory();
      final path =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final compressedImageFile = File(path);
      await compressedImageFile.writeAsBytes(compressedBytes);

      // Get the compressed size and print the original and compressed sizes and the compressed image path
      final compressedSize = compressedImageFile.lengthSync();
      print('Original size: ${originalSize ~/ 1024} KB');
      print('Compressed size: ${compressedSize ~/ 1024} KB');
      print('Compressed image path: $path');

      // Return the compressed image path
      return compressedImageFile.path;
    }

    // Compress the image and return the compressed image path
    return await compressAndReturnImagePath();
  }
}
