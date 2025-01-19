// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:classmate/core/component/loaders.dart';
import 'package:classmate/core/dialogs/alert_dialogs.dart';
import 'package:classmate/ui/bottom_nevbar_items/Home/Full_routine/Summary/widgets/view_images.dart';
import 'package:classmate/widgets/appWidget/app_text.dart';
import 'package:expandable_text/expandable_text.dart';
import '../../../../../../widgets/appWidget/dotted_divider.dart';
import '../../../utils/utils.dart';
import '../models/all_summary_models.dart';
import '../summat_screens/summary_screen.dart';
import '../Summary Controller/summary_controller.dart';
import '../Summary Controller/summary_status.controller.dart';

class ChatsDribbles extends StatelessWidget {
  final Summary summary;

  const ChatsDribbles({
    Key? key,
    required this.summary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 100,
        minWidth: double.infinity,
        maxHeight: 600,
      ),
      child: Container(
        width: 310,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFE4F0FF),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFD9D9D9)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOwnerInformation(context),
            if (summary.imageLinks.isNotEmpty) _buildImageGallery(),
          ],
        ),
      ),
    );
  }

  Widget _buildOwnerInformation(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => Get.to(() => ViewImagesFullScreen(
                images:
                    summary.owner.image != null ? [summary.owner.image!] : [],
              )),
          child: Padding(
            padding: const EdgeInsets.only(top: 9),
            child: CircleAvatar(
              radius: 23,
              backgroundColor: Colors.black,
              backgroundImage:
                  NetworkImage(summary.owner.image ?? DEMO_PROFILE_IMAGE),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 5),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.60,
                        child: Text(
                          summary.owner.name,
                          textScaleFactor: 1.4,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Text(
                        Utils.formatDate(summary.createdAt),
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Color(0xFF0168FF),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => showActionSheet(
                        context, summary.id, summary.classDetail.id),
                    icon: const Icon(Icons.more_vert),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              const SizedBox(
                height: 2,
                width: 100,
                child: DotedDivider(),
              ),

              //
              const SizedBox(height: 4),
              expendedText(
                context,
                summary.text,
                // textScaleFactor: 1.3,
                // style: const TextStyle(
                //   fontFamily: 'Inter',
                //   fontWeight: FontWeight.w400,
                //   fontSize: 14,
                //   height: 1.43,
                //   color: Colors.black,
                //   ),
                // maxLines: 3,
                // overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageGallery() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          constraints: const BoxConstraints(
            minHeight: 0,
            maxHeight: 100,
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: summary.imageLinks.length,
            itemBuilder: (context, index) {
              final imageUrl = summary.imageLinks[index];
              return InkWell(
                onTap: () => Get.to(() => ViewImagesFullScreen(
                      images: summary.imageLinks,
                      initialPage: index,
                    )),
                child: Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.network(imageUrl),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  void showActionSheet(BuildContext context, String summaryID, String classID) {
    // ignore: avoid_print
    print("SummaryId: $summaryID");
    final parentContext = context;

    showCupertinoModalPopup(
      context: parentContext,
      builder: (BuildContext context) => Consumer(builder: (context, ref, _) {
        //! Providers
        final statusProvider = ref.watch(summaryStatusProvider(summaryID));
        final statusNotifier =
            ref.watch(summaryStatusProvider(summaryID).notifier);
        final summaryNotifier =
            ref.watch(summaryControllerProvider(classID).notifier);

        return CupertinoActionSheet(
          title: Text('Do You Want To  ...? ', style: TS.heading(fontSize: 19)),
          // message: const Text('Select an action'),
          actions: <Widget>[
            statusProvider.when(
              data: (data) {
                final String save = data.isSummarySaved == true
                    ? "saved    "
                    : "add to save     ";
                final IconData saveIc = data.isSummarySaved == true
                    ? Icons.bookmark_added
                    : Icons.bookmark_add;
                return Column(
                  children: [
                    CupertinoActionSheetAction(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(save,
                                style: const TextStyle(color: Colors.black)),
                            Icon(saveIc),
                          ],
                        ),
                        onPressed: () {
                          statusNotifier.unsavedSummary(
                            parentContext,
                            summaryID: summaryID,
                            condition:
                                data.isSummarySaved == true ? false : true,
                          );
                        }),
                    if (data.isOwner || data.isCaptain) ...[
                      const SizedBox(height: 2, child: DotedDivider()),
                      CupertinoActionSheetAction(
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Delete    ',
                                style: TextStyle(color: Colors.red)),
                            Icon(Icons.delete, color: Colors.red),
                          ],
                        ),
                        onPressed: () {
                          Alert.errorAlertDialogCallBack(context,
                              "Are you sure You want to Delete This Summary",
                              onConfirm: () {
                            summaryNotifier.deleteSummary(
                                parentContext, summaryID);
                          });
                        },
                      ),
                    ]
                  ],
                );
              },
              error: (error, stackTrace) => Alert.handleError(context, error),
              loading: () => Loaders.center(height: 100),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(parentContext),
            child: const Text('Close'),
          ),
        );
      }),
    );
  }

  // void showActionSheet(BuildContext context, String summaryID, String classID) {
  //   print("SummaryId: $summaryID");
  //   final parentContext = context;

  //   showModalBottomSheet(
  //     context: parentContext,
  //     builder: (BuildContext context) => Consumer(builder: (context, ref, _) {
  //       //! Providers
  //       final statusProvider = ref.watch(summaryStatusProvider(summaryID));

  //       bool summarySaved = statusProvider.value?.isSummarySaved ?? false;
  //       bool isCaptain = statusProvider.value?.isCaptain ?? false;
  //       bool isOwner = statusProvider.value?.isOwner ?? false;
  //       final statusNotifier =
  //           ref.watch(summaryStatusProvider(summaryID).notifier);
  //       final summaryNotifier =
  //           ref.watch(summaryControllerProvider(classID).notifier);

  //       return Container(
  //         padding: const EdgeInsets.symmetric(vertical: 20),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.end,
  //           mainAxisSize: MainAxisSize.min,
  //           // title:
  //           // message: const Text('Select an action'),
  //           children: <Widget>[
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: [
  //                 if (isCaptain || isOwner)
  //                   SquareButton(
  //                     icon: Icons.delete,
  //                     text: "Delete",
  //                     color: Colors.red,
  //                     ontap: () {
  //                       Alert.errorAlertDialogCallBack(
  //                         context,
  //                         "Are you sure you want to delete this summary?",
  //                         onConfirm: () {
  //                           summaryNotifier.deletesummary(
  //                               parentContext, summaryID);
  //                         },
  //                       );
  //                     },
  //                   ),

  //                 //********* */

  //                 SquareButton(
  //                   inActiveIcon: Icons.bookmark_added,
  //                   icon: Icons.bookmark_add_sharp,
  //                   text: 'Save',
  //                   inActiveText: "add to save",
  //                   status: summarySaved == true ? true : false,
  //                   ontap: () {
  //                     bool condition = summarySaved == true ? false : true;
  //                     statusNotifier.unsavedSummary(
  //                       parentContext,

  //                       summaryID: summaryID,
  //                       condition: condition,
  //                     );
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       );
  //     }),
  //   );
}

Widget expendedText(BuildContext context, String longText) {
  return ExpandableText(
    longText,
    expandText: 'show more',
    collapseText: 'show less',
    maxLines: 3,
    linkColor: Colors.blue,
    style: const TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w400,
      fontSize: 16,
      height: 1.43,
      color: Colors.black,
    ),
  );
}
