import 'package:classmate/core/dialogs/alert_dialogs.dart';
import 'package:classmate/core/helper/picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/export_core.dart';
import '../../../../notice_fetures/domain/interface/pdf_interface.dart'
    show PdfFileData;

final selectedPdfPathProvider = StateProvider<PdfFileData?>((ref) => null);
final addNoticeLoaderProvider = StateProvider<bool>((ref) => false);

class UploadPDFButton extends StatelessWidget {
  final Function(PdfFileData?) onSelected;

  const UploadPDFButton({required this.onSelected, super.key});

  Future<void> _pickPdf(BuildContext context, WidgetRef ref) async {
    if (kIsWeb) {
      print('Click to select PDF on web');
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.isNotEmpty) {
        Uint8List? pdfBytes = result.files.first.bytes;
        String fileName = result.files.first.name;

        if (pdfBytes != null) {
          final pdfFileData = PdfFileData(
            path: null,
            bytes: pdfBytes,
            name: fileName,
          );
          ref
              .read(selectedPdfPathProvider.notifier)
              .update((state) => pdfFileData);
          onSelected(pdfFileData);
        }
      }
    } else {
      String? path = await Picker.pickPDFFile();
      if (path != null) {
        final pdfFileData = PdfFileData(
          path: path,
          bytes: null,
          name: path.split('/').last,
        );
        ref
            .read(selectedPdfPathProvider.notifier)
            .update((state) => pdfFileData);
        onSelected(pdfFileData);
      }
    }
  }

  Future<void> _pickImages(BuildContext context, WidgetRef ref) async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();

    if (images.isEmpty) return;

    if (images.length > 10) {
      if (context.mounted) {
        Alert.errorAlertDialog(
          context,
          'Maximum 10 images are allowed at once.',
        );
      }
      return;
    }

    if (kIsWeb) {
      List<Uint8List> bytesList = [];
      for (var img in images) {
        final bytes = await img.readAsBytes();
        bytesList.add(bytes);
      }
      final pdfFileData = PdfFileData(
        name: '${images.length} Image(s) Selected',
        imageBytesList: bytesList,
      );
      ref
          .read(selectedPdfPathProvider.notifier)
          .update((state) => pdfFileData);
      onSelected(pdfFileData);
    } else {
      List<String> paths = images.map((e) => e.path).toList();
      final pdfFileData = PdfFileData(
        name: '${images.length} Image(s) Selected',
        imagePaths: paths,
      );
      ref
          .read(selectedPdfPathProvider.notifier)
          .update((state) => pdfFileData);
      onSelected(pdfFileData);
    }
  }

  void _showSelectionSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Text(
                  "Select Attachment Type",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFEEF4FC),
                    child: Icon(Icons.picture_as_pdf, color: Color(0xFF0168FF)),
                  ),
                  title: const Text("Select PDF File"),
                  subtitle: const Text("Upload existing PDF document"),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickPdf(context, ref);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFEEF4FC),
                    child: Icon(Icons.photo_library, color: Color(0xFF0168FF)),
                  ),
                  title: const Text("Select Images (Max 10)"),
                  subtitle: const Text("Images will be converted to PDF"),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickImages(context, ref);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF4FC),
        border: Border.all(color: const Color(0xFF0168FF)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Consumer(
        builder: (context, ref, _) {
          final pdfData = ref.watch(selectedPdfPathProvider);
          return InkWell(
            onTap: () => _showSelectionSheet(context, ref),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  child: SizedBox(
                    width: 220,
                    child: Text(
                      pdfData?.name ?? 'Upload Notice File (PDF/Images)',
                      style: TS.opensensBlue(),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.file_upload_outlined, color: AppColor.nokiaBlue),
              ],
            ),
          );
        },
      ),
    );
  }
}

