// ignore_for_file: camel_case_types, non_constant_identifier_names, unused_local_variable, avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/controller/chack_status_controller.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/controller/see_all_req_controller.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/utils/logngPress.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/controller/members_controllers.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/controller/Rutin_controller.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/widgets/select_account.dart';
import 'package:table/widgets/progress_indicator.dart';
import 'package:table/widgets/text%20and%20buttons/squareButton.dart';
import '../../../../../core/dialogs/Alart_dialogs.dart';
import '../widgets/seeAllCaotensList.dart';

class RutinDialog extends LongPressDialog {
  //**********     ChackStatusUser_BottomSheet       **********/
  static ChackStatusUser_BottomSheet(BuildContext context, rutinId, rutinName) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 30),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
            ),
            child: Consumer(builder: (context, ref, _) {
              //! providers
              final chackStatus =
                  ref.watch(chackStatusControllerProvider(rutinId));
              final seeAllJonReq =
                  ref.read(seeAllRequestControllerProvider(rutinId).notifier);

              //!.. providers with notifier
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

                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(children: [
//? _____________________ (1st row )=>  join , save , view more________________________________//
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                        //  Navigator.pop(context);

                                        chackStatusNotifier
                                            .leaveMember(context);
                                      });
                                    },
                                  )
                                else
                                  SqureButton(
                                      icon: Icons.people_rounded,
                                      inActiveIcon: Icons.telegram,
                                      inActiveText: status,
                                      status: status == "request_pending"
                                          ? true
                                          : false,
                                      text: status,
                                      ontap: () {
                                        chackStatusNotifier
                                            .sendReqController(context);
                                      }),
                                SqureButton(
                                    inActiveIcon: Icons.bookmark_added,
                                    icon: Icons.bookmark_add_sharp,
                                    text: 'Save',
                                    inActiveText: "add to save",
                                    status: chackStatus.value?.isSave,
                                    ontap: () {
                                      chackStatusNotifier.saveUnsave(
                                          context,
                                          !(chackStatus.value?.isSave ??
                                              false));
                                    }),
                                // SqureButton(
                                //   icon: Icons.more_horiz,
                                //   text: 'view more',
                                //   ontap: () => Navigator.push(
                                //     context,
                                //     CupertinoPageRoute(
                                //       fullscreenDialog: true,
                                //       builder: (context) =>
                                //           ViewMorepage(rutinId),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                            const Divider(height: 20),
/* ___________________________ (2nd row )=>  add priode , add class , add capten________________________________*/

                            if (data.isCaptain || data.isOwner) ...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SqureButton(
                                    icon: Icons.person_add_alt_1,
                                    text: "Add captens",
                                    ontap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SeelectAccount(
                                                  addCapten: true,
                                                  buttotext: "Add captens",
                                                  onUsername: (seleted_username,
                                                      setPosition) {
                                                    members.AddCapten(
                                                        rutinId,
                                                        setPosition,
                                                        seleted_username,
                                                        context);
                                                    print(
                                                        "hi an cll back $seleted_username");
                                                  },
                                                )),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                            const Divider(height: 20),
/* ___________________________ (3rd row )=>  see all request ,add member ________________________________*/

                            if (data.isCaptain || data.isOwner)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SqureButton(
                                      icon: Icons.person_add_alt_1,
                                      text: "Add members",
                                      ontap: () {
                                        return Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            fullscreenDialog: true,
                                            builder: (context) =>
                                                SeelectAccount(
                                              buttotext: "Add member",
                                              onUsername:
                                                  (seleted_username, _) {
                                                members.addMember(
                                                    seleted_username, context);
                                                print(
                                                    "hi an cll back $seleted_username");
                                              },
                                            ),
                                          ),
                                        );
                                      }),
                                ],
                              ),
                            const Divider(height: 20),
/* ___________________________ (last row )=>  remove member , remove capten ,delete rutin________________________________*/

                            if (data.isCaptain || data.isOwner)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SqureButton(
                                    icon: Icons.person_remove,
                                    color: Colors.redAccent,
                                    text: "remove captens",
                                    ontap: () {
                                      return Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                seeAllcaptensList(
                                              rutinId: rutinId,
                                              buttotext: "Remove capten",
                                              Color: Colors.red,
                                              onUsername:
                                                  (seleted_username, _) {
                                                members.removeMember(
                                                    context, seleted_username);
                                                print(
                                                    "select member $seleted_username");
                                              },
                                            ),
                                          ));
                                    },
                                  ),
                                  if (data.isOwner == true) ...[
                                    SqureButton(
                                      icon: Icons.delete,
                                      text: "Delete",
                                      color: Colors.red,
                                      ontap: () =>
                                          Alart.errorAlertDialogCallBack(
                                        context,
                                        "Are you sure to delete",
                                        onConfirm: (isyes) {
                                          ref
                                              .watch(RutinControllerProvider
                                                  .notifier)
                                              .deleteRutin(rutinId, context);
                                        },
                                      ),
                                    )
                                  ]
                                ],
                              )
                          ]),
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
}
