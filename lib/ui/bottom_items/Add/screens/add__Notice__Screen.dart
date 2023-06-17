// ignore_for_file: avoid_print, use_build_context_synchronously, must_be_immutable, camel_case_types, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/core/component/responsive.dart';
import 'package:table/core/dialogs/alart_dialogs.dart';
import 'package:table/ui/bottom_items/Home/notice_board/request/motice_request.dart';
import 'package:table/widgets/appWidget/TextFromFild.dart';
import 'package:table/widgets/heder/heder_title.dart';

import '../../../../constant/app_color.dart';
import '../../../../widgets/appWidget/buttons/cupertino_butttons.dart';
import '../../Home/widgets/custom_title_bar.dart';
import '../../Home/widgets/mydrawer.dart';
import '../widgets/uploaded_pdf_button.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

class AddNoticeScreen extends ConsumerWidget {
  AddNoticeScreen({Key? key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController noticeTitleController = TextEditingController();
  String? id;
  final _appBar = const ChustomTitleBar("title");

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //!provider
    final pdfpath = ref.watch(selectedPdfPathProvider);
    return SafeArea(
      child: Responsive(
        // Mobile
        mobile: Scaffold(
          body: _mobile(context, pdfpath),
        ),

        // Desktop
        desktop: Scaffold(
          body: Row(
            children: [
              Expanded(
                flex: 1,
                child: MyDawer(),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    _appBar,
                    Expanded(
                      child: Container(
                        color: Colors.yellow,
                        child: _mobile(context, pdfpath),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mobile(BuildContext context, String? pdfpath) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 400),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isMobile(context))
              HeaderTitle("Back to Home", context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0)
                  .copyWith(top: 25),
              child: const Text(
                "Add A New \nNotice",
                style: TextStyle(
                  fontFamily: 'Open Sans',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w300,
                  fontSize: 48.0,
                  height: 65 / 48, // This sets the line height to 65px
                  color: Colors.black,
                ),
              ),
            ),
            // SelectNoticeBoardDropDowen(
            //   onSelected: (iD) {
            //     print(iD);
            //     id = iD;
            //   },
            // ),
            AppTextFromField(
              controller: noticeTitleController,
              hint: "Notice Title",
              labelText: "Enter Your notice title",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter notice title';
                }
                return null;
              },
            ),
            AppTextFromField(
              controller: descriptionController,
              hint: "Notice Description",
              labelText: "Describe what the notice is about.",
            ).multiline(),
            const SizedBox(height: 60),
            UploadPDFBButton(onSelected: (thepath) {}),
            SizedBox(height: 200, width: 400, child: DragtoSelectFile()),
            const SizedBox(height: 60),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: CupertinoButtonCustom(
                color: AppColor.nokiaBlue,
                textt: "Add Notice",
                onPressed: () async {
                  print("pdf path : $pdfpath");
                  if (pdfpath == null) {
                    Alart.errorAlartDilog(context, "select pdf");
                  }
                  if (_formKey.currentState!.validate()) {
                    print("validate $pdfpath");
                    String res = await NoticeRequest().addNotice(
                      contentName: noticeTitleController.text,
                      description: descriptionController.text,
                      pdf_file: pdfpath,
                    );

                    Alart.showSnackBar(context, res);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///

class DragtoSelectFile extends ConsumerWidget {
  DragtoSelectFile({super.key});

  late DropzoneViewController controller1;

  Future<void> acceptfile(dynamic event, WidgetRef ref) async {
    try {
      final mime = await controller1.getFileMIME(event);
      final byte = await controller1.getFileSize(event);
      final url = await controller1.createFileUrl(event);

      print('Mime: $mime');
      print('Size : ${byte / (1024 * 1024)}');
      print('URL: $url');
      ref.watch(selectedPdfPathProvider.notifier).update((state) => url);
    } catch (e) {
      print("error: $e");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 100,
                child: DropzoneView(
                  // ignore: unnecessary_this
                  onCreated: (controller) => this.controller1 = controller,
                  onDrop: (value) => acceptfile(value, ref),
                ),
              ),
              InkWell(
                onTap: () async {
                  try {
                    final events = await controller1.pickFiles();

                    print("events: $events");
                    acceptfile(events[0], ref);
                  } catch (e) {
                    print("Error: $e");
                  }
                },
                child: const Text("Drop file here"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
