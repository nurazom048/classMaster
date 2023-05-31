// ignore_for_file: avoid_print, use_build_context_synchronously, must_be_immutable, camel_case_types, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/core/dialogs/alart_dialogs.dart';
import 'package:table/ui/bottom_items/Home/notice_board/request/noticeboard_noticeRequest.dart';
import 'package:table/widgets/appWidget/TextFromFild.dart';
import 'package:table/widgets/heder/heder_title.dart';
import 'package:flutter/material.dart' as ma;

import '../../../../constant/app_color.dart';
import '../../../../widgets/appWidget/buttons/cupertino_butttons.dart';
import '../widgets/uploaded_pdf_button.dart';

class AddNoticeScreen extends ConsumerWidget {
  AddNoticeScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController noticeTitleController = TextEditingController();
  String? id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //!provider
    final pdfpath = ref.watch(selectedPdfPathProvider);
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 400),
                child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeaderTitle("Back to Home", context),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0)
                              .copyWith(top: 25),
                          child: const ma.Text(
                            "Add A New \nNotice",
                            style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w300,
                              fontSize: 48.0,
                              height:
                                  65 / 48, // This sets the line height to 65px
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
                              if (_formKey.currentState!.validate() &&
                                  id != null) {
                                print("validate $pdfpath");
                                String res = await NoticeRequest().addNotice(
                                  content_name: noticeTitleController.text,
                                  description: descriptionController.text,
                                  noticeId: id,
                                  pdf_file: pdfpath,
                                );

                                Alart.showSnackBar(context, res);
                              }
                            },
                          ),
                        ),
                      ],
                    )))));
  }
}
