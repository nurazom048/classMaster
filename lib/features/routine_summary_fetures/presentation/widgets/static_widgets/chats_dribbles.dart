// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:classmate/features/routine_summary_fetures/presentation/widgets/static_widgets/view_images.dart';
import 'package:expandable_text/expandable_text.dart';
import '../../../../../core/constant/enum.dart';
import '../../../../../core/export_core.dart';
import '../../../../home_fetures/presentation/utils/utils.dart';
import '../../../data/models/all_summary_models.dart';
import '../../providers/summary_controller.dart';
import '../../providers/summary_status.controller.dart';
import '../../screens/summary_screen.dart';

class ChatsDribbles extends StatelessWidget {
  final SummaryModel summary;

  const ChatsDribbles({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    // 🔍 DEBUG PRINT: Let's check what URLs this specific summary contains
    print("----------------------------");
    print("Summary ID: ${summary.id}");
    print("Raw Image Links Count: ${summary.imageLinks?.length}");
    print("Generated Full Image URLs: ${summary.fullImageLinks}");
    print("----------------------------");

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
            // 🔥 FIXED: Use fullImageLinks here instead of raw imageLinks
            if (summary.fullImageLinks.isNotEmpty) _buildImageGallery(),
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
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ViewImagesFullScreen(
                        images:
                            summary.owner?.image != null
                                ? [summary.owner!.image!]
                                : [DEMO_PROFILE_IMAGE],
                      ),
                ),
              ),
          child: Padding(
            padding: const EdgeInsets.only(top: 9),
            child: CircleAvatar(
              radius: 23,
              backgroundColor: Colors.black,
              backgroundImage: NetworkImage(
                summary.owner?.image ?? DEMO_PROFILE_IMAGE,
              ),
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
                          summary.owner?.name ?? "Unknown",
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
                        summary.createdAt != null
                            ? Utils.formatDate(summary.createdAt!)
                            : "Unknown Date",
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
                    onPressed:
                        () => showActionSheet(
                          context,
                          summary.id ?? '',
                          summary.classId ?? '',
                        ),
                    icon: const Icon(Icons.more_vert),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              const SizedBox(height: 2, width: 100, child: DotedDivider()),
              const SizedBox(height: 4),
              expendedText(context, summary.text ?? ''),
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
          constraints: const BoxConstraints(minHeight: 0, maxHeight: 100),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            // 🔥 FIXED: Read lengths and URLs from fullImageLinks
            itemCount: summary.fullImageLinks.length,
            itemBuilder: (context, index) {
              final imageUrl = summary.fullImageLinks[index];

              // 🔍 DEBUG PRINT: Check final computed url passed to Image.network
              debugPrint("Rendering Image.network with URL: -> '$imageUrl'");

              return InkWell(
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ViewImagesFullScreen(
                              images: summary.fullImageLinks,
                              initialPage: index,
                            ),
                      ),
                    ),
                child: Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // 🔍 PRINT ON RENDER FAILURE
                      debugPrint(
                        "❌ Failed to render image over Network Image Error: $error",
                      );
                      return const Center(
                        child: Icon(Icons.broken_image, color: Colors.grey),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CupertinoActivityIndicator());
                    },
                  ),
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
    print("SummaryId: $summaryID");
    final parentContext = context;

    showCupertinoModalPopup(
      context: parentContext,
      builder:
          (BuildContext context) => Consumer(
            builder: (context, ref, _) {
              final statusProvider = ref.watch(
                summaryStatusProvider(summaryID),
              );
              final statusNotifier = ref.watch(
                summaryStatusProvider(summaryID).notifier,
              );
              final summaryNotifier = ref.watch(
                summaryControllerProvider(classID).notifier,
              );

              return CupertinoActionSheet(
                title: Text(
                  'Do You Want To  ...? ',
                  style: TS.heading(fontSize: 19),
                ),
                actions: <Widget>[
                  statusProvider.when(
                    data: (data) {
                      final String save =
                          data.isSummarySaved == true
                              ? "saved    "
                              : "add to save     ";
                      final IconData saveIc =
                          data.isSummarySaved == true
                              ? Icons.bookmark_added
                              : Icons.bookmark_add;
                      return Column(
                        children: [
                          CupertinoActionSheetAction(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  save,
                                  style: const TextStyle(color: Colors.black),
                                ),
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
                            },
                          ),
                          if (data.isOwner || data.isCaptain) ...[
                            const SizedBox(height: 2, child: DotedDivider()),
                            CupertinoActionSheetAction(
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Delete    ',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  Icon(Icons.delete, color: Colors.red),
                                ],
                              ),
                              onPressed: () {
                                Alert.errorAlertDialogCallBack(
                                  context,
                                  "Are you sure You want to Delete This Summary",
                                  onConfirm: (isConfirmed) {
                                    if (isConfirmed) {
                                      summaryNotifier.deleteSummary(
                                        parentContext,
                                        summaryID,
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                          ],
                        ],
                      );
                    },
                    error:
                        (error, stackTrace) =>
                            Alert.handleError(context, error),
                    loading: () => Loaders.center(height: 100),
                  ),
                ],
              );
            },
          ),
    );
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
}
