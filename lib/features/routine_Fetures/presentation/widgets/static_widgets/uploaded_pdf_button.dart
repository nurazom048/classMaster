import 'package:classmate/core/helper/picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/export_core.dart';
import '../../../../notice_fetures/domain/interface/pdf_interface.dart'
    show PdfFileData;

final selectedPdfPathProvider = StateProvider<PdfFileData?>((ref) => null);
final addNoticeLoaderProvider = StateProvider<bool>((ref) => false);

class UploadPDFBButton extends StatelessWidget {
  final Function(PdfFileData?) onSelected;

  const UploadPDFBButton({
    required this.onSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF4FC),
        border: Border.all(color: const Color(0xFF0168FF)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Consumer(builder: (context, ref, _) {
        final pdfData = ref.watch(selectedPdfPathProvider);
        return InkWell(
          onTap: () async {
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
                  print('Selected PDF: $fileName');
                  final pdfFileData = PdfFileData(
                    path: null,
                    bytes: pdfBytes,
                    name: fileName,
                  );
                  ref
                      .read(selectedPdfPathProvider.notifier)
                      .update((state) => pdfFileData);
                  print('Provider updated with: ${pdfFileData.name}');
                  onSelected(pdfFileData);
                }
              }
            } else {
              String? path = await Picker.pickPDFFile();
              if (path != null) {
                print('Selected PDF path: $path');
                final pdfFileData = PdfFileData(
                  path: path,
                  bytes: null,
                  name: path.split('/').last,
                );
                ref
                    .read(selectedPdfPathProvider.notifier)
                    .update((state) => pdfFileData);
                print('Provider updated with: ${pdfFileData.name}');
                onSelected(pdfFileData);
              }
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                child: SizedBox(
                  width: 200,
                  child: Text(
                    pdfData?.name ?? 'Upload Notice File (PDF)',
                    style: TS.opensensBlue(),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Icon(Icons.file_upload_outlined, color: AppColor.nokiaBlue),
            ],
          ),
        );
      }),
    );
  }
}
