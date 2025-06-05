// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:badges/badges.dart' as badges;
import '../export_core.dart';
import 'dart:io' show File;

class PickImage extends StatefulWidget {
  final String? netWorkImage;
  final String? netWorkCoverImage;
  final bool isEddit;
  final Function(XFile?) onImagePathSelected;
  final Function(XFile?) onCoverImagePath;

  const PickImage({
    super.key,
    required this.onImagePathSelected,
    required this.onCoverImagePath,
    required this.netWorkImage,
    required this.netWorkCoverImage,
    this.isEddit = false,
  });

  @override
  State<PickImage> createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  XFile? _image;
  XFile? _imageCover;

  @override
  Widget build(BuildContext context) {
    print('Building PickImage widget');
    print('Network Image: ${widget.netWorkImage}');
    print('Network Cover Image: ${widget.netWorkCoverImage}');
    print('Local Image: ${_image?.path}');
    print('Local Cover Image: ${_imageCover?.path}');

    Widget pickImageBadges = CircleAvatar(
      radius: 21,
      backgroundColor: AppColor.nokiaBlue,
      child: CircleAvatar(
        backgroundColor: AppColor.background,
        radius: 20,
        child: IconButton(
          onPressed: () async {
            print('Picking profile image');
            final picker = ImagePicker();
            final pickedFile = await picker.pickImage(
              source: ImageSource.gallery,
            );
            if (pickedFile != null) {
              print('Profile image picked: ${pickedFile.path}');
              setState(() => _image = pickedFile);
              widget.onImagePathSelected(pickedFile);
            } else {
              print('No profile image selected');
            }
          },
          icon: const Icon(Icons.edit),
        ),
      ),
    );

    Widget pickCoverBadges = CircleAvatar(
      radius: 21,
      backgroundColor: AppColor.nokiaBlue,
      child: CircleAvatar(
        backgroundColor: AppColor.background,
        radius: 20,
        child: IconButton(
          onPressed: () async {
            print('Picking cover image');
            final picker = ImagePicker();
            final pickedFile = await picker.pickImage(
              source: ImageSource.gallery,
            );
            if (pickedFile != null) {
              print('Cover image picked: ${pickedFile.path}');
              setState(() => _imageCover = pickedFile);
              widget.onCoverImagePath(pickedFile);
            } else {
              print('No cover image selected');
            }
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
              position: badges.BadgePosition.bottomEnd(bottom: -3, end: 12),
              badgeStyle: const badges.BadgeStyle(
                badgeColor: Colors.transparent,
              ),
              badgeContent: pickCoverBadges,
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
              position: badges.BadgePosition.bottomEnd(),
              badgeStyle: const badges.BadgeStyle(
                badgeColor: Colors.transparent,
              ),
              badgeContent: pickImageBadges,
              child: ClipOval(
                child: Container(
                  height: 120,
                  width: 120,
                  color: Colors.black12,
                  child: profileImageShow(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget coverImageShow() {
    print('Showing cover image');
    if (_imageCover == null && widget.netWorkCoverImage == null) {
      print('No cover image available');
      return const Icon(Icons.image);
    } else if (_imageCover != null) {
      print('Displaying local cover image: ${_imageCover!.path}');
      return kIsWeb
          ? FutureBuilder<Uint8List>(
            future: _imageCover!.readAsBytes(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print('Cover image bytes loaded');
                return Image.memory(
                  snapshot.data!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    print('Error displaying cover image bytes: $error');
                    return const Icon(Icons.error);
                  },
                );
              } else if (snapshot.hasError) {
                print('Error loading cover image bytes: ${snapshot.error}');
                return const Icon(Icons.error);
              }
              print('Loading cover image bytes');
              return const CircularProgressIndicator();
            },
          )
          : Image.file(
            File(_imageCover!.path),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              print('Error loading native cover image: $error');
              return const Icon(Icons.error);
            },
          );
    } else if (widget.netWorkCoverImage != null) {
      print('Displaying network cover image: ${widget.netWorkCoverImage}');
      return Image.network(
        widget.netWorkCoverImage!,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          print('Loading network cover image');
          return Loaders.center();
        },
        errorBuilder: (context, error, stackTrace) {
          print('Error loading network cover image: $error');
          print('Stack trace: $stackTrace');
          return const Icon(Icons.error);
        },
      );
    }
    return const SizedBox.shrink();
  }

  Widget profileImageShow() {
    print('Showing profile image');
    if (_image == null && widget.netWorkImage == null) {
      print('No profile image available');
      return const Icon(Icons.image);
    } else if (_image != null) {
      print('Displaying local profile image: ${_image!.path}');
      return kIsWeb
          ? FutureBuilder<Uint8List>(
            future: _image!.readAsBytes(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print('Profile image bytes loaded');
                return Image.memory(
                  snapshot.data!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    print('Error displaying profile image bytes: $error');
                    return const Icon(Icons.error);
                  },
                );
              } else if (snapshot.hasError) {
                print('Error loading profile image bytes: ${snapshot.error}');
                return const Icon(Icons.error);
              }
              print('Loading profile image bytes');
              return const CircularProgressIndicator();
            },
          )
          : Image.file(
            File(_image!.path),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              print('Error loading native profile image: $error');
              return const Icon(Icons.error);
            },
          );
    } else if (widget.netWorkImage != null) {
      print('Displaying network profile image: ${widget.netWorkImage}');
      return Image.network(
        widget.netWorkImage!,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          print('Loading network profile image');
          return Loaders.center();
        },
        errorBuilder: (context, error, stackTrace) {
          print('Error loading network profile image: $error');
          print('Stack trace: $stackTrace');
          return const Icon(Icons.error);
        },
      );
    }
    return const SizedBox.shrink();
  }
}
