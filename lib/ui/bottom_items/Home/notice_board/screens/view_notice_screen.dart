import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:table/ui/bottom_items/Account/profile/profile_screen.dart';
import 'package:table/ui/bottom_items/Home/notice_board/screens/view_pdf_.dart';
import 'package:table/widgets/appWidget/app_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart' as fa;
import 'package:table/widgets/mini_account_row.dart';
import '../../../../../constant/app_color.dart';
import '../../../../../widgets/heder/heder_title.dart';
import '../../../Account/models/account_models.dart';
import '../models/recent_notice_model.dart';

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
    return Scaffold(
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        HeaderTitle("Back to Home", context),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const AppText("View Notice").title(),
              const SizedBox(height: 20),
              AppText("Title", color: AppColor.nokiaBlue).heding(),
              AppText(notice.contentName).heding(),
              const SizedBox(height: 20),
              AppText("Description", color: AppColor.nokiaBlue).heding(),
              AppText(notice.description ?? '').heding(),
              const SizedBox(height: 20),
              AppText("pdf", color: AppColor.nokiaBlue).heding(),
              const SizedBox(height: 10),
              ViewPdfButton(
                onTap: () => Get.to(
                    transition: Transition.rightToLeft,
                    () => ViewPDf(pdfLink: notice.pdf)),
              ),
              const SizedBox(height: 80),
              MiniAccountInfo(
                accountData: notice.academyId,
                hideNore: true,
                onTap: () => Get.to(() => ProfileSCreen(
                      academyID: notice.academyId.sId,
                      username: notice.academyId.username,
                    )),
              )
            ],
          ),
        )
      ]),
    );
  }
}

class ViewPdfButton extends StatelessWidget {
  const ViewPdfButton({
    super.key,
    required this.onTap,
  });

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
          border: Border.all(
            color: const Color(0xFF0168FF),
            width: 1,
          ),
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
