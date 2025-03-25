// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classmate/features/notice_fetures/presentation/widgets/dynamic_widgets/noticeboard_header.widgets.dart';

import '../../../../core/export_core.dart';
import '../../../home_fetures/data/datasources/home_routines_controller.dart';
import '../../../routine_Fetures/presentation/utils/routine_dialog.dart';
import '../../../routine_Fetures/presentation/widgets/dynamic_widgets/routine_box_by_id.dart';
import '../../../routine_Fetures/presentation/widgets/static_widgets/routine_box_id_scelton.dart';
import '../../../notice_fetures/presentation/providers/view_recent_notice_controller.dart';
import '../../../../core/widgets/widgets/recentnoticeslider_scalton.dart';
import '../../../../core/widgets/widgets/slider/recentniticeslider_item.dart';
import '../../../../core/widgets/widgets/slider/recentnoticeslider.dart';
import '../../domain/providers/account_providers.dart';
import '../widgets/profile_top.widgetsl.dart';

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
    final uploadedRoutines =
        ref.watch(homeRoutineControllerProvider(academyID));

    // Read notifier instead of watching to prevent unnecessary rebuilds
    final uploadedRoutinesNotifier =
        ref.read(homeRoutineControllerProvider(academyID).notifier);

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
                          NoticeBoardHeader(
                            academyID: r.id!,
                            accountdata: r,
                          ),
                          SizedBox(
                            height: 181,
                            child: recentNoticeList.when(
                              data: (noticeData) {
                                print("user profile date right $noticeData");
                                int length = noticeData.notices.length;
                                return RecentNoticeSlider(
                                  ukey: '$academyID',
                                  list: List.generate(
                                    (length / 2).ceil(),
                                    (index) => RecentNoticeSliderItem(
                                      emptyMessage: 'No Recent Notice here',
                                      notice: noticeData.notices,
                                      index: index * 2,
                                      condition: length >= (index + 1) * 2,
                                      singleCondition: length == index * 2 + 1,
                                      recentNotice: noticeData,
                                    ),
                                  ),
                                );
                              },
                              error: (error, stackTrace) =>
                                  Alert.handleError(context, error),
                              loading: () => const RecentNoticeSliderSkelton(),
                            ),
                          ),
                        ]
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
              data: (routineData) => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 100),
                itemCount: routineData.homeRoutines.length,
                itemBuilder: (context, index) {
                  final routine = routineData.homeRoutines[index];
                  return RoutineBoxById(
                    routineId: routine.id,
                    rutinName: routine.routineName,
                    onTapMore: () => RoutineDialog.CheckStatusUser_BottomSheet(
                      context,
                      routineID: routine.id,
                      routineName: routine.routineName,
                      routinesController: uploadedRoutinesNotifier,
                    ),
                  );
                },
              ),
              loading: () => RUTINE_BOX_SKELTON,
              error: (error, stackTrace) => Alert.handleError(context, error),
            ),
          ],
        ),
      ),
    );
  }
}
