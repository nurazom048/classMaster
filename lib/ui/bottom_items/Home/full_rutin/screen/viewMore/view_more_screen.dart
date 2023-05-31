// ignore_for_file: curly_braces_in_flow_control_structures, unnecessary_null_comparison, avoid_print

import 'package:flutter/material.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/screen/viewMore/member_list.dart';
import '../../../../../../constant/app_color.dart';
import '../../../../../../widgets/appWidget/app_text.dart';
import '../../../../../../widgets/heder/heder_title.dart';
import 'class_list.dart';

class ViewMore extends StatefulWidget {
  final String rutinId;
  final String rutineName;
  final String? owenerName;
  const ViewMore(
      {Key? key,
      required this.rutinId,
      required this.rutineName,
      this.owenerName})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ViewMoreState createState() => _ViewMoreState();
}

class _ViewMoreState extends State<ViewMore> with TickerProviderStateMixin {
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
                  HeaderTitle("Rutine", context),
                  const SizedBox(height: 40),
                  AppText(widget.rutineName.toUpperCase()).title(),
                  AppText(widget.owenerName ?? "khulna polytechnic institute")
                      .heding(),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 40,
                    child: TabBar(
                        controller: controller,
                        labelColor: AppColor.nokiaBlue,
                        unselectedLabelColor: Colors.black,
                        tabs: const [
                          Tab(child: Text("Class List")),
                          Tab(child: Text("Members")),
                        ]),
                  ),
                ],
              ),
            ),
          )
        ],
        body: TabBarView(controller: controller, children: [
          ClassListPage(rutinId: widget.rutinId, rutinName: widget.rutinId),
          MemberList(rutinId: widget.rutinId),
        ]),
      ),

      //
    );
  }
}
