import 'dart:io';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:table/constant/app_color.dart';
import 'package:table/helper/helper_fun.dart';
import 'package:table/ui/bottom_items/Home/utils/utils.dart';
import 'package:badges/badges.dart' as badges;

import '../core/component/Loaders.dart';

// ignore: must_be_immutable
class PickImage extends StatefulWidget {
  final String? netWorkImage;
  final String? netWorkCoverImage;
  final bool isEddit;

  final Function(String?) onImagePathSelected; // new property
  final Function(String?) onCoverImagePath; // new property
  const PickImage({
    required this.onImagePathSelected,
    required this.onCoverImagePath,
    required this.netWorkImage,
    required this.netWorkCoverImage,
    this.isEddit = false,
    Key? key,
  }) : super(key: key);

  @override
  State<PickImage> createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  File? _image;
  File? _imageCover;

  @override
  Widget build(BuildContext context) {
    //
    Widget pickImageBagges = CircleAvatar(
      radius: 21,
      backgroundColor: AppColor.nokiaBlue,
      child: CircleAvatar(
        backgroundColor: AppColor.background,
        radius: 20,
        child: IconButton(
          onPressed: () async {
            String? imagePath = await HelperMethods.pickAndCompressImage();

            setState(() {
              _image = imagePath != null ? File(imagePath) : null;
            });
            widget.onImagePathSelected(imagePath); // invoke the callback
          },
          icon: const Icon(Icons.edit),
        ),
      ),
    );

    Widget pickCoverBagges = CircleAvatar(
      radius: 21,
      backgroundColor: AppColor.nokiaBlue,
      child: CircleAvatar(
        backgroundColor: AppColor.background,
        radius: 20,
        child: IconButton(
          onPressed: () async {
            String? imagePath = await HelperMethods.pickAndCompressImage();

            setState(() {
              _imageCover = imagePath != null ? File(imagePath) : null;
            });
            widget.onCoverImagePath(imagePath); // invoke the callback
          },
          icon: const Icon(Icons.edit),
        ),
      ),
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5).copyWith(top: 0),
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: badges.Badge(
              showBadge: widget.isEddit,
              position: BadgePosition.bottomEnd(bottom: -3, end: 12),
              badgeStyle:
                  const badges.BadgeStyle(badgeColor: Colors.transparent),
              badgeContent: pickCoverBagges,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                height: 150,
                width: MediaQuery.of(context).size.width,
                color: Colors.black12,
                child: coverImageShow(),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: MediaQuery.of(context).size.width / 2.9,
            child: badges.Badge(
              showBadge: widget.isEddit,
              position: BadgePosition.bottomEnd(),
              badgeStyle:
                  const badges.BadgeStyle(badgeColor: Colors.transparent),
              badgeContent: pickImageBagges,
              child: ClipOval(
                child: Container(
                  height: 120,
                  width: 120,
                  color: Colors.black12,
                  child: profileImageShow(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget? coverImageShow() {
    if (_imageCover == null && widget.netWorkCoverImage == null) {
      return const Icon(Icons.image);
    } else if (_imageCover != null) {
      return Image.file(_imageCover!);
    } else if (widget.netWorkCoverImage != null) {
      return FutureBuilder(
        future: Utils.isOnlineMethod(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loaders.center();
          } else if (snapshot.hasData && snapshot.data == true) {
            return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  widget.netWorkCoverImage!,
                  fit: BoxFit.cover,
                ));
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong: ${snapshot.error.toString()}',
              ),
            );
          } else {
            return const Icon(Icons.error);
          }
        },
      );
    }
    return null;
  }

  Widget profileImageShow() {
    if (_image == null && widget.netWorkImage == null) {
      return const Icon(Icons.image);
    } else if (_image != null) {
      return Image.file(_image!, fit: BoxFit.cover);
    } else if (widget.netWorkImage != null) {
      return FutureBuilder(
        future: Utils.isOnlineMethod(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loaders.center();
          } else if (snapshot.hasData && snapshot.data == true) {
            return ClipOval(
                child: Image.network(
              widget.netWorkImage!,
              fit: BoxFit.cover,
            ));
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong: ${snapshot.error.toString()}',
              ),
            );
          } else {
            return const Icon(Icons.error);
          }
        },
      );
    }
    return const Icon(Icons.error);
  }
}
