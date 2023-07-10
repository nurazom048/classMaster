// ignore_for_file: camel_case_types

// import 'package:file_picker/file_picker.dart';
// import 'package:table/helper/helper_fun.dart';

// class picker extends HelperMethods {
//   //!___ Pick Pdf.....//
//   static Future<String?> pickPDFFile() async {
//     try {
//       // Pick a PDF file from the device
//       final result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowMultiple: false,
//         allowedExtensions: ['pdf'],
//       );

//       // If no file was picked, return null
//       if (result == null) {
//         return null;
//       }

//       // Get the PDF file path
//       final path = result.files.single.path;

//       // Return the PDF file path
//       return path;
//     } catch (e) {
//       print("pdf picker err: $e");
//       return null;
//     }
//   }
// }
import 'package:file_picker/file_picker.dart';
import 'package:fpdart/fpdart.dart';
import 'package:table/helper/helper_fun.dart';

class picker extends HelperMethods {
  //!___ Pick Pdf.....//

  static Future<Either<String, String?>> pickPDFFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result == null) {
        return left('select pdf file');
      }

      final bytes = result.files.single.bytes;
      final fileSizeInMB = bytes!.lengthInBytes / (1024 * 1024);

      if (fileSizeInMB > 10) {
        // Show an error message if the file size exceeds 10 MB
        return left('file only allow uner 10 mb');
      }

      final path = result.paths[0];
      return right(path);
    } catch (e) {
      return left('error:$e');
    }
  }
}
