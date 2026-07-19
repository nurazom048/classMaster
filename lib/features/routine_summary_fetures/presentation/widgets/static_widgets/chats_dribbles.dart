// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:classmate/features/routine_summary_fetures/presentation/widgets/static_widgets/view_images.dart';
import 'package:expandable_text/expandable_text.dart';
import '../../../../../core/constant/enums.dart';
import '../../../../../core/export_core.dart';
import '../../../../home_fetures/presentation/utils/utils.dart';
import '../../../data/models/all_summary_models.dart';
import '../../../domain/providers/summary_controller.dart';
import '../../../domain/providers/summary_status.controller.dart';
import '../../screens/summary_screen.dart';
import '../../../../../core/local_data/local_data.dart';

class ChatsDribbles extends ConsumerWidget {
  final SummaryModel summary;

  const ChatsDribbles({super.key, required this.summary});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Check if System message
    if (summary.type == SummaryType.SYSTEM) {
      return _buildSystemMessage(context);
    }

    // 2. Standard Chat Bubble
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F8FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2EEFF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOwnerInformation(context),
          const SizedBox(height: 8),
          
          // Render Poll if type is POLL
          if (summary.type == SummaryType.POLL && summary.pollOptions != null)
            _buildPollWidget(context, ref)
          else ...[
            // Text Message with Link support
            _buildTextMessage(context),
            
            // Media file preview
            if (summary.imageLinks != null && summary.imageLinks!.isNotEmpty)
              _buildMediaPreview(context),
          ],
          
          const SizedBox(height: 8),
          const Divider(height: 1, color: Color(0xFFE0E0E0)),
          const SizedBox(height: 6),
          // Auto Deletion Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "⏳ Deletes in ${summary.daysUntilDeletion} days",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.orange[800],
                ),
              ),
              if (summary.type == SummaryType.POLL)
                const Text(
                  "📊 Interactive Poll",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSystemMessage(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.amber[50]!.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.amber[900], size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              summary.text ?? "System Alert",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.amber[900],
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPollWidget(BuildContext context, WidgetRef ref) {
    final options = summary.pollOptions ?? [];
    
    // Calculate total votes
    int totalVotes = 0;
    for (var opt in options) {
      totalVotes += opt.votes.length;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            summary.text ?? "Cast your vote:",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        ...List.generate(options.length, (index) {
          final opt = options[index];
          final voteCount = opt.votes.length;
          final percent = totalVotes > 0 ? (voteCount / totalVotes) : 0.0;
          
          return InkWell(
            onTap: () {
              ref.read(summaryControllerProvider(summary.classId).notifier)
                 .voteSummaryPoll(context, summary.id!, index);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue[100]!),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    // Percentage progress background bar
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Container(
                          width: constraints.maxWidth * percent,
                          height: 48,
                          color: Colors.blue[50],
                        );
                      }
                    ),
                    // Text display
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            opt.option,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            "$voteCount votes (${(percent * 100).toStringAsFixed(0)}%)",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
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
        }),
        Padding(
          padding: const EdgeInsets.only(top: 8, left: 4),
          child: Text(
            "Total votes: $totalVotes",
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMediaPreview(BuildContext context) {
    final fileType = summary.fileType ?? 'image';
    
    if (fileType == 'video') {
      return _buildVideoPreview(context);
    } else if (fileType == 'document') {
      return _buildDocumentPreview(context);
    } else {
      return _buildImageGallery();
    }
  }

  Widget _buildVideoPreview(BuildContext context) {
    final videoUrl = summary.fullImageLinks.isNotEmpty ? summary.fullImageLinks.first : '';
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: CachedNetworkImageProvider("https://images.unsplash.com/photo-1611162617213-7d7a39e9b1d7?q=80&w=600"),
          fit: BoxFit.cover,
          opacity: 0.6,
        ),
      ),
      child: Center(
        child: InkWell(
          onTap: () {
            if (videoUrl.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewImagesFullScreen(
                    images: [videoUrl],
                  ),
                ),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_arrow, color: Colors.white, size: 36),
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentPreview(BuildContext context) {
    final fileUrl = summary.fullImageLinks.isNotEmpty ? summary.fullImageLinks.first : '';
    final fileName = summary.imageLinks?.first ?? 'Attachment';
    
    IconData docIcon = Icons.insert_drive_file;
    Color iconColor = Colors.grey;
    if (fileName.endsWith('.pdf')) {
      docIcon = Icons.picture_as_pdf;
      iconColor = Colors.red;
    } else if (fileName.endsWith('.xls') || fileName.endsWith('.xlsx')) {
      docIcon = Icons.table_chart;
      iconColor = Colors.green;
    } else if (fileName.endsWith('.doc') || fileName.endsWith('.docx')) {
      docIcon = Icons.article;
      iconColor = Colors.blue;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: ListTile(
        leading: Icon(docIcon, color: iconColor, size: 36),
        title: Text(
          fileName.split('/').last,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: const Text("Document file attachment"),
        trailing: const Icon(Icons.download),
        onTap: () {
          if (fileUrl.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewImagesFullScreen(
                  images: [fileUrl],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildTextMessage(BuildContext context) {
    final text = summary.text ?? '';
    final urlRegex = RegExp(
      r'(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,})',
      caseSensitive: false,
    );

    if (!urlRegex.hasMatch(text)) {
      return expendedText(context, text);
    }

    final List<InlineSpan> spans = [];
    text.splitMapJoin(
      urlRegex,
      onMatch: (Match match) {
        final url = match.group(0)!;
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(title: Text(url)),
                      body: Center(
                        child: Text("Opening URL: $url"),
                      ),
                    ),
                  ),
                );
              },
              child: Text(
                url,
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
        return url;
      },
      onNonMatch: (String text) {
        spans.add(TextSpan(text: text));
        return text;
      },
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            fontSize: 16,
            height: 1.43,
            color: Colors.black,
          ),
          children: spans,
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
              backgroundImage: CachedNetworkImageProvider(
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
            itemCount: summary.fullImageLinks.length,
            itemBuilder: (context, index) {
              final imageUrl = summary.fullImageLinks[index];

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
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) {
                      return const Center(
                        child: Icon(Icons.broken_image, color: Colors.grey),
                      );
                    },
                    placeholder: (context, url) => const Center(child: CupertinoActivityIndicator()),
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
