import 'package:flutter/material.dart';
import 'package:table/ui/bottom_items/Home/notice/screens/view%20more%20notice%20Bord/list_of_notice.dart';
import 'package:table/ui/bottom_items/Home/notice/screens/view%20more%20notice%20Bord/notice_board_memberrs.dart';
import 'package:table/widgets/heder/heder_title.dart';

import '../../../../../helper/constant/app_color.dart';
import '../../../../../widgets/appWidget/app_text.dart';

class ViewMoreNoticeBord extends StatefulWidget {
  final String noticeBoardName;
  final String id;
  final String? about;
  const ViewMoreNoticeBord({
    Key? key,
    required this.noticeBoardName,
    required this.id,
    this.about,
  }) : super(key: key);

  @override
  _ViewMoreState createState() => _ViewMoreState();
}

class _ViewMoreState extends State<ViewMoreNoticeBord>
    with TickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 270,
              width: 300,
              child: Column(
                children: [
                  HeaderTitle("NoticeBoard", context),
                  const SizedBox(height: 40),
                  AppText(widget.noticeBoardName.toUpperCase()).title(),
                  AppText(widget.about ?? "khulna polytechnic institute")
                      .heding(),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 40,
                    child: TabBar(
                        controller: controller,
                        labelColor: AppColor.nokiaBlue,
                        unselectedLabelColor: Colors.black,
                        tabs: const [
                          Tab(child: Text("Notice")),
                          Tab(child: Text("Members")),
                        ]),
                  ),
                ],
              ),
            ),
          )
        ],
        body: TabBarView(controller: controller, children: const [
          ListOfNoticeScreen(),
          NoticeBoardMembersScreen(rutinId: "")
        ]),
      ),

      //
    );
  }
}
