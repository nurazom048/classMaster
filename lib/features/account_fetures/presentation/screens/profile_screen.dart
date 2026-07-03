// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classmate/features/notice_fetures/presentation/widgets/dynamic_widgets/noticeboard_header.widgets.dart';

import '../../../../core/export_core.dart';
import '../../../routine/presentation/providers/routine_list_provider.dart';
import '../../../routine/presentation/utils/routine_dialog.dart';
import '../../../routine/presentation/widgets/dynamic_widgets/routine_box_by_id.dart';
import '../../../routine/presentation/widgets/static_widgets/routine_box_id_skeleton.dart';
import '../../../notice_fetures/presentation/providers/view_recent_notice_controller.dart';
import '../../../../core/widgets/widgets/recent_notice_slider_skeleton.dart';
import '../../../../core/widgets/widgets/slider/recent_notice_slider_item.dart';
import '../../../../core/widgets/widgets/slider/recent_notice_slider.dart';
import '../../domain/providers/account_providers.dart';
import '../widgets/profile_top_widgets.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key, this.academyID, this.username});

  final String? academyID;
  final String? username;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("academyID : $academyID");
    print("username : $username");

    //! Riverpod Providers
    final recentNoticeList = ref.watch(recentNoticeController(academyID));
    final accountData = ref.watch(accountDataProvider(username));
    final uploadedRoutines = ref.watch(
      routineListProvider(RoutineListQuery(username: username ?? academyID)),
    );

    // Read notifier instead of watching to prevent unnecessary rebuilds
    final uploadedRoutinesNotifier = ref.read(
      routineListProvider(
        RoutineListQuery(username: username ?? academyID),
      ).notifier,
    );

    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            HeaderTitle(
              "Profile",
              context,
              margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            ),

            //! Profile Top
            accountData.when(
              data: (either) {
                return either.fold(
                  (l) {
                    return const Center(child: Text("User data not found"));
                  },
                  (r) {
                    return Column(
                      children: [
                        ProfileTop(accountData: r),

                        //! Notice Board Section (For Academy)
                        if (r.accountType == "academy") ...[
                          NoticeBoardHeader(academyID: r.id!, accountdata: r),
                          SizedBox(
                            height: 280, // Increased height for better spacing
                            child: recentNoticeList.when(
                              data: (data) {
                                int length = data.notices.length;

                                // 🔍 Return empty state if no notices
                                if (length == 0) {
                                  return const Center(
                                    child: Text(
                                      "No recent notices available",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  );
                                }

                                return RecentNoticeSlider(
                                  ukey: 'Home Recent Notice',
                                  list: <Widget>[
                                    // Slide 1: Index 0 & 1
                                    RecentNoticeSliderItem(
                                      notice: data.notices,
                                      index: 0,
                                      condition: length >= 2,
                                      singleCondition: length == 1,
                                      recentNotice: data,
                                    ),
                                    // Slide 2: Index 2 & 3
                                    if (length > 2)
                                      RecentNoticeSliderItem(
                                        notice: data.notices,
                                        index: 2,
                                        condition: length >= 4,
                                        singleCondition: length == 3,
                                        recentNotice: data,
                                      ),
                                    // Slide 3: Index 4 & 5
                                    if (length > 4)
                                      RecentNoticeSliderItem(
                                        notice: data.notices,
                                        index: 4,
                                        condition: length >= 6,
                                        singleCondition: length == 5,
                                        recentNotice: data,
                                      ),
                                  ],
                                );
                              },
                              error: (error, stackTrace) {
                                debugPrint(
                                  '❌ Error loading recent notices: $error',
                                );
                                return Alert.handleError(context, error);
                              },
                              loading: () => const RecentNoticeSliderSkelton(),
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                );
              },
              error: (error, stackTrace) => Alert.handleError(context, error),
              loading: () => Loaders.center(height: 400),
            ),

            //! Routines Section
            const SizedBox(height: 20),
            Text("   Routines", style: TS.heading()),
            const SizedBox(height: 10),

            uploadedRoutines.when(
              data:
                  (routineData) => ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: routineData.routines.length,
                    itemBuilder: (context, index) {
                      final routine = routineData.routines[index];
                      return RoutineBoxById(
                        routineId: routine.id,
                        routineName: routine.routineName,
                        onTapMore:
                            () => RoutineDialog.CheckStatusUser_BottomSheet(
                              context,
                              routineID: routine.id,
                              routineName: routine.routineName,
                              routinesController: uploadedRoutinesNotifier,
                            ),
                      );
                    },
                  ),
              loading: () => ROUTINE_BOX_SKELTON,
              error: (error, stackTrace) => Alert.handleError(context, error),
            ),
          ],
        ),
      ),
    );
  }
}
