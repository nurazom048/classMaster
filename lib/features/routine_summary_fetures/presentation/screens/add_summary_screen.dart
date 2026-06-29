// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classmate/features/routine_summary_fetures/domain/providers/summary_controller.dart';
import 'package:badges/badges.dart' as badges;
import 'package:mime/mime.dart';
import 'package:image_picker/image_picker.dart';
import 'package:classmate/core/helper/helper_fun.dart';
import '../../../../core/export_core.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'dart:io' show File;

final loaderProvider = StateProvider<bool>((ref) => false);

class AddSummaryScreen extends ConsumerStatefulWidget {
  const AddSummaryScreen({
    super.key,
    required this.classId,
    required this.routineId,
  });

  final String classId;
  final String routineId;

  @override
  ConsumerState<AddSummaryScreen> createState() => _AddSummaryScreenState();
}

final _summaryController = TextEditingController();
final GlobalKey<FormState> formKey = GlobalKey<FormState>();

// ✅ Helper function to check if file is an image
bool isImageFile(String fileName) {
  final name = fileName.toLowerCase();
  return name.endsWith('.png') ||
      name.endsWith('.jpg') ||
      name.endsWith('.jpeg') ||
      name.endsWith('.gif') ||
      name.endsWith('.webp');
}

class _AddSummaryScreenState extends ConsumerState<AddSummaryScreen> {
  List<XFile> imageLinks = [];

  @override
  void initState() {
    super.initState();
    print('AddSummaryScreen initialized');
  }

  @override
  Widget build(BuildContext context) {
    print('Building AddSummaryScreen');
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderTitle("Back", context),
              const SizedBox(height: 30),
              Text('  Write Summary', style: TS.heading(fontSize: 36)),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Consumer(
                  builder: (context, ref, _) {
                    print('Consumer builder called');
                    final addSummary = ref.read(
                      summaryControllerProvider(widget.classId).notifier,
                    );
                    final isLoading = ref.watch(loaderProvider);

                    return Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _summaryController,
                            maxLines: 5,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Write Summary',
                              hintStyle: TextStyle(
                                fontFamily: 'Open Sans',
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w300,
                                fontSize: 20,
                                height: 1.27,
                                color: Color(0xFF333333),
                              ),
                            ),
                            validator:
                                (value) =>
                                    value?.isEmpty ?? true
                                        ? 'Please enter the summary'
                                        : null,
                          ),
                          Container(
                            constraints: const BoxConstraints(
                              minHeight: 0,
                              maxHeight: 100,
                            ),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: imageLinks.length,
                              itemBuilder: (context, index) {
                                print(
                                  'Rendering file ${index + 1}/${imageLinks.length}: ${imageLinks[index].name}',
                                );
                                return Container(
                                  alignment: Alignment.centerLeft,
                                  width: 130,
                                  height: 130,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: badges.Badge(
                                    onTap: () {
                                      print('Removing file at index $index');
                                      setState(
                                        () => imageLinks.removeAt(index),
                                      );
                                    },
                                    badgeContent: const Icon(Icons.close),
                                    child:
                                        isImageFile(imageLinks[index].name)
                                            ? (kIsWeb
                                                ? FutureBuilder<Uint8List>(
                                                  future:
                                                      imageLinks[index]
                                                          .readAsBytes(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      print(
                                                        'Image bytes loaded for index $index',
                                                      );
                                                      return Image.memory(
                                                        snapshot.data!,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) {
                                                          print(
                                                            'Error displaying web image: $error',
                                                          );
                                                          return const Icon(
                                                            Icons.error,
                                                          );
                                                        },
                                                      );
                                                    } else if (snapshot
                                                        .hasError) {
                                                      print(
                                                        'Error loading web image bytes: ${snapshot.error}',
                                                      );
                                                      return const Icon(
                                                        Icons.error,
                                                      );
                                                    }
                                                    print(
                                                      'Loading image bytes for index $index',
                                                    );
                                                    return const CircularProgressIndicator();
                                                  },
                                                )
                                                : Image.file(
                                                  File(imageLinks[index].path),
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) {
                                                    print(
                                                      'Error loading native image: $error',
                                                    );
                                                    return const Icon(
                                                      Icons.error,
                                                    );
                                                  },
                                                ))
                                            : Container(
                                              color: Colors.grey[200],
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    imageLinks[index].name
                                                            .toLowerCase()
                                                            .endsWith('.pdf')
                                                        ? Icons.picture_as_pdf
                                                        : Icons.description,
                                                    size: 40,
                                                    color:
                                                        imageLinks[index].name
                                                                .toLowerCase()
                                                                .endsWith(
                                                                  '.pdf',
                                                                )
                                                            ? Colors.redAccent
                                                            : Colors.blueAccent,
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    imageLinks[index].name,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                  ),
                                );
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              print('File picker button pressed');
                              final imagelink =
                                  await Multiple.pickAndCompressMultipleImages();
                              if (imagelink != null) {
                                print('Files picked: ${imagelink.length}');
                                setState(() {
                                  imageLinks.addAll(imagelink);
                                  print(
                                    'Files added to list: ${imageLinks.length}',
                                  );
                                });
                              } else {
                                print('No files selected from picker');
                              }
                            },
                            icon: const Icon(Icons.add),
                          ),
                          if (isLoading)
                            Loaders.center(height: 50)
                          else
                            CupertinoButtonCustom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              color: AppColor.nokiaBlue,
                              text: "Add Summary Now",
                              onPressed: () async {
                                print('Add Summary button pressed');
                                if (formKey.currentState?.validate() ?? false) {
                                  print('Form validated, checking file types');
                                  bool isFileTypeValid = await checkedFileType(
                                    imageLinks,
                                  );
                                  print(
                                    'File type check result: $isFileTypeValid',
                                  );
                                  bool isUploadLimitValid =
                                      checkedMaxUploadLimit(imageLinks);
                                  print(
                                    'Upload limit check result: $isUploadLimitValid',
                                  );

                                  if (isFileTypeValid && isUploadLimitValid) {
                                    print('Proceeding to add summary');
                                    addSummary.addSummary(
                                      ref,
                                      context,
                                      classId: widget.classId,
                                      routineId: widget.routineId,
                                      message: _summaryController.text,
                                      imageLinks: imageLinks,
                                      checkedType: true,
                                    );
                                  } else {
                                    print(
                                      'Validation failed, not adding summary',
                                    );
                                  }
                                } else {
                                  print('Form validation failed');
                                  Alert.showSnackBar(context, 'Enter the form');
                                }
                              },
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> checkedFileType(List<XFile> imageLinks) async {
    print('Checking file types for ${imageLinks.length} files');

    // অনুমোদিত এক্সটেনশন ও মাইম টাইপ লিস্ট
    final allowedExtensions = [
      '.png',
      '.jpg',
      '.jpeg',
      '.gif',
      '.webp',
      '.pdf',
      '.doc',
      '.docx',
      '.xls',
      '.xlsx',
    ];

    for (var image in imageLinks) {
      final mimeType = lookupMimeType(image.path) ?? image.mimeType ?? '';
      final fileName = image.name.toLowerCase();

      final sizeInBytes =
          kIsWeb
              ? (await image.readAsBytes()).length
              : File(image.path).lengthSync();

      print(
        'File: $fileName, MIME: $mimeType, Size: ${sizeInBytes ~/ 1024} KB',
      );

      // এক্সটেনশন চেক করা হচ্ছে
      bool hasValidExt = allowedExtensions.any((ext) => fileName.endsWith(ext));

      if (!hasValidExt) {
        print('Invalid file type for: $fileName');
        Alert.errorAlertDialog(
          context,
          'Only Images, PDF, Word, and Excel files are allowed',
        );
        return false;
      }

      if (sizeInBytes > 10 * 1024 * 1024) {
        // 10MB limit
        print('File too large: ${sizeInBytes ~/ 1024} KB');
        Alert.errorAlertDialog(context, 'Maximum file size allowed is 10 MB');
        return false;
      }
    }
    print('All files passed checks');
    return true;
  }

  bool checkedMaxUploadLimit(List<XFile> imageLinks) {
    print('Checking upload limit: ${imageLinks.length} files');
    if (imageLinks.length > 9) {
      print('Too many files: ${imageLinks.length} > 9');
      Alert.errorAlertDialog(context, 'Maximum file limit allowed is 10');
      return false;
    }
    print('Upload limit check passed');
    return true;
  }
}
