// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/core/component/loaders.dart';
import 'package:table/ui/bottom_items/Account/account_request/account_request.dart';
import 'package:table/ui/bottom_items/Account/profile/widgets/notice_board_join_btn.dart';
import 'package:table/ui/bottom_items/Account/profile/widgets/profile_top.widgetsl.dart';

import '../../../../core/dialogs/alart_dialogs.dart';
import '../../../../widgets/appWidget/app_text.dart';
import '../../../../widgets/heder/heder_title.dart';
import '../../Home/full_rutin/utils/rutin_dialog.dart';
import '../../Home/full_rutin/widgets/rutin_box/rutin_box_by_id.dart';
import '../../Home/full_rutin/widgets/sceltons/rutinebox_id_scelton.dart';
import '../../Home/home_req/rutin_req.dart';
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
      final allUploadesRutines =
          ref.watch(uploadedRutinsControllerProvider(username));

      return SafeArea(
        child: Scaffold(
          body: ListView(
            children: [
              HeaderTitle(
                "Profile",
                context,
                margin:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
              ),

              //! Profile Top

              accountData.when(
                data: (data) {
                  print("account type : ${data?.accountType}");
                  return ProfileTop(accountData: data);
                },
                error: (error, stackTrace) => Alart.handleError(context, error),
                loading: () => Loaders.center(),
              ),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("NoticeBoard", style: TS.heading()),
                    NoticeBoardJoineButton(
                      isJoine: false,
                      notificationOff: true,
                      showPanel: () {},
                      onTapForJoine: () {},
                    )
                  ],
                ),
              ),

              //
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
                        ),

                        //
                        RecentNoticeSliderItem(
                          notice: data.notices,
                          index: 2,
                          conditon: length >= 4,
                        ), //
                        RecentNoticeSliderItem(
                          notice: data.notices,
                          index: 3,
                          conditon: length >= 6,
                        ),

                        RecentNoticeSliderItem(
                          notice: data.notices,
                          index: 4,
                          conditon: length >= 8,
                        ),
                      ],
                    );
                  },
                  error: (error, stackTrace) =>
                      Alart.handleError(context, error),
                  loading: () => const RecentNoticeSliderScealton(),
                ),
              ),
              //********** Routines ***********************/
              Text("   Routines", style: TS.heading()),
              const SizedBox(height: 10),
              allUploadesRutines.when(
                data: (data) {
                  //
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: data.rutins.length,
                    itemBuilder: (context, index) {
                      return RutinBoxById(
                        rutinId: data.rutins[index].id,
                        rutinName: data.rutins[index].name,
                        onTapMore: () =>
                            RutinDialog.ChackStatusUser_BottomSheet(
                          context,
                          data.rutins[index].id,
                          data.rutins[index].name,
                        ),
                      );
                    },
                  );
                },
                loading: () => ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return const RutinBoxByIdSkelton();
                  },
                ),
                error: (error, stackTrace) => Alart.handleError(context, error),
              ),
            ],
          ),
        ),
      );
    });
  }
}
