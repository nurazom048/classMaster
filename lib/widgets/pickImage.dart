import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PickImage extends StatefulWidget {
  final dynamic onTap;
  PickImage({
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  State<PickImage> createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  late File? _image = null;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      setState(() {
        print("image path " + _image.toString());

        print("the image is" + _image.toString());
        if (pickedFile != null) {
          _image = File(pickedFile.path);

          //... save token
        }
      });

      if (_image != null) {
        final prefs = await SharedPreferences.getInstance();
        var saveImage = await prefs.setString('Image', _image!.path);
      }
    } catch (e) {
      // print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      width: 114,
      child: Stack(
        children: [
          CircleAvatar(
            radius: 80,
            backgroundImage: _image != null ? FileImage(_image!) : null,
            child: _image == null ? const Icon(Icons.person) : null,
          ),
          Positioned(
            bottom: 17,
            right: -1,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.red,
              child: Center(
                child: IconButton(
                  onPressed: () {
                    _pickImage(ImageSource.gallery);
                  },
                  icon: const Icon(Icons.edit),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
