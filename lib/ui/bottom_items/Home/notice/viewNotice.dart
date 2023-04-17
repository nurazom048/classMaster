import 'package:flutter/material.dart';
import 'package:table/helper/constant/AppColor.dart';
import 'package:table/widgets/appWidget/appText.dart';

import '../../../../models/notice bord/listOfnotice model.dart';
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
        SizedBox(height: 20),
        AppText("   View Notice").title(),
        SizedBox(height: 20),
        AppText("Title", color: AppColor.nokiaBlue).heding(),
        AppText(notice.contentName).heding(),
        AppText("Description", color: AppColor.nokiaBlue).heding(),
        AppText(notice.description).heding(),
        SizedBox(height: 20),
        Icon(fa)
      ]),
    );
  }
}
