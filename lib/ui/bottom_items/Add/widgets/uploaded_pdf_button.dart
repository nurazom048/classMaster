import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/helper/picker.dart';

import '../../../../constant/app_color.dart';
import '../../../../widgets/appWidget/app_text.dart';

final selectedPdfPathProvider = StateProvider<String?>((ref) => null);

class UploadPDFBButton extends StatelessWidget {
  final Function(String?) onSelected;

  const UploadPDFBButton({
    required this.onSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFFEEF4FC),
          border: Border.all(color: const Color(0xFF0168FF)),
          borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Consumer(builder: (context, ref, _) {
        //!provider
        final pdfpath = ref.watch(selectedPdfPathProvider);
        return CupertinoButton(
          onPressed: () async {
            String? path = await picker.pickPDFFile();
            ref.watch(selectedPdfPathProvider.notifier).update((state) => path);
            onSelected(pdfpath);
          },
          color: const Color(0xFFEEF4FC),
          borderRadius: BorderRadius.circular(8),
          pressedOpacity: 0.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                child: SizedBox(
                  width: 200,
                  child: Text(
                    pdfpath ?? 'Upload Notice File (PDF)',
                    style: TS.opensensBlue(),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Icon(Icons.file_upload_outlined, color: AppColor.nokiaBlue)
            ],
          ),
        );
      }),
    );
  }
}
