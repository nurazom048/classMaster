// ignore_for_file: curly_braces_in_flow_control_structures, unnecessary_null_comparison, avoid_print, unused_local_variable, unused_result, use_build_context_synchronously

import 'package:classmate/features/routine_Fetures/presentation/screens/member_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/export_core.dart';
import '../../../../core/widgets/custom_tab_bar.widget.dart';
import '../widgets/dynamic_widgets/routine_box_by_id.dart';
import 'class_list.dart';

final viewMoreIndexProvider = StateProvider<int>((ref) => 0);

class ViewMore extends StatelessWidget {
  final String routineId;
  final String routineName;
  final String? ownerName;
  const ViewMore({
    super.key,
    required this.routineId,
    required this.routineName,
    this.ownerName,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final ownerName = ref.watch(ownerNameProvider(routineId));

        //
        final List<Widget> pages = [
          ClassListPage(routineId: routineId, routineName: routineId),
          MemberList(routineId: routineId),
        ];
        return SafeArea(
          child: Scaffold(
            body: NestedScrollView(
              headerSliverBuilder:
                  (context, innerBoxIsScrolled) => [
                    SliverToBoxAdapter(
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 240),
                        child: Column(
                          children: [
                            const AppBarCustom('Routine'),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 20),
                                  AppText(routineName.toUpperCase()).title(),
                                  AppText(
                                    ownerName ?? ownerName ?? "",
                                  ).heeding(),
                                  const SizedBox(height: 25),
                                ],
                              ),
                            ),
                            CustomTabBar(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ).copyWith(top: 2, bottom: 10),
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
                    ),
                  ],
              body: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: pages[ref.watch(viewMoreIndexProvider)],
              ),
            ),

            //
          ),
        );
      },
    );
  }
}
