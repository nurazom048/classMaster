// ignore_for_file: camel_case_types, non_constant_identifier_names, unused_local_variable, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classmate/features/routine_Fetures/presentation/widgets/static_widgets/chekbox_selector_button.dart';
import '../../../../core/export_core.dart';
import '../../../../core/dialogs/confrom_alart_dilog.dart';
import '../../../home_fetures/data/datasources/home_routines_controller.dart';
import '../providers/check_status_controller.dart';
import '../providers/members_controllers.dart';

class RoutineDialog {
  //**********     CheckStatusUser_BottomSheet       **********/
  static CheckStatusUser_BottomSheet(
    BuildContext context, {
    required String routineID,
    required String routineName,
    required HomeRoutinesController routinesController,
  }) {
    // show bottom sheet modal to check user status
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          // bottom sheet layout
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
            ),
            child: Consumer(builder: (ctx, ref, _) {
              // state providers
              final checkStatus =
                  ref.watch(checkStatusControllerProvider(routineID));

              // state providers with notifier
              final checkStatusNotifier =
                  ref.watch(checkStatusControllerProvider(routineID).notifier);
              final members =
                  ref.read(memberControllerProvider(routineID).notifier);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  checkStatus.when(
                      data: (data) {
                        String status = checkStatus.value?.activeStatus ?? '';

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (status == "joined")
                              SquaresButton(
                                icon: Icons.logout,
                                inActiveText: "leave",
                                color: Colors.redAccent,
                                text: data.activeStatus,
                                ontap: () {
                                  return Alert.errorAlertDialogCallBack(
                                    context,
                                    "are you sure you want to leave",
                                    onConfirm: () {
                                      checkStatusNotifier.leaveMember(
                                          ctx, ref); // Pass the context here
                                    },
                                  );
                                },
                              )
                            else
                              SquaresButton(
                                icon: Icons.people_rounded,
                                inActiveIcon: Icons.telegram,
                                inActiveText: status,
                                status:
                                    status == "request_pending" ? true : false,
                                text: status,
                                ontap: () {
                                  checkStatusNotifier.sendReqController(ctx);
                                },
                              ),
                            SquaresButton(
                              inActiveIcon: Icons.bookmark_added,
                              icon: Icons.bookmark_add_sharp,
                              text: 'Save',
                              inActiveText: "add to save",
                              status: checkStatus.value?.isSave,
                              ontap: () {
                                checkStatusNotifier.saveUnsaved(
                                  ctx,
                                  !(checkStatus.value?.isSave ?? false),
                                );
                              },
                            ),
                            if (data.isCaptain || data.isOwner) ...[
                              if (data.isOwner == true) ...[
                                SquaresButton(
                                  icon: Icons.delete,
                                  text: "Delete",
                                  color: Colors.red,
                                  ontap: () {
                                    Navigator.of(context).pop();
                                    return showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          ConfromAlartDilog(
                                        title: 'Alert',
                                        message:
                                            'Do you want to delete this routine? You can\'t undo this action.',
                                        onConfirm: (bool isConfirmed) {
                                          if (isConfirmed) {
                                            routinesController.deleteRutin(
                                                routineID, context);
                                          }
                                        },
                                      ),
                                    );
                                  },
                                )
                              ]
                            ],
                          ],
                        );
                      },
                      loading: () => Loaders.center(),
                      error: (error, stackTrace) =>
                          Alert.handleError(context, error)),
                ],
              );
            }),
          );
        });
  }

  //
  static rutineNotificationsSelect(BuildContext context, String rutineId) {
    showModalBottomSheet(
      elevation: 0,
      barrierColor: Colors.black26,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Consumer(
          builder: (context, ref, _) {
            late bool notificationOn;
            late String status;

            // WidgetsBinding.instance.addPostFrameCallback((_) {
            final checkStatus =
                ref.watch(checkStatusControllerProvider(rutineId));
            final members =
                ref.read(memberControllerProvider(rutineId).notifier);

            status = checkStatus.value?.activeStatus ?? '';
            notificationOn = checkStatus.value?.notificationOn ?? false;
            //  });

            return SizedBox(
              height: 250,
              width: MediaQuery.of(context).size.width - 10,
              child: Card(
                color: Colors.white,
                margin: const EdgeInsets.all(18.0).copyWith(bottom: 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Consumer(builder: (context, ref, _) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CheckBoxSelector(
                        isChacked: notificationOn,
                        icon: Icons.notifications_active,
                        text: "notifications_active",
                        onTap: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ref
                                .watch(checkStatusControllerProvider(rutineId)
                                    .notifier)
                                .notificationOn(context);
                          });
                        },
                      ),
                      CheckBoxSelector(
                        isChacked: !notificationOn,
                        icon: Icons.notifications_off,
                        text: "Notification Off",
                        color: Colors.red,
                        onTap: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ref
                                .watch(checkStatusControllerProvider(rutineId)
                                    .notifier)
                                .notificationOff(context);
                          });
                        },
                      ),
                      const MyDivider(),
                      CheckBoxSelector(
                        icon: Icons.logout_sharp,
                        text: "Leave Routine",
                        color: Colors.red,
                        onTap: () {
                          Alert.errorAlertDialogCallBack(
                            context,
                            "Are you sure you want to leave?",
                            onConfirm: () {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                ref
                                    .watch(
                                        checkStatusControllerProvider(rutineId)
                                            .notifier)
                                    .leaveMember(context, ref);
                              });
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
      },
    );
  }
}
