import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:mime/mime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../core/export_core.dart';
import '../../data/datasources/notice_request.dart';
import '../../domain/interface/pdf_interface.dart' show PdfFileData;
import '../providers/view_recent_notice_controller.dart';
import '../../../../core/widgets/widgets/custom_title_bar.dart';
import '../../../../core/widgets/widgets/mydrawer.dart';
import '../../../routine_Fetures/presentation/widgets/static_widgets/uploaded_pdf_button.dart';

class AddNoticeScreen extends ConsumerWidget {
  AddNoticeScreen({Key? key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController noticeTitleController = TextEditingController();
  final _appBar = const CustomTitleBar("title");

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pdfData = ref.watch(selectedPdfPathProvider);
    print('Building AddNoticeScreen, pdfData: ${pdfData?.name}');
    return SafeArea(
      child: Scaffold(
        body: Responsive(
          mobile: Scaffold(body: _mobile(context, ref, pdfData)),
          desktop: Scaffold(
            body: Row(
              children: [
                const Expanded(flex: 1, child: MyDrawer()),
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      _appBar,
                      Expanded(
                        child: Container(
                          color: Colors.yellow,
                          child: _mobile(context, ref, pdfData),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _mobile(BuildContext context, WidgetRef ref, PdfFileData? pdfData) {
    final isLoading = ref.watch(addNoticeLoaderProvider);
    final isLoadingNotifier = ref.watch(addNoticeLoaderProvider.notifier);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 40),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isMobile(context))
              HeaderTitle("Back to Home", context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "Add A New \nNotice",
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w300,
                      fontSize: 48.0,
                      height: 65 / 48,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  AppTextFromField(
                    margin: EdgeInsets.zero,
                    controller: noticeTitleController,
                    hint: "Notice Title",
                    labelText: "Enter Your notice title",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter notice title';
                      }
                      if (value.trim().length > 25) {
                        return 'Notice title cannot exceed 25 words';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  AppTextFromField(
                    margin: EdgeInsets.zero,
                    controller: descriptionController,
                    hint: "Notice Description",
                    labelText: "Describe what the notice is about.",
                  ).multiline(),
                  const SizedBox(height: 60),
                  UploadPDFBButton(onSelected: (pdfFileData) {
                    print('onSelected called with: ${pdfFileData}');
                  }),
                  const SizedBox(height: 60),
                  CupertinoButtonCustom(
                    icon: Icons.check,
                    isLoading: isLoading,
                    color: AppColor.nokiaBlue,
                    text: "Add Notice",
                    onPressed: () async {
                      final currentPdfData = ref.read(selectedPdfPathProvider);
                      print("pdf data in onPressed: ${currentPdfData?.name}");
                      if (_formKey.currentState!.validate()) {
                        if (currentPdfData == null) {
                          Alert.errorAlertDialog(context, "Select a PDF");
                          return;
                        }

                        if (kIsWeb) {
                          if (currentPdfData.bytes == null) {
                            Alert.errorAlertDialog(context, "PDF data missing");
                            return;
                          }
                          if (currentPdfData.bytes!.length > 10 * 1024 * 1024) {
                            Alert.errorAlertDialog(
                              context,
                              'Maximum file size allowed is 10 MB',
                            );
                            return;
                          }
                        } else {
                          File thePdf = File(currentPdfData.path!);
                          String? mimeType =
                              lookupMimeType(currentPdfData.path!);
                          if (mimeType != 'application/pdf') {
                            Alert.errorAlertDialog(
                                context, 'Only PDF files are allowed');
                            return;
                          }
                          if (thePdf.lengthSync() > 10 * 1024 * 1024) {
                            Alert.errorAlertDialog(
                              context,
                              'Maximum file size allowed is 10 MB',
                            );
                            return;
                          }
                        }

                        isLoadingNotifier.update((state) => true);
                        await addNotice(
                            context, currentPdfData, ref, isLoadingNotifier);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addNotice(BuildContext context, PdfFileData pdfData,
      WidgetRef ref, StateController<bool> isLoadingNotifier) async {
    Either<String, String> res = await NoticeRequest().addNotice(
      contentName: noticeTitleController.text,
      description: descriptionController.text,
      pdfFileData: pdfData,
      ref: ref,
    );
    res.fold((l) {
      isLoadingNotifier.update((state) => false);
      Alert.errorAlertDialog(context, l);
    }, (r) {
      ref.refresh(recentNoticeController(null));
      Navigator.pop(context);
      isLoadingNotifier.update((state) => false);
      Alert.showSnackBar(context, r);
    });
  }
}
