// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:mime/mime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/export_core.dart';
import '../../data/datasources/notice_request.dart';
import '../../domain/interface/pdf_interface.dart' show PdfFileData;
import '../providers/view_recent_notice_controller.dart';
import '../../../../core/widgets/widgets/custom_title_bar.dart';
import '../../../../core/widgets/widgets/mydrawer.dart';
import '../../../routine/presentation/widgets/static_widgets/uploaded_pdf_button.dart';
import '../widgets/static_widgets/catagori_selector.widgets.dart'
    show CategorySelector;

// ignore: must_be_immutable
class AddNoticeScreen extends ConsumerWidget {
  AddNoticeScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController noticeTitleController = TextEditingController();
  final _appBar = const CustomTitleBar("title");

  // 🎯 Default Selected Category State
  String selectedCategory = 'notice';

  // List of Categories
  final List<Map<String, String>> categories = [
    {'key': 'job_circular', 'label': 'Job Circular'},
    {'key': 'notice', 'label': 'Notice'},
    {'key': 'result', 'label': 'Result'},
    {'key': 'other', 'label': 'Other'},
  ];

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
                    "Add A New Notice",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
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
                  UploadPDFButton(
                    onSelected: (pdfFileData) {
                      print('onSelected called with: $pdfFileData');
                    },
                  ),
                  const SizedBox(height: 20),

                  // Category Selector Custom Widget
                  CategorySelector(
                    initialCategory: selectedCategory,
                    onCategorySelected: (String newCategory) {
                      selectedCategory = newCategory;
                    },
                  ),

                  const SizedBox(height: 20),
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
                          String? mimeType = lookupMimeType(
                            currentPdfData.path!,
                          );
                          if (mimeType != 'application/pdf') {
                            Alert.errorAlertDialog(
                              context,
                              'Only PDF files are allowed',
                            );
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
                          context,
                          currentPdfData,
                          ref,
                          isLoadingNotifier,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addNotice(
    BuildContext context,
    PdfFileData pdfData,
    WidgetRef ref,
    StateController<bool> isLoadingNotifier,
  ) async {
    try {
      Either<String, String> res = await NoticeRequest().addNotice(
        contentName: noticeTitleController.text,
        description: descriptionController.text,
        category: selectedCategory, // Passes the updated value directly
        pdfFileData: pdfData,
        ref: ref,
      );

      res.fold(
        (l) {
          isLoadingNotifier.update((state) => false);
          Alert.errorAlertDialog(context, l);
        },
        (r) {
          // ignore: unused_result
          ref.refresh(recentNoticeController(null));
          Navigator.pop(context);
          isLoadingNotifier.update((state) => false);
          Alert.showSnackBar(context, r);
        },
      );
    } catch (e) {
      isLoadingNotifier.update((state) => false);
      Alert.errorAlertDialog(context, e.toString());
    }
  }
}
