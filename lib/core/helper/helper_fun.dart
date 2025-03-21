// ignore_for_file: avoid_print, unnecessary_null_comparison

import 'package:classmate/core/constant/enum.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img; // Alias to avoid conflicts
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';

class Multiple {
  static Future<List<XFile>?> pickAndCompressMultipleImages() async {
    print('Starting image picker');
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    print('Picker completed');

    if (pickedFiles == null || pickedFiles.isEmpty) {
      print('No images picked');
      return null;
    }

    print('Picked ${pickedFiles.length} images');
    List<XFile> compressedImages = [];

    for (var pickedFile in pickedFiles) {
      print('Processing image: ${pickedFile.path}');
      final imageBytes = await pickedFile.readAsBytes();
      final originalSize = imageBytes.length;
      print('Original size: ${originalSize ~/ 1024} KB');

      // Decode the image
      img.Image? decodedImage = img.decodeImage(imageBytes);
      if (decodedImage == null) {
        print('Failed to decode image: ${pickedFile.path}');
        continue;
      }

      // Resize to minHeight: 800, minWidth: 800 while maintaining aspect ratio
      img.Image resizedImage = img.copyResize(
        decodedImage,
        width: decodedImage.width > 800 ? 800 : decodedImage.width,
        height: decodedImage.height > 800 ? 800 : decodedImage.height,
        //maintainAspect: true,
      );

      // Compress to JPEG with quality 70
      final Uint8List compressedBytes = Uint8List.fromList(
        img.encodeJpg(resizedImage, quality: 70),
      );
      final compressedSize = compressedBytes.length;
      print('Compressed size: ${compressedSize ~/ 1024} KB');

      if (kIsWeb) {
        // Web: Create XFile from bytes
        final compressedXFile = XFile.fromData(
          compressedBytes,
          name: pickedFile.name,
          mimeType: 'image/jpeg',
        );
        compressedImages.add(compressedXFile);
        print('Web: Compressed image added - ${compressedXFile.path}');
      } else {
        // Native: Save to temp directory
        final directory = await getTemporaryDirectory();
        final path =
            '${directory.path}/${DateTime.now().millisecondsSinceEpoch}_${pickedFile.name}';

        print('Compressed image path: $path');
        compressedImages.add(XFile(path));
      }
    }

    print('Total images picked and compressed: ${compressedImages.length}');
    return compressedImages.isNotEmpty ? compressedImages : null;
  }

  static String getAccountType(String? type) {
    if (type == null) {
      return AccountTypeString.user;
    }

    final String accountType = type.toLowerCase();

    if (accountType == AccountTypeString.student) {
      return AccountTypeString.user;
    } else if (accountType == AccountTypeString.academy) {
      return AccountTypeString.academy;
    } else {
      return AccountTypeString.user;
    }
  }
}
