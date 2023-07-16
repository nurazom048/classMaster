// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:classmate/ui/bottom_items/Collection%20Fetures/Profie%20Fetures/widgets/notice_board_join_btn.dart';

import '../../../../../core/dialogs/alert_dialogs.dart';
import '../../../../../widgets/appWidget/app_text.dart';
import '../../../../../widgets/appWidget/dotted_divider.dart';
import '../../../Home/Full_routine/widgets/chekbox_selector_button.dart';
import '../../../Home/Full_routine/widgets/skelton/routine_box_id_scelton.dart';
import '../../../Home/notice_board/notice controller/noticeboard_satus_controller.dart';
import '../../../Home/notice_board/screens/view_all_recent_notice.dart';
import '../../models/account_models.dart';

class NoticeBoardHeader extends ConsumerWidget {
  final String academyID;
  final AccountModels? accountdata;
  const NoticeBoardHeader({
    super.key,
    required this.academyID,
    this.accountdata,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("NoticeStatus $academyID");
    //! PRovider
    final noticeBoardStatus = ref.watch(noticeBoardStatusProvider(academyID));
    final statusNotifier =
        ref.watch(noticeBoardStatusProvider(academyID).notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
              onTap: () => Get.to(
                  () => ViewAllRecentNotice(accountData: accountdata),
                  transition: Transition.rightToLeftWithFade),

              //
              child: Text("NoticeBoard", style: TS.heading())),
          noticeBoardStatus.when(
            data: (data) {
              return NoticeBoardJoinButton(
                isJoin: data.activeStatus == "joined" ? true : false,
                notificationOn: data.notificationOn,
                showPanel: () => noticeBoardSheet(context, academyID),
                onTapForJoin: () => statusNotifier.join(context),
              );
            },
            error: (error, stackTrace) => Alert.handleError(context, error),
            loading: () => const JoinSkelton(width: 10),
          ),
        ],
      ),
    );
  }

  noticeBoardSheet(BuildContext context, String academyID) {
    showModalBottomSheet(
        elevation: 0,
        barrierColor: Colors.black26,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Consumer(builder: (context, ref, _) {
            //! provider
            final noticeBoardStatus =
                ref.watch(noticeBoardStatusProvider(academyID));
            final statusNotifier =
                ref.watch(noticeBoardStatusProvider(academyID).notifier);

            //
            bool notificationOn = false;

            notificationOn = noticeBoardStatus.value?.notificationOn ?? false;

            return SizedBox(
              height: 250,
              width: MediaQuery.of(context).size.width - 10,
              child: Card(
                color: Colors.white,
                margin: const EdgeInsets.all(18.0)
                    .copyWith(left: 30, right: 30, bottom: 30),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CheckBoxSelector(
                      isChacked: notificationOn,
                      icon: Icons.notifications_active,
                      text: "notifications_active",
                      onTap: () {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          statusNotifier.notificationOn(context);
                        });
                      },
                    ),
                    CheckBoxSelector(
                      isChacked: notificationOn == false ? true : false,
                      icon: Icons.notifications_off,
                      text: "Notification Off",
                      color: Colors.red,
                      onTap: () {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          statusNotifier.notificationOff(context);
                        });
                      },
                    ),
                    const MyDivider(),
                    CheckBoxSelector(
                      icon: Icons.logout_sharp,
                      text: "Leave",
                      color: Colors.red,
                      onTap: () => Alert.errorAlertDialogCallBack(
                        context,
                        "Are you sure you want to leave?",
                        onConfirm: (bool isYes) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            statusNotifier.leaveMember(context);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }
}
