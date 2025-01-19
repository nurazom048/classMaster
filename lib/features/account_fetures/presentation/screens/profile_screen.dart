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
import '../../data/datasources/account_request.dart';
import '../widgets/profile_top.widgetsl.dart';

class ProfileSCreen extends StatelessWidget {
  ProfileSCreen({super.key, this.academyID, this.username});

  final String? academyID;
  final String? username;
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    print("academyID : $academyID");
    print("username : $username");
    return Consumer(builder: (context, ref, _) {
      //!provider

      final recentNoticeList = ref.watch(recentNoticeController(academyID));
      final accountData = ref.watch(accountDataProvider(username));
      final uploadedRoutines =
          ref.watch(homeRoutineControllerProvider(academyID));
      final uploadedRoutinesNotifier =
          ref.watch(homeRoutineControllerProvider(academyID).notifier);

      //

      return SafeArea(
        child: Scaffold(
          body: ListView(
            children: [
              HeaderTitle(
                "Profile",
                context,
                margin:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              ),

              //! Profile Top

              accountData.when(
                data: (data) {
                  print("account type : ${data?.accountType}");
                  return Column(
                    children: [
                      // Profile Top
                      ProfileTop(accountData: data),

                      // NoticeBoard

                      if (data != null && data.accountType == "academy") ...[
                        NoticeBoardHeader(
                            academyID: data.id!, accountdata: data),
                        SizedBox(
                          height: 181,
                          child: recentNoticeList.when(
                            data: (data) {
                              int length = data.notices.length;
                              return RecentNoticeSlider(
                                ukey: '$academyID',
                                list: <Widget>[
                                  RecentNoticeSliderItem(
                                    emptyMessage: 'No Recent Notice here',
                                    notice: data.notices,
                                    index: 0,
                                    condition: length >= 2,
                                    singleCondition: length == 1,
                                    recentNotice: data,
                                  ),

                                  //
                                  RecentNoticeSliderItem(
                                    emptyMessage: 'No Recent Notice here',
                                    notice: data.notices,
                                    index: 2,
                                    condition: length >= 4,
                                    singleCondition: length == 3,
                                    recentNotice: data,
                                  ), //
                                  RecentNoticeSliderItem(
                                    emptyMessage: 'No Recent Notice here',
                                    notice: data.notices,
                                    index: 3,
                                    condition: length >= 6,
                                    singleCondition: length == 5,
                                    recentNotice: data,
                                  ),

                                  RecentNoticeSliderItem(
                                    emptyMessage: 'No Recent Notice here',
                                    notice: data.notices,
                                    index: 4,
                                    condition: length >= 8,
                                    singleCondition: length == 7,
                                    recentNotice: data,
                                  ),
                                ],
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
                error: (error, stackTrace) => Alert.handleError(context, error),
                loading: () => Loaders.center(height: 400),
              ),

              //

              //********** Routines ***********************/
              Text("   Routines", style: TS.heading()),
              const SizedBox(height: 10),
              uploadedRoutines.when(
                data: (data) {
                  //
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: data.homeRoutines.length,
                    itemBuilder: (context, index) {
                      return RoutineBoxById(
                        routineId: data.homeRoutines[index].id,
                        rutinName: data.homeRoutines[index].routineName,
                        onTapMore: () =>
                            RoutineDialog.CheckStatusUser_BottomSheet(
                          context,
                          routineID: data.homeRoutines[index].id,
                          routineName: data.homeRoutines[index].routineName,
                          routinesController: uploadedRoutinesNotifier,
                        ),
                      );
                    },
                  );
                },
                loading: () => RUTINE_BOX_SKELTON,
                error: (error, stackTrace) => Alert.handleError(context, error),
              ),
            ],
          ),
        ),
      );
    });
  }
}
