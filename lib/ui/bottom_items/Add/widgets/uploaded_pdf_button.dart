import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:table/helper/picker.dart';

import '../../../../constant/app_color.dart';
import '../../../../widgets/appWidget/app_text.dart';

final selectedPdfPathProvider =
    StateProvider.autoDispose<Either<String, String?>?>((ref) => null);

class UploadPDFBButton extends StatelessWidget {
  final Function(String?) onSelected;

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
          borderRadius: BorderRadius.circular(8)),
      child: Consumer(builder: (context, ref, _) {
        //!provider
        final pdfPath = ref.watch(selectedPdfPathProvider);
        return InkWell(
          onTap: () async {
            Either<String, String?> path = await picker.pickPDFFile();
            ref.watch(selectedPdfPathProvider.notifier).update((state) => path);
            onSelected('pdfPath');
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                child: SizedBox(
                  width: 200,
                  child: Text(
                    pdfPath?.fold(
                            (l) => 'Upload Notice File (PDF)', (r) => '$r') ??
                        'Upload Notice File (PDF)',
                    style: TS.opensensBlue(),
                  ),
                ),
              ),
              Icon(Icons.file_upload_outlined, color: AppColor.nokiaBlue)
            ],
          ),
        );
      }),
    );
  }
}
