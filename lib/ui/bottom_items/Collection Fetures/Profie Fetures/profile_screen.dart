// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classmate/core/component/loaders.dart';
import 'package:classmate/ui/bottom_items/Collection%20Fetures/Profie%20Fetures/widgets/noticeboard_header.widgets.dart';
import 'package:classmate/ui/bottom_items/Home/home_req/home_routines_controller.dart';

import '../../../../core/dialogs/alert_dialogs.dart';
import '../../../../widgets/appWidget/app_text.dart';
import '../../../../widgets/heder/heder_title.dart';
import '../../Home/Full_routine/utils/routine_dialog.dart';
import '../../Home/Full_routine/widgets/routine_box/routine_box_by_ID.dart';
import '../../Home/Full_routine/widgets/skelton/routine_box_id_scelton.dart';
import '../../Home/notice_board/notice controller/virew_recent_notice_controller.dart';
import '../../Home/widgets/recentnoticeslider_scalton.dart';
import '../../Home/widgets/slider/recentniticeslider_item.dart';
import '../../Home/widgets/slider/recentnoticeslider.dart';
import '../Api/account_request.dart';
import 'widgets/profile_top.widgetsl.dart';

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
                            academyID: data.sId!, accountdata: data),
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
                        rutinId: data.homeRoutines[index].rutineId.id,
                        rutinName: data.homeRoutines[index].rutineId.name,
                        onTapMore: () =>
                            RoutineDialog.CheckStatusUser_BottomSheet(
                          context,
                          routineID: data.homeRoutines[index].rutineId.id,
                          routineName: data.homeRoutines[index].rutineId.name,
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
