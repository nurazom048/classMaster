// ignore_for_file: camel_case_types, non_constant_identifier_names, unused_local_variable, avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/controller/chack_status_controller.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/controller/members_controllers.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/controller/Rutin_controller.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/widgets/chekbox_selector_button.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/widgets/select_account.dart';
import 'package:table/widgets/appWidget/dottted_divider.dart';
import 'package:table/widgets/progress_indicator.dart';
import '../../../../../core/dialogs/alart_dialogs.dart';
import '../../../../../widgets/text and buttons/square_button.dart';
import '../screen/viewMore/seeAllCaotensList.dart';

class RutinDialog {
  //**********     ChackStatusUser_BottomSheet       **********/
  static ChackStatusUser_BottomSheet(BuildContext context, rutinId, rutinName) {
    // show bottom sheet modal to check user status
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          // bottom sheet layout
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 50),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
            ),
            child: Consumer(builder: (context, ref, _) {
              // state providers
              final chackStatus =
                  ref.watch(chackStatusControllerProvider(rutinId));

              // state providers with notifier
              final chackStatusNotifier =
                  ref.watch(chackStatusControllerProvider(rutinId).notifier);
              final members =
                  ref.read(memberControllerProvider(rutinId).notifier);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  chackStatus.when(
                      data: (data) {
                        String status = chackStatus.value?.activeStatus ?? '';

                        return Wrap(
                          runSpacing: 20,
                          alignment: WrapAlignment.center,
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
                                    onConfirm: (bool isYes) {
                                      chackStatusNotifier.leaveMember(context);
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
                                  chackStatusNotifier
                                      .sendReqController(context);
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
                                  context,
                                  !(chackStatus.value?.isSave ?? false),
                                );
                              },
                            ),
                            if (data.isCaptain || data.isOwner) ...[
                              SqureButton(
                                icon: Icons.person_add_alt_1,
                                text: "Add captens",
                                ontap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SeelectAccount(
                                        addCapten: true,
                                        buttotext: "Add captens",
                                        onUsername:
                                            (seleted_username, setPosition) {
                                          members.AddCapten(
                                            rutinId,
                                            setPosition,
                                            seleted_username,
                                            context,
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                            if (data.isCaptain || data.isOwner) ...[
                              SqureButton(
                                icon: Icons.person_add_alt_1,
                                text: "Add members",
                                ontap: () {
                                  return Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      fullscreenDialog: true,
                                      builder: (context) => SeelectAccount(
                                        buttotext: "Add member",
                                        onUsername: (seleted_username, _) {
                                          members.addMember(
                                              seleted_username, context);
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                            if (data.isCaptain || data.isOwner) ...[
                              SqureButton(
                                icon: Icons.person_remove,
                                color: Colors.redAccent,
                                text: "remove captens",
                                ontap: () {
                                  return Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => seeAllcaptensList(
                                        rutinId: rutinId,
                                        buttotext: "Remove capten",
                                        color: Colors.red,
                                        onUsername: (seleted_username, _) {
                                          members.removeMember(
                                              context, seleted_username);
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                              if (data.isOwner == true) ...[
                                SqureButton(
                                  icon: Icons.delete,
                                  text: "Delete",
                                  color: Colors.red,
                                  ontap: () => Alart.errorAlertDialogCallBack(
                                    context,
                                    "Are you sure to delete",
                                    onConfirm: (isyes) {
                                      ref
                                          .watch(
                                              RutinControllerProvider.notifier)
                                          .deleteRutin(
                                            rutinId,
                                            context,
                                          );
                                    },
                                  ),
                                )
                              ]
                            ],
                          ],
                        );
                      },
                      loading: () => Container(
                          alignment: Alignment.center,
                          child: const Progressindicator(h: 100, w: 100)),
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
                  ref.watch(chackStatusControllerProvider(rutineId));

              // state providers with notifier
              final chackStatusNotifier =
                  ref.watch(chackStatusControllerProvider(rutineId).notifier);
              final members =
                  ref.read(memberControllerProvider(rutineId).notifier);

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
                    text: "Leave Routine",
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
