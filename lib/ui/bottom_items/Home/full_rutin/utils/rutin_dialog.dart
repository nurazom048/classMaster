// ignore_for_file: camel_case_types, non_constant_identifier_names, unused_local_variable, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/controller/chack_status_controller.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/controller/members_controllers.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/widgets/chekbox_selector_button.dart';
import 'package:table/ui/bottom_items/Home/home_req/home_rutins_controller.dart';
import 'package:table/widgets/appWidget/dottted_divider.dart';
import '../../../../../core/component/Loaders.dart';
import '../../../../../core/dialogs/alart_dialogs.dart';
import '../../../../../widgets/text and buttons/square_button.dart';
import '../../../Account/utils/confrom_alart_dilog.dart';
import '../../home_req/home_req.dart';

class RutinDialog {
  //**********     ChackStatusUser_BottomSheet       **********/
  static ChackStatusUser_BottomSheet(
    BuildContext context, {
    required String routineID,
    required String routineName,
    required HomeRutinsController rutinsController,
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
              final chackStatus =
                  ref.watch(chackStatusControllerProvider(routineID));

              // state providers with notifier
              final chackStatusNotifier =
                  ref.watch(chackStatusControllerProvider(routineID).notifier);
              final members =
                  ref.read(memberControllerProvider(routineID).notifier);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  chackStatus.when(
                      data: (data) {
                        String status = chackStatus.value?.activeStatus ?? '';

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          // runSpacing: 20,
                          // alignment: WrapAlignment.center,
                          children: [
                            if (status == "joined")
                              SqureButton(
                                icon: Icons.logout,
                                inActiveText: "leave",
                                color: Colors.redAccent,
                                text: data.activeStatus,
                                ontap: () {
                                  return Alart.errorAlertDialogCallBack(
                                    context,
                                    "are you sure you want to leave",
                                    onConfirm: () {
                                      chackStatusNotifier.leaveMember(
                                          ctx, ref); // Pass the context here
                                    },
                                  );
                                },
                              )
                            else
                              SqureButton(
                                icon: Icons.people_rounded,
                                inActiveIcon: Icons.telegram,
                                inActiveText: status,
                                status:
                                    status == "request_pending" ? true : false,
                                text: status,
                                ontap: () {
                                  chackStatusNotifier.sendReqController(ctx);
                                },
                              ),
                            SqureButton(
                              inActiveIcon: Icons.bookmark_added,
                              icon: Icons.bookmark_add_sharp,
                              text: 'Save',
                              inActiveText: "add to save",
                              status: chackStatus.value?.isSave,
                              ontap: () {
                                chackStatusNotifier.saveUnsave(
                                  ctx,
                                  !(chackStatus.value?.isSave ?? false),
                                );

                                // if (chackStatus.value?.isSave ??
                                //     false == false) {
                                //   ref.refresh(save_rutins_provider(1));
                                // }
                              },
                            ),
                            if (data.isCaptain || data.isOwner) ...[
                              if (data.isOwner == true) ...[
                                SqureButton(
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
                                            rutinsController.deleteRutin(
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
                          Alart.handleError(context, error)),
                ],
              );
            }),
          );
        });
  }

  //
  static rutineNotficationSeleect(BuildContext context, String rutineId) {
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
            final chackStatus =
                ref.watch(chackStatusControllerProvider(rutineId));
            final members =
                ref.read(memberControllerProvider(rutineId).notifier);

            status = chackStatus.value?.activeStatus ?? '';
            notificationOn = chackStatus.value?.notificationOn ?? false;
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
                      ChackBoxSelector(
                        isChacked: notificationOn,
                        icon: Icons.notifications_active,
                        text: "notifications_active",
                        onTap: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ref
                                .watch(chackStatusControllerProvider(rutineId)
                                    .notifier)
                                .notificationOn(context);
                          });
                        },
                      ),
                      ChackBoxSelector(
                        isChacked: !notificationOn,
                        icon: Icons.notifications_off,
                        text: "Notification Off",
                        color: Colors.red,
                        onTap: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ref
                                .watch(chackStatusControllerProvider(rutineId)
                                    .notifier)
                                .notificationOff(context);
                          });
                        },
                      ),
                      const MyDivider(),
                      ChackBoxSelector(
                        icon: Icons.logout_sharp,
                        text: "Leave Routine",
                        color: Colors.red,
                        onTap: () {
                          Alart.errorAlertDialogCallBack(
                            context,
                            "Are you sure you want to leave?",
                            onConfirm: () {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                ref
                                    .watch(
                                        chackStatusControllerProvider(rutineId)
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
