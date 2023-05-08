// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/core/dialogs/alart_dialogs.dart';
import 'package:table/ui/bottom_items/Home/notice/notice%20controller/noticeRequest.dart';
import 'package:table/widgets/appWidget/TextFromFild.dart';
import 'package:table/widgets/appWidget/app_text.dart';
import 'package:table/helper/picker.dart';
import 'package:table/widgets/heder/heder_title.dart';
import 'package:flutter/material.dart' as ma;

import '../../../../constant/app_color.dart';
import '../../../../widgets/appWidget/buttons/cupertino_butttons.dart';

class AddNoticeScreen extends ConsumerWidget {
  AddNoticeScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController noticeTitleController = TextEditingController();
  String? id;
  String? pdfPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                        MyDropdownButton(
                          onSelected: (iD) {
                            print(iD);
                            id = iD;
                          },
                        ),
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
                        ),
                        const SizedBox(height: 60),
                        UploadPDFB_Button(
                          onSelected: (thePath) {
                            print("expected path $thePath");
                            pdfPath = thePath;
                          },
                        ),
                        const SizedBox(height: 60),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: CupertinoButtonCustom(
                            color: AppColor.nokiaBlue,
                            textt: "Add Notice",
                            onPressed: () async {
                              print("pdf path : $pdfPath");
                              if (pdfPath == null) {
                                Alart.errorAlartDilog(context, "select pdf");
                              }
                              if (_formKey.currentState!.validate() &&
                                  id != null) {
                                print("validate $pdfPath");
                                String res = await NoticeRequest().addNotice(
                                  content_name: noticeTitleController.text,
                                  description: descriptionController.text,
                                  noticeId: id,
                                  pdf_file: pdfPath,
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

class UploadPDFB_Button extends StatefulWidget {
  final Function(String?) onSelected;

  const UploadPDFB_Button({
    required this.onSelected,
    super.key,
  });

  @override
  State<UploadPDFB_Button> createState() => _UploadPDFB_ButtonState();
}

class _UploadPDFB_ButtonState extends State<UploadPDFB_Button> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFFEEF4FC),
          border: Border.all(color: const Color(0xFF0168FF)),
          borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: CupertinoButton(
        onPressed: () async {
          String? PAth = await picker.pickPDFFile();
          print("The apth is ");
          print(PAth);
          widget.onSelected(PAth);
        },
        color: const Color(0xFFEEF4FC),
        borderRadius: BorderRadius.circular(8),
        pressedOpacity: 0.8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ma.Text(
              'Upload Notice File (PDF)',
              style: TextStyle(
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                height: 1.36,
                color: Color(0xFF0168FF),
              ),
            ),
            const SizedBox(width: 20),
            Icon(Icons.file_upload_outlined, color: AppColor.nokiaBlue)
          ],
        ),
      ),
    );
  }
}

class MyDropdownButton extends StatefulWidget {
  final Function(String?) onSelected;

  const MyDropdownButton({
    Key? key,
    required this.onSelected,
  }) : super(key: key);

  @override
  _MyDropdownButtonState createState() => _MyDropdownButtonState();
}

class _MyDropdownButtonState extends State<MyDropdownButton> {
  int? _selectedItemIndex;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final noticeBoardList = ref.watch(createdNoticeBoardNmae);

      return Container(
        width: 340,
        height: 46,
        margin: const EdgeInsets.symmetric(horizontal: 17).copyWith(top: 20),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFEEF4FC),
          border: Border.all(color: const Color(0xFF0168FF)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: noticeBoardList.when(
          data: (data) {
            if (data == null)
              return const ma.Text("No Notice Board is not  created");

            return DropdownButtonHideUnderline(
              child: GestureDetector(
                onTap: () {
                  setState(() {});
                },
                child: DropdownButton<int?>(
                  value: _selectedItemIndex,
                  onChanged: (int? newIndex) {
                    setState(() {
                      _selectedItemIndex = newIndex;
                      if (_selectedItemIndex != null) {
                        widget.onSelected(
                            data.noticeBoards[_selectedItemIndex!].id);
                      }
                    });
                  },
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: const AppText(
                        'Select notice board',
                        color: Colors.grey,
                      ).heding(),
                    ),
                    ...data.noticeBoards
                        .asMap()
                        .map((index, notice) {
                          return MapEntry(
                            index,
                            DropdownMenuItem<int>(
                              value: index,
                              child: AppText(
                                notice.name,
                              ).heding(),
                            ),
                          );
                        })
                        .values
                        .toList(),
                  ],
                ),
              ),
            );
          },
          error: (error, stackTrace) => Alart.handleError(context, error),
          loading: () => const ma.Text("Loading"),
        ),
      );
    });
  }
}
