import 'package:flutter/foundation.dart';

class PdfFileData {
  final String? path;
  final Uint8List? bytes;
  final String name;
  final List<String>? imagePaths;
  final List<Uint8List>? imageBytesList;

  PdfFileData({
    this.path,
    this.bytes,
    required this.name,
    this.imagePaths,
    this.imageBytesList,
  });

  bool get isImageSelection =>
      (imagePaths != null && imagePaths!.isNotEmpty) ||
      (imageBytesList != null && imageBytesList!.isNotEmpty);
}

