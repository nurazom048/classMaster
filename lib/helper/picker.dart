import 'package:file_picker/file_picker.dart';
import 'package:classmate/helper/helper_fun.dart';

class Picker extends HelperMethods {
  //!___ Pick Pdf.....//
  static Future<String?> pickPDFFile() async {
    try {
      // Pick a PDF file from the device
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      // If no file was picked, return null
      if (result == null) {
        return null;
      }

      // Get the PDF file bytes
      final bytes = result.files.single.bytes;
      // ignore: avoid_print
      print(bytes);

      final path = result.paths[0];

      // Return the PDF file path (or any other necessary information)
      return path;
    } catch (e) {
      // ignore: avoid_print
      print("pdf picker err: $e");
      return null;
    }
  }
}
