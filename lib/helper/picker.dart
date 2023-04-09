import 'package:file_picker/file_picker.dart';
import 'package:table/helper/helper_fun.dart';

class picker extends HelperMethods {
  //!___ Pick Pdf.....//
  static Future<String?> pickPDFFile() async {
    // Pick a PDF file from the device
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    // If no file was picked, return null
    if (result == null) {
      return null;
    }

    // Get the PDF file path
    final path = result.files.single.path;

    // Return the PDF file path
    return path;
  }
}
