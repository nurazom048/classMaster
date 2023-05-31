// ignore_for_file: avoid_print, unnecessary_null_comparison, deprecated_member_use

import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class HelperMethods {
  //! Pick image and compressed....//
  static Future<String?> pickAndCompressImage() async {
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

  //!.. Simple image pick ...

  // Future<void> _pickImage(ImageSource source) async {
  //
  //     final picker = ImagePicker();
  //     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //     setState(() {
  //       print("image path " + _image.toString());

  //       print("the image is" + _image.toString());
  //       if (pickedFile != null) {
  //         _image = File(pickedFile.path);

  //         //... save token
  //       }
  //     });

  //     if (_image != null) {
  //       final prefs = await SharedPreferences.getInstance();
  //       var saveImage = await prefs.setString('Image', _image!.path);
  //     }

  //     // print(e);
  //  }
  // }
}
