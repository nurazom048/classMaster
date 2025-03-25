// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';

import '../../../../core/export_core.dart';

class PdfUtils {
  // Clear all cached PDFs (called during logout or timer)
  static Future<void> clearPdfCache() async {
    if (kIsWeb) return; // No caching on web, so nothing to clear

    try {
      final directory = await getApplicationDocumentsDirectory();
      final dir = Directory(directory.path);
      final files = dir.listSync(); // List all files in the directory

      for (var file in files) {
        if (file is File && file.path.endsWith('.pdf')) {
          await file.delete(); // Delete each PDF file
          print('Deleted cached PDF: ${file.path}');
        }
      }

      // Update the last clear time after clearing
      await _updateLastClearTime(directory);
    } catch (e) {
      print('Error clearing PDF cache: $e');
    }
  }

  // Helper to update the last cache clear time in a file
  static Future<void> _updateLastClearTime(Directory directory) async {
    final clearTimeFile = File('${directory.path}/last_pdf_clear.txt');
    final now = DateTime.now().millisecondsSinceEpoch.toString();
    await clearTimeFile.writeAsString(now);
    print('Updated last clear time: $now');
  }

  // Helper to read the last cache clear time
  static Future<DateTime?> _getLastClearTime(Directory directory) async {
    final clearTimeFile = File('${directory.path}/last_pdf_clear.txt');
    if (await clearTimeFile.exists()) {
      final timeStr = await clearTimeFile.readAsString();
      return DateTime.fromMillisecondsSinceEpoch(int.parse(timeStr));
    }
    return null; // No previous clear time recorded
  }

  // Initialize periodic cache clearing (e.g., every 24 hours)
  static void initializeCacheClearTimer() {
    if (kIsWeb) return; // No caching on web

    const cacheDuration = Duration(hours: 24); // Clear cache every 24 hours

    Timer.periodic(const Duration(minutes: 1), (timer) async {
      // Check every minute to avoid excessive I/O
      final directory = await getApplicationDocumentsDirectory();
      final lastClearTime = await _getLastClearTime(directory);

      if (lastClearTime == null ||
          DateTime.now().difference(lastClearTime) >= cacheDuration) {
        print('Time to clear PDF cache');
        await clearPdfCache();
      }
    });
  }

  // Constructs the proxy URL for fetching the PDF
  static String getProxiedPdfUrl(pdfLink) {
    final baseUrl = '${Const.BASE_URl}/proxy-pdf'; // Base URL from constants
    return '$baseUrl?url=${Uri.encodeQueryComponent(pdfLink)}';
  }
}
