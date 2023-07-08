// ignore_for_file: avoid_print, use_build_context_synchronously, must_be_immutable, camel_case_types, library_private_types_in_public_api, unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:table/core/component/loaders.dart';
import 'package:table/core/component/responsive.dart';
import 'package:table/core/dialogs/alert_dialogs.dart';
import 'package:table/ui/bottom_items/Home/notice_board/request/motice_request.dart';
import 'package:table/widgets/appWidget/TextFromFild.dart';
import 'package:table/widgets/heder/heder_title.dart';

import '../../../../constant/app_color.dart';
import '../../../../widgets/appWidget/buttons/cupertino_buttons.dart';
import '../../Home/notice_board/notice controller/virew_recent_notice_controller.dart';
import '../../Home/widgets/custom_title_bar.dart';
import '../../Home/widgets/mydrawer.dart';
import '../widgets/uploaded_pdf_button.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

final addNoticeLoaderProvider = StateProvider<bool>((ref) => false);

class AddNoticeScreen extends ConsumerWidget {
  // ignore: use_key_in_widget_constructors
  AddNoticeScreen({Key? key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController noticeTitleController = TextEditingController();
  String? id;
  final _appBar = const CustomTitleBar("title");

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //!provider
    final pdfPath = ref.watch(selectedPdfPathProvider);

    return SafeArea(
      child: Scaffold(
        body: Responsive(
          // Mobile
          mobile: Scaffold(
            body: _mobile(context, ref, pdfPath),
          ),

          // Desktop
          desktop: Scaffold(
            body: Row(
              children: [
                const Expanded(
                  flex: 1,
                  child: MyDrawer(),
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      _appBar,
                      Expanded(
                        child: Container(
                          color: Colors.yellow,
                          child: _mobile(context, ref, pdfPath),
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

  Widget _mobile(
      BuildContext context, WidgetRef ref, Either<String, String?>? pdfPath) {
    //
    final isLoading = ref.watch(addNoticeLoaderProvider);
    final isLoadingNotifier = ref.watch(addNoticeLoaderProvider.notifier);

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
            //
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  const Text(
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
                  // SelectNoticeBoardDropDowen(
                  //   onSelected: (iD) {
                  //     print(iD);
                  //     id = iD;
                  //   },
                  // ),
                  SizedBox(height: 20),

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
                  SizedBox(height: 20),

                  AppTextFromField(
                    margin: EdgeInsets.zero,
                    controller: descriptionController,
                    hint: "Notice Description",
                    labelText: "Describe what the notice is about.",
                  ).multiline(),
                  const SizedBox(height: 60),
                  UploadPDFBButton(onSelected: (thePath) {}),
                  // SizedBox(height: 200, width: 400, child: drag'sSelectFile()),
                  const SizedBox(height: 60),
                  CupertinoButtonCustom(
                    icon: Icons.check,
                    isLoading: isLoading,
                    color: AppColor.nokiaBlue,
                    text: "Add Notice",
                    onPressed: () async {
                      isLoadingNotifier.update((state) => true);
                      print("pdf path : $pdfPath");

                      // if(pdfPath >10mb){

                      //     Alert.errorAlertDialog(context, "Only file allw under 10 mb");
                      // }

                      if (pdfPath == null) {
                        Alert.errorAlertDialog(context, "select pdf");
                      }
                      if (_formKey.currentState!.validate()) {
                        pdfPath?.fold((l) {
                          return Alert.errorAlertDialog(context, l);
                        }, (r) {
                          return addNotice(context, r!, ref, isLoadingNotifier);
                        });
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void addNotice(
      context, String pdfPath, WidgetRef ref, isLoadingNotifier) async {
    print("validate $pdfPath");
    // Either<String, String> res = await NoticeRequest().addNotice(
    //   contentName: noticeTitleController.text,
    //   description: descriptionController.text,
    //   pdfFile: pdfPath,
    //   ref: ref,
    // );
    // res.fold((l) {
    //   isLoadingNotifier.update((state) => false);

    //   return Alert.errorAlertDialog(context, l);
    // }, (r) {
    //   ref.refresh(recentNoticeController(null));

    //   Navigator.pop(context);
    //   isLoadingNotifier.update((state) => false);

    //   return Alert.showSnackBar(context, r);
    // });
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
      //ref.watch(selectedPdfPathProvider.notifier).update((state) => url);
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
