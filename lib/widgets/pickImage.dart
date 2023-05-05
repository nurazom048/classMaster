// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:table/helper/helper_fun.dart';

class PickImage extends StatefulWidget {
  final dynamic onTap;
  late String? netWorkIamge;
  final Function(String?) onImagePathSelected; // new property
  PickImage({
    this.onTap,
    required this.onImagePathSelected,
    required this.netWorkIamge,
    Key? key,
  }) : super(key: key);

  @override
  State<PickImage> createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  // ignore: avoid_init_to_null
  late File? _image = null;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: 114,
      child: Stack(
        children: [
          // show picked file image
          if (_image != null)
            CircleAvatar(
              radius: 80,
              backgroundImage: _image != null ? FileImage(_image!) : null,
            )

          // show user network image
          else if (widget.netWorkIamge != null)
            CircleAvatar(
              radius: 80,
              backgroundImage: NetworkImage(widget.netWorkIamge ?? ''),
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
