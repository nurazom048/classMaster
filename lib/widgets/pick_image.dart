import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:table/helper/helper_fun.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/sunnary_section/summat_screens/summary_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:table/ui/bottom_items/Home/utils/utils.dart';

import '../core/component/Loaders.dart';

// ignore: must_be_immutable
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
      child: AspectRatio(
        aspectRatio: 1.0, // Set the desired aspect ratio here
        child: Stack(
          children: [
            const SizedBox(height: 200),
            // image,

            if (_image == null && widget.netWorkIamge == null)
              const CircleAvatar(
                radius: 80,
                child: Icon(Icons.person_2_rounded),
              )
            else if (_image != null)
              CircleAvatar(
                radius: 80,
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: const Icon(Icons.person_2_rounded),
              )

            // show user network image
            else if (widget.netWorkIamge != null && _image == null)
              FutureBuilder(
                future: Utils.isOnlineMethode(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Loaders.center();
                  } else if (snapshot.hasData && snapshot.data == true) {
                    return CircleAvatar(
                      radius: 80,
                      child: ClipOval(
                        child: Image.network(widget.netWorkIamge!),
                      ),
                    );
                  } else if (snapshot.data == true) {
                    return CircleAvatar(
                      radius: 80,
                      child: Center(
                        child: Text(
                          'Something went wrong: ${snapshot.error.toString()}',
                        ),
                      ),
                    );
                  } else {
                    return const CircleAvatar(
                      radius: 80,
                      child: ClipOval(
                        child: Icon(Icons.error),
                      ),
                    );
                  }
                },
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
                      widget.onImagePathSelected(
                          imagePath); // invoke the callback
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
