import 'dart:io';
import 'package:flutter/material.dart';
import 'package:table/helper/helper_fun.dart';

class PickImage extends StatefulWidget {
  final dynamic onTap;
  final Function(String?) onImagePathSelected; // new property
  const PickImage({
    this.onTap,
    required this.onImagePathSelected,
    Key? key,
  }) : super(key: key);

  @override
  State<PickImage> createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  late File? _image = null;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
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
                  onPressed: () async {
                    String? imagePath =
                        await HelperMethods.pickAndCompressImage();

                    setState(() {
                      if (imagePath != null) {
                        _image = File(imagePath);
                      }
                    });
                    widget
                        .onImagePathSelected(imagePath); // invoke the callback
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
