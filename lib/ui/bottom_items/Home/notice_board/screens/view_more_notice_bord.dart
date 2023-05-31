import 'package:flutter/material.dart';
import 'package:table/ui/bottom_items/Home/notice_board/screens/view%20more%20notice%20Bord/list_of_notice.dart';
import 'package:table/widgets/heder/heder_title.dart';

import '../../../../../widgets/appWidget/app_text.dart';

class ViewMoreNoticeBord extends StatelessWidget {
  final String noticeBoardName;
  final String id;
  final String? about;

  ViewMoreNoticeBord({
    Key? key,
    required this.noticeBoardName,
    required this.id,
    this.about,
  }) : super(key: key);

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_print
    print("NoticeBoardId : $id");
    return Scaffold(
      body: NestedScrollView(
        physics: const NeverScrollableScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 250,
              width: 300,
              child: Column(
                children: [
                  HeaderTitle("NoticeBoard", context),
                  const SizedBox(height: 40),
                  AppText(noticeBoardName.toUpperCase()).title(),
                  AppText(about ?? "khulna polytechnic institute").heding(),
                  // const SizedBox(height: 30),
                  // SizedBox(
                  //   height: 40,
                  //   child: TabBar(
                  //     controller: controller,
                  //     labelColor: AppColor.nokiaBlue,
                  //     unselectedLabelColor: Colors.black,
                  //     tabs: const [
                  //       Tab(child: Text("Notices")),
                  //       Tab(child: Text("Members")),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
        body: ListOfNoticeScreen(noticeBoardId: id),
      ),

      //
    );
  }
}
