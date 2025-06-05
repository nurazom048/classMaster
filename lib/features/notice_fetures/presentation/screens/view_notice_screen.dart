import 'package:classmate/core/component/heder%20component/transition/right_to_left_transition.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart' as fa;
import '../../../../../features/account_fetures/presentation/screens/profile_screen.dart';
import '../../../../../features/account_fetures/data/models/account_models.dart';
import '../../../../core/export_core.dart';
import '../../../../core/widgets/mini_account_row.dart';
import '../../data/models/recent_notice_model.dart';
import 'view_pdf_.dart';

class NoticeViewScreen extends StatelessWidget {
  final Notice notice;
  final AccountModels accountModel;
  const NoticeViewScreen({
    super.key,
    required this.notice,
    required this.accountModel,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderTitle("Back to Home", context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const AppText("View Notice").title(),
                  const SizedBox(height: 20),
                  AppText("Title", color: AppColor.nokiaBlue).heeding(),
                  AppText(notice.title).heeding(),
                  const SizedBox(height: 20),
                  AppText("Description", color: AppColor.nokiaBlue).heeding(),
                  AppText(notice.description ?? '').heeding(),
                  const SizedBox(height: 20),
                  AppText("pdf", color: AppColor.nokiaBlue).heeding(),
                  const SizedBox(height: 10),
                  ViewPdfButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        RightToLeftTransition(
                          page: ViewPDf(pdfLink: notice.pdf),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 80),
                  MiniAccountInfo(
                    accountData: notice.account,
                    hideMore: true,
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ProfileScreen(
                                  academyID: notice.account.id,
                                  username: notice.account.username,
                                ),
                          ),
                        ),
                  ),
                ],
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

  final dynamic onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        // Button styles
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xFFEEF4FC),
          border: Border.all(color: const Color(0xFF0168FF), width: 1),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 22),
        width: 340,
        height: 46,

        // Align children to start of the container
        alignment: Alignment.centerLeft,

        // Add child widgets here
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            fa.FaIcon(
              FontAwesomeIcons.filePdf,
              color: AppColor.nokiaBlue,
              size: 22,
            ),
            const AppText('      Open Pdf', fontSize: 15).title(),
          ],
        ),
      ),
    );
  }
}
