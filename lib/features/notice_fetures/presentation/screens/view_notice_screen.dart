import 'dart:html' as html;
import 'package:classmate/core/component/heder_component/transition/right_to_left_transition.dart';
import 'package:classmate/features/notice_fetures/data/datasources/notice_request.dart';
import 'package:classmate/features/notice_fetures/presentation/utils/share_notice_dialog.dart';
import 'package:classmate/features/notice_fetures/presentation/widgets/static_widgets/custom_share_bottom_sheet.dart';
import 'package:classmate/features/notice_fetures/presentation/widgets/static_widgets/share_notice_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart' as fa;
import 'package:classmate/features/account_fetures/presentation/screens/profile_screen.dart';
import 'package:classmate/features/account_fetures/data/models/account_models.dart';
import '../../../../core/export_core.dart';
import '../../../../core/widgets/mini_account_row.dart';
import '../../data/models/recent_notice_model.dart';
import 'view_pdf_.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

// ============================================================================
// MAIN SCREEN
// ============================================================================

class NoticeViewScreen extends StatefulWidget {
  final Notice? notice;
  final AccountModels? accountModel;
  final String? noticeId; // New: Pass ID if coming from a link

  const NoticeViewScreen({
    super.key,
    this.notice,
    this.accountModel,
    this.noticeId,
  });

  @override
  State<NoticeViewScreen> createState() => _NoticeViewScreenState();
}

class _NoticeViewScreenState extends State<NoticeViewScreen> {
  Notice? _notice;
  AccountModels? _accountModel;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Logic: Only fetch if data is missing (Deep Link scenario)
    if (widget.notice == null || widget.accountModel == null) {
      _fetchNoticeData();
    } else {
      _notice = widget.notice;
      _accountModel = widget.accountModel;
    }
  }

  Future<void> _fetchNoticeData() async {
    if (widget.noticeId == null) return;
    setState(() => _isLoading = true);
    try {
      final noticeRequest = NoticeRequest();
      final result = await noticeRequest.getNoticeById(
        noticeId: widget.noticeId!,
      );
      setState(() {
        _notice = result;
        _accountModel = result.account;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      // Handle error (e.g., show snackbar)
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else {
      return '${(difference.inDays / 365).floor()} years ago';
    }
  }

  void _showShareBottomSheet(BuildContext context, String shareableUrl) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Share Notice',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SelectableText(
                shareableUrl,
                style: const TextStyle(fontSize: 14, color: Colors.blue),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  final Uri emailUri = Uri(
                    scheme: 'mailto',
                    queryParameters: {
                      'subject': 'Notice from ClassMaster',
                      'body': shareableUrl,
                    },
                  );
                  if (await canLaunchUrl(emailUri)) {
                    await launchUrl(emailUri);
                  }
                },
                icon: const Icon(Icons.email),
                label: const Text('Share via email'),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
                label: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("REAL URL => ${html.window.location.href}");

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_notice == null) {
      return const Scaffold(body: Center(child: Text("Notice not found")));
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFFDFDFD), // Light background
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderTitle("Back to Home", context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          "View Notice",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        // Display the formatted time
                        Text(
                          _formatTimeAgo(_notice!.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    const Text(
                      "Title",
                      style: TextStyle(
                        color: Color(0xFF0066FF),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _notice!.title,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      "Description",
                      style: TextStyle(
                        color: Color(0xFF0066FF),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _notice!.description ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      "PDF Document",
                      style: TextStyle(
                        color: Color(0xFF0066FF),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: ViewPdfButton(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          ViewPDf(pdfLink: _notice!.pdf),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 1,
                          child: ActionButton(
                            icon: Icons.share,
                            label: "Share",
                            onTap: () {
                              final String shareableUrl =
                                  "https://classmaster.top/notice/${_notice!.id}";
                              _showShareBottomSheet(context, shareableUrl);
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    MiniAccountInfo(
                      accountData: _notice!.account,
                      hideMore: true,
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ProfileScreen(
                                    academyID: _notice!.account.id,
                                    username: _notice!.account.username,
                                  ),
                            ),
                          ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ViewPdfButton extends StatelessWidget {
  const ViewPdfButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xFFEEF4FC),
          border: Border.all(color: AppColor.nokiaBlue, width: 1),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        height: 48,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.filePdf,
              color: AppColor.nokiaBlue,
              size: 20,
            ),
            const SizedBox(width: 12),
            const Text(
              "Open Pdf",
              style: TextStyle(
                fontSize: 16, // Reduced font size to look normal
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.label,
  });

  final VoidCallback onTap;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        height: 48,
        alignment: Alignment.center,
        child: Icon(icon, color: Colors.black87, size: 22),
      ),
    );
  }
}
