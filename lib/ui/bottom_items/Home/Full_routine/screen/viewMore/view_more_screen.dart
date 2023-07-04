// ignore_for_file: curly_braces_in_flow_control_structures, unnecessary_null_comparison, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/Full_routine/screen/viewMore/member_list.dart';
import 'package:table/ui/bottom_items/Home/Full_routine/widgets/routine_box/rutin_box_by_id.dart';
import '../../../../../../widgets/appWidget/app_text.dart';
import '../../../../../../widgets/custom_tab_bar.widget.dart';
import '../../../../../../widgets/heder/heder_title.dart';
import 'class_list.dart';

final viewMoreIndexProvider = StateProvider<int>((ref) => 0);

class ViewMore extends StatefulWidget {
  final String routineId;
  final String routineName;
  final String? ownerName;
  const ViewMore({
    Key? key,
    required this.routineId,
    required this.routineName,
    this.ownerName,
  }) : super(key: key);

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
    return Consumer(builder: (context, ref, _) {
      final ownerName = ref.watch(ownerNameProvider);

      //
      final List<Widget> pages = [
        ClassListPage(
            routineId: widget.routineId, routineName: widget.routineId),
        MemberList(routineId: widget.routineId),
      ];
      return SafeArea(
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 284,
                  width: 300,
                  child: Column(
                    children: [
                      HeaderTitle("Routine", context),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 40),
                            AppText(widget.routineName.toUpperCase()).title(),
                            AppText(widget.ownerName ??
                                    ownerName ??
                                    "khulna polytechnic institute")
                                .heeding(),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                      CustomTabBar(
                        margin: const EdgeInsets.symmetric(horizontal: 24)
                            .copyWith(top: 2, bottom: 10),
                        tabItems: const ['Class List', 'Members'],
                        selectedIndex: ref.watch(viewMoreIndexProvider),
                        onTabSelected: (index) {
                          ref
                              .watch(viewMoreIndexProvider.notifier)
                              .update((state) => index);
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
            body: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: pages[ref.watch(viewMoreIndexProvider)]),
          ),

          //
        ),
      );
    });
  }
}
