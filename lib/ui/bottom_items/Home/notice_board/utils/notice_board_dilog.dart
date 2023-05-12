import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/dialogs/Alart_dialogs.dart';
import '../../../../../widgets/appWidget/dottted_divider.dart';
import '../../full_rutin/widgets/chekbox_selector_button.dart';
import '../notice controller/notice_boaed_satus_controller.dart';

class NoticeboardDilog {
  //   notficationSeleect
  static notficationSeleect(BuildContext context, String noticeBoardId) {
    showModalBottomSheet(
      elevation: 0,
      barrierColor: Colors.black.withAlpha(1),
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 250,
          width: 350,
          child: Card(
            color: Colors.white,
            margin: const EdgeInsets.all(18.0)
                .copyWith(left: 30, right: 30, bottom: 30),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Consumer(builder: (context, ref, _) {
              //!provider
              // state providers
              final chackStatus =
                  ref.watch(noticeBoardStatusProvider(noticeBoardId));

              // state providers with notifier
              final chackStatusNotifier =
                  ref.watch(noticeBoardStatusProvider(noticeBoardId).notifier);
              // final allMembersNotifier =
              //     ref.watch(finalMemberConollerList(noticeBoardId).notifier);

              //
              String status = chackStatus.value?.activeStatus ?? '';

              bool notificationOff =
                  chackStatus.value?.notificationOff ?? false;
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ChackBoxSelector(
                    isChacked: !notificationOff,
                    icon: Icons.notifications_active,
                    text: "notifications_active",
                    onTap: () {
                      chackStatusNotifier.notificationOn(context);
                      Navigator.pop(context);
                    },
                  ),
                  ChackBoxSelector(
                    isChacked: notificationOff,
                    icon: Icons.notifications_off,
                    text: "Notification Off",
                    color: Colors.red,
                    onTap: () {
                      chackStatusNotifier.notificationOff(context);
                      Navigator.pop(context);
                    },
                  ),
                  const MyDivider(),
                  ChackBoxSelector(
                    icon: Icons.logout_sharp,
                    text: "Leave",
                    color: Colors.red,
                    onTap: () {
                      Alart.errorAlertDialogCallBack(
                        context,
                        "are you sure you want to leave",
                        onConfirm: (bool isYes) {
                          chackStatusNotifier.leaveMember(context);
                        },
                      );
                    },
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }
}
