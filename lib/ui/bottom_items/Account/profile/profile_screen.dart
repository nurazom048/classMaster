// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/core/component/loaders.dart';
import 'package:table/ui/bottom_items/Account/account_request/account_request.dart';
import 'package:table/ui/bottom_items/Account/profile/widgets/noticeboard_header.widgets.dart';
import 'package:table/ui/bottom_items/Account/profile/widgets/profile_top.widgetsl.dart';

import '../../../../core/dialogs/alart_dialogs.dart';
import '../../../../widgets/appWidget/app_text.dart';
import '../../../../widgets/heder/heder_title.dart';
import '../../Home/full_rutin/utils/rutin_dialog.dart';
import '../../Home/full_rutin/widgets/rutin_box/rutin_box_by_id.dart';
import '../../Home/full_rutin/widgets/sceltons/rutinebox_id_scelton.dart';
import '../../Home/home_req/home_rutins_controller.dart';
import '../../Home/notice_board/notice controller/virew_recent_notice_controller.dart';
import '../../Home/widgets/recentnoticeslider_scalton.dart';
import '../../Home/widgets/slider/recentniticeslider_item.dart';
import '../../Home/widgets/slider/recentnoticeslider.dart';

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
      final uplodedRoutines = ref.watch(homeRutinControllerProvider(academyID));
      final uplodedRoutinesNotfier =
          ref.watch(homeRutinControllerProvider(academyID).notifier);
      ;

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

                      if (data != null && data.accountType == "user") ...[
                        NoticeBoardHeader(
                            academyID: data.sId!, accountdata: data),
                        SizedBox(
                          height: 181,
                          child: recentNoticeList.when(
                            data: (data) {
                              int length = data.notices.length;
                              return RecentNoticeSlider(
                                list: <Widget>[
                                  RecentNoticeSliderItem(
                                    notice: data.notices,
                                    index: 0,
                                    conditon: length >= 2,
                                    singleCondition: length == 1,
                                    recentNotice: data,
                                  ),

                                  //
                                  RecentNoticeSliderItem(
                                    notice: data.notices,
                                    index: 2,
                                    conditon: length >= 4,
                                    singleCondition: length == 3,
                                    recentNotice: data,
                                  ), //
                                  RecentNoticeSliderItem(
                                    notice: data.notices,
                                    index: 3,
                                    conditon: length >= 6,
                                    singleCondition: length == 5,
                                    recentNotice: data,
                                  ),

                                  RecentNoticeSliderItem(
                                    notice: data.notices,
                                    index: 4,
                                    conditon: length >= 8,
                                    singleCondition: length == 7,
                                    recentNotice: data,
                                  ),
                                ],
                              );
                            },
                            error: (error, stackTrace) =>
                                Alart.handleError(context, error),
                            loading: () => const RecentNoticeSliderScealton(),
                          ),
                        ),
                      ]
                    ],
                  );
                },
                error: (error, stackTrace) => Alart.handleError(context, error),
                loading: () => Loaders.center(height: 400),
              ),

              //

              //********** Routines ***********************/
              Text("   Routines", style: TS.heading()),
              const SizedBox(height: 10),
              uplodedRoutines.when(
                data: (data) {
                  //
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: data.homeRoutines.length,
                    itemBuilder: (context, index) {
                      return RutinBoxById(
                        rutinId: data.homeRoutines[index].rutineId.id,
                        rutinName: data.homeRoutines[index].rutineId.name,
                        onTapMore: () =>
                            RutinDialog.ChackStatusUser_BottomSheet(
                          context,
                          routineID: data.homeRoutines[index].rutineId.id,
                          routineName: data.homeRoutines[index].rutineId.name,
                          rutinsController: uplodedRoutinesNotfier,
                        ),
                      );
                    },
                  );
                },
                loading: () => RUTINE_BOX_SKELTON,
                error: (error, stackTrace) => Alart.handleError(context, error),
              ),
            ],
          ),
        ),
      );
    });
  }
}
