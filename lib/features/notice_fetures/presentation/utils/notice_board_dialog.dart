import 'package:classmate/core/widgets/my_divider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/export_core.dart';
import '../../../../core/dialogs/confirm_alert_dialog.dart';
import '../../../routine_Fetures/presentation/widgets/static_widgets/checkbox_selector_button.dart';
import '../providers/noticeboard_status_controller.dart';
import '../providers/view_recent_notice_controller.dart';

class NoticeboardDialog {
  //   notificationSelect
  static notificationSelect(BuildContext context, String noticeBoardId) {
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
            margin: const EdgeInsets.all(
              18.0,
            ).copyWith(left: 30, right: 30, bottom: 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Consumer(
              builder: (context, ref, _) {
                //!provider
                // state providers
                final checkStatus = ref.watch(
                  noticeBoardStatusProvider(noticeBoardId),
                );

                // state providers with notifier
                final checkStatusNotifier = ref.watch(
                  noticeBoardStatusProvider(noticeBoardId).notifier,
                );
                // final allMembersNotifier =
                //     ref.watch(finalMemberConollerList(noticeBoardId).notifier);

                //

                bool notificationOff =
                    checkStatus.value?.notificationOn ?? false;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CheckBoxSelector(
                      isChecked: !notificationOff,
                      icon: Icons.notifications_active,
                      text: "notifications_active",
                      onTap: () {
                        checkStatusNotifier.notificationOn(context);
                        Navigator.pop(context);
                      },
                    ),
                    CheckBoxSelector(
                      isChecked: notificationOff,
                      icon: Icons.notifications_off,
                      text: "Notification Off",
                      color: Colors.red,
                      onTap: () {
                        checkStatusNotifier.notificationOff(context);
                        Navigator.pop(context);
                      },
                    ),
                    const MyDivider(),
                    CheckBoxSelector(
                      icon: Icons.logout_sharp,
                      text: "Leave",
                      color: Colors.red,
                      onTap: () {
                        Alert.errorAlertDialogCallBack(
                          context,
                          "are you sure you want to leave",
                          onConfirm: (bool isYes) {
                            checkStatusNotifier.leaveMember(context);
                          },
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  // long press delete notice
  static Future<dynamic> logPressNotice(
    BuildContext context, {
    required String noticeBoardId,
    required String? academyID,
    required String noticeId,
  }) {
    return showCupertinoModalPopup(
      context: context,
      builder:
          (context) => Consumer(
            builder: (context, ref, _) {
              //!provider
              // state providers
              final checkStatus = ref.watch(
                noticeBoardStatusProvider(noticeBoardId),
              );
              final recentNoticeNotifier = ref.watch(
                recentNoticeController(academyID).notifier,
              );
              bool isOwner = checkStatus.value?.isOwner ?? false;
              return CupertinoActionSheet(
                title: const Text(
                  " Do you want to.. ?",
                  style: TextStyle(fontSize: 22, color: Colors.black87),
                ),
                actions: [
                  // delete
                  if (isOwner)
                    CupertinoActionSheetAction(
                      child: const Text(
                        "Remove Notice",
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        // Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          builder:
                              (BuildContext context) => ConfirmAlertDialog(
                                title: 'Alert',
                                message:
                                    'Do you want to delete this Class? You can\'t undo this action.',
                                onConfirm: (bool isConfirmed) {
                                  if (isConfirmed) {
                                    recentNoticeNotifier.deleteNotice(
                                      context,
                                      ref,
                                      noticeId: noticeId,
                                    );
                                  }
                                },
                              ),
                        );

                        //
                      },
                    )
                  else
                    CupertinoActionSheetAction(
                      onPressed: () {},
                      child: const Text('Sorry No Action Here'),
                    ),
                ],
                cancelButton: CupertinoActionSheetAction(
                  child: const Text("cancel"),
                  onPressed: () => Navigator.pop(context),
                ),
              );
            },
          ),
    );
  }
}
