import 'package:flutter/foundation.dart';

class PdfFileData {
  final String? path;
  final Uint8List? bytes;
  final String name;

  PdfFileData({this.path, this.bytes, required this.name});
}
