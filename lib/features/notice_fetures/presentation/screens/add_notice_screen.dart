// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:mime/mime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/component/rich_text_editor/app_quill_editor.dart';
import '../../../../core/export_core.dart';
import '../../data/datasources/notice_request.dart';
import '../../domain/interface/pdf_interface.dart' show PdfFileData;
import '../providers/view_recent_notice_controller.dart';
import '../../../../core/widgets/widgets/custom_title_bar.dart';
import '../../../../core/widgets/widgets/mydrawer.dart';
import '../../../routine_fetures/presentation/widgets/static_widgets/uploaded_pdf_button.dart';
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

    return DesktopLayoutWrapper(
      child: SafeArea(child: Scaffold(body: _mobile(context, ref, pdfData))),
    );
  }

  Widget _mobile(BuildContext context, WidgetRef ref, PdfFileData? pdfData) {
    final isLoading = ref.watch(addNoticeLoaderProvider);
    final isLoadingNotifier = ref.watch(addNoticeLoaderProvider.notifier);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 10),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  const Text(
                    "Notice Description",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0168FF),
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppQuillEditor(
                    hintText: "Describe what the notice is about...",
                    minHeight: 150,
                    onChanged: (jsonStr) {
                      descriptionController.text = jsonStr;
                    },
                  ),
                  const SizedBox(height: 40),
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
                          Alert.errorAlertDialog(context, "Select a PDF or image file");
                          return;
                        }

                        if (currentPdfData.isImageSelection) {
                          final imgCount = (currentPdfData.imagePaths?.length ??
                              currentPdfData.imageBytesList?.length ??
                              0);
                          if (imgCount == 0) {
                            Alert.errorAlertDialog(context, "Select a PDF or image file");
                            return;
                          }
                          if (imgCount > 10) {
                            Alert.errorAlertDialog(
                              context,
                              "Maximum 10 images allowed at once",
                            );
                            return;
                          }
                        } else {
                          if (kIsWeb) {
                            if (currentPdfData.bytes == null) {
                              Alert.errorAlertDialog(context, "Notice file missing");
                              return;
                            }
                            if (currentPdfData.bytes!.length > 15 * 1024 * 1024) {
                              Alert.errorAlertDialog(
                                context,
                                'Maximum file size allowed is 15 MB',
                              );
                              return;
                            }
                          } else {
                            if (currentPdfData.path != null) {
                              File selectedFile = File(currentPdfData.path!);
                              if (!selectedFile.existsSync()) {
                                Alert.errorAlertDialog(context, "Selected file does not exist");
                                return;
                              }
                              String? mimeType = lookupMimeType(
                                currentPdfData.path!,
                              );
                              String ext = currentPdfData.path!.split('.').last.toLowerCase();
                              bool isPdf = (mimeType == 'application/pdf') || (ext == 'pdf');
                              bool isImage = (mimeType != null && mimeType.startsWith('image/')) ||
                                  ['jpg', 'jpeg', 'png', 'webp', 'heic'].contains(ext);

                              if (!isPdf && !isImage) {
                                Alert.errorAlertDialog(
                                  context,
                                  'Invalid file type. Only PDF and image files (JPG, PNG, WEBP) are allowed.',
                                );
                                return;
                              }
                              if (selectedFile.lengthSync() > 15 * 1024 * 1024) {
                                Alert.errorAlertDialog(
                                  context,
                                  'Maximum file size allowed is 15 MB',
                                );
                                return;
                              }
                            } else if (currentPdfData.bytes == null) {
                              Alert.errorAlertDialog(context, "Select a PDF or image file");
                              return;
                            }
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
