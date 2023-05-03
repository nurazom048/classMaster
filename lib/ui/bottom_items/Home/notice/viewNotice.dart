import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:table/helper/constant/AppColor.dart';
import 'package:table/ui/bottom_items/Home/notice/models/notice%20bord/recentNotice.dart';
import 'package:table/ui/bottom_items/Home/notice/viewPDF.dart';
import 'package:table/widgets/appWidget/appText.dart';

import '../../../../widgets/heder/hederTitle.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart' as fa;

class NoticeViewScreen extends StatelessWidget {
  final Notice notice;
  const NoticeViewScreen({super.key, required this.notice});

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
              AppText(notice.description).heding(),
              const SizedBox(height: 20),
              AppText("pdf", color: AppColor.nokiaBlue).heding(),
              const SizedBox(height: 10),
              Column(
                children: List.generate(
                  notice.pdf.length,
                  (index) => ViewPdfButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          print(notice.pdf[index].url);

                          return ViewPDf(
                            pdfLink: notice.pdf[index].url,
                          );
                        }),
                      );
                    },
                  ),
                ),
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
            AppText('      Open Pdf', fontSize: 15).title(),
          ],
        ),
      ),
    );
  }
}
