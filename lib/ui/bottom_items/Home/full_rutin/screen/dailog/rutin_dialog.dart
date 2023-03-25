// ignore_for_file: camel_case_types, non_constant_identifier_names, unused_local_variable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/controller/chack_status_controller.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/controller/see_all_member.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/screen/widgets/seeAllCaotensList.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/screen/widgets/see_all_request.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/screen/widgets/select_account.dart';
import 'package:table/ui/bottom_items/add_eddit_remove/addPriode.dart';
import 'package:table/ui/bottom_items/add_eddit_remove/add_class.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/controller/members_controllers.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/controller/Rutin_controller.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/controller/priodeController.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/screen/view_more_details.dart';
import 'package:table/widgets/Alart.dart';
import 'package:table/widgets/text%20and%20buttons/squareButton.dart';

class RutinDialog {
  //
  //**********     long press to class       *********//
  static Future<dynamic> long_press_to_class(BuildContext context, classId) {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text(" Do you want to.. ",
            style: TextStyle(fontSize: 22, color: Colors.black87)),
        actions: [
          CupertinoActionSheetAction(
              child: const Text("Eddit"), // go to eddit

              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => AddClass(
                              rutinId: "rutinId",
                              classId: classId,
                              isEdit: true,
                            )));
              }),
          Consumer(builder: (context, ref, _) {
            return CupertinoActionSheetAction(
              child: const Text("Remove", style: TextStyle(color: Colors.red)),
              onPressed: () {
                ref
                    .watch(RutinControllerProvider.notifier)
                    .deleteClass(classId, context);

                Navigator.pop(context);
              },
            );
          }),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text("cancel"),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  //**********     long press to priode       *********//

  static Future<dynamic> logPressOnPriode(
      BuildContext context, priodeId, rutinId) {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text(" Do you want to.. ",
            style: TextStyle(fontSize: 22, color: Colors.black87)),
        actions: [
          Consumer(builder: (context, ref, _) {
            return CupertinoActionSheetAction(
              child: const Text("Remove", style: TextStyle(color: Colors.red)),
              onPressed: () {
                ref
                    .watch(priodeController.notifier)
                    .deletePriode(ref, context, priodeId, rutinId);

                Navigator.pop(context);
              },
            );
          }),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text("cancel"),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  //**********     ChackStatusUser_BottomSheet       **********/
  static ChackStatusUser_BottomSheet(BuildContext context, rutinId) {
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
              // final s = ref.read(seeAllRequestControllerProvider(rutinId).notifier).
              final seeAllJonReq =
                  ref.read(seeAllRequestControllerProvider(rutinId).notifier);

              //.. providers with notifier
              final chackStatusNotifier =
                  ref.watch(chackStatusControllerProvider(rutinId).notifier);
              final members =
                  ref.read(memberControllerProvider(rutinId).notifier);

              // join controller provider ...//

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  chackStatus.when(
                      data: (data) {
                        String status = chackStatus.value?.activeStatus ?? '';

                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            children: [
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
                                  SqureButton(
                                    icon: Icons.more_horiz,
                                    text: 'view more',
                                    ontap: () => Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        fullscreenDialog: true,
                                        builder: (context) =>
                                            ViewMorepage(rutinId),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 20),
                              if (data.isCaptain || data.isOwner)
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SqureButton(
                                          icon: Icons.add,
                                          text: "Add Priode",
                                          ontap: () => Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              fullscreenDialog: true,
                                              builder: (context) =>
                                                  AppPriodePage(
                                                      rutinId: rutinId),
                                            ),
                                          ),
                                        ),
                                        SqureButton(
                                          icon: Icons.add,
                                          text: "Add Class",
                                          ontap: () => Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              fullscreenDialog: true,
                                              builder: (context) =>
                                                  AddClass(rutinId: rutinId),
                                            ),
                                          ),
                                        ),
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
                                                        buttotext:
                                                            "Add captens",
                                                        onUsername:
                                                            (seleted_username,
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
                                    const Divider(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SqureButton(
                                            icon: Icons.groups_2,
                                            count: data.sentRequestCount,
                                            text: "see all request",
                                            ontap: () => Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                    fullscreenDialog: true,
                                                    builder: (context) =>
                                                        SeeAllRequest(
                                                          rutin_id: rutinId,
                                                          onRejectUsername:
                                                              (username) {
                                                            seeAllJonReq
                                                                .rejectMembers(
                                                                    username,
                                                                    context);
                                                          },
                                                          acceptUsername:
                                                              (username) {
                                                            seeAllJonReq
                                                                .acceptMember(
                                                                    username,
                                                                    context);
                                                          },
                                                        )))),
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
                                                          seleted_username,
                                                          context);
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SqureButton(
                                            icon: Icons.person_remove,
                                            text: "remove members",
                                            color: Colors.redAccent,
                                            ontap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      seeAllcaptensList(
                                                    rutinId: rutinId,
                                                    buttotext: "Remove Member",
                                                    onUsername:
                                                        (seleted_username, _) {
                                                      members.removeMember(
                                                          context,
                                                          seleted_username);
                                                      print(
                                                          "select member $seleted_username");
                                                    },
                                                  ),
                                                ))),
                                        SqureButton(
                                          icon: Icons.person_remove,
                                          color: Colors.redAccent,
                                          text: "remove captens",
                                        ),
                                        if (data.isOwner == true)
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
                                                    .watch(
                                                        RutinControllerProvider
                                                            .notifier)
                                                    .deleteRutin(
                                                        rutinId, context);
                                              },
                                            ),
                                          )
                                        else
                                          const SizedBox.shrink(),
                                      ],
                                    ),
                                  ],
                                )
                              else
                                const SizedBox.shrink()
                            ],
                          ),
                        );
                      },
                      loading: () => const Text("lofing"),
                      error: (error, stackTrace) {
                        print(error.toString());
                        return Alart.handleError(context, error);
                      }),
                ],
              );
            }),
          );
        });
  }
}
