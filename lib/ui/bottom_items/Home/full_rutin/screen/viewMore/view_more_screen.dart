// ignore_for_file: curly_braces_in_flow_control_structures, unnecessary_null_comparison, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/screen/viewMore/member_list.dart';
import '../../../../../../widgets/appWidget/app_text.dart';
import '../../../../../../widgets/custom_tab_bar.widget.dart';
import '../../../../../../widgets/heder/heder_title.dart';
import 'class_list.dart';

final viewMoreIndexProvider = StateProvider<int>((ref) => 0);
final routineOwenerNameProvider = StateProvider<String?>((ref) => null);

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
    return Consumer(builder: (context, ref, _) {
      final owenerName = ref.watch(routineOwenerNameProvider);

      //
      final List<Widget> pages = [
        ClassListPage(rutinId: widget.rutinId, rutinName: widget.rutinId),
        MemberList(rutinId: widget.rutinId),
      ];
      return Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: SizedBox(
                height: 284,
                width: 300,
                child: Column(
                  children: [
                    HeaderTitle("Routine", context),
                    const SizedBox(height: 40),
                    AppText(widget.rutineName.toUpperCase()).title(),
                    AppText(owenerName ?? "khulna polytechnic institute")
                        .heding(),
                    const SizedBox(height: 30),
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
      );
    });
  }
}
