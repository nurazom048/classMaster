// ignore_for_file: camel_case_types, non_constant_identifier_names, unused_local_variable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/add_eddit_remove/addPriode.dart';
import 'package:table/ui/add_eddit_remove/add_class.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/controller/members_controllers.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/controller/Rutin_controller.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/controller/priodeController.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/controller/request_controller.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/controller/save_controller.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/screen/add_members.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/screen/rutinMember.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/screen/see_all_request.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/screen/view_more_details.dart';
import 'package:table/widgets/Alart.dart';
import 'package:table/widgets/text%20and%20buttons/squareButton.dart';

abstract class full_rutin_diloge {
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
  static void ChackStatusUser_BottomSheet(BuildContext context, rutinId) {
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
              final chackStatus = ref.watch(chackStatusUser_provider(rutinId));
              final members = ref.read(memberRequestController.notifier);

              //... saveRutinController_Provider
              final saveUn = ref.watch(saveRutinController_Provider.notifier);
              final save = ref.watch(saveRutinController_Provider);

              // join controller provider ...//
              final joinCont = ref.watch(joinReqControllerProviders.notifier);
              final activeStatus = ref.watch(joinReqControllerProviders);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  chackStatus.when(
                      data: (data) {
                        bool isSave = save ?? data.isSave;
                        String aT = activeStatus ?? data.activeStatus;

                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            children: [
                              Text(activeStatus ?? ''),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (aT == "joined")
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
                                          joinCont.leaveMember(
                                              ref, rutinId, context);
                                        });
                                      },
                                    )
                                  else
                                    SqureButton(
                                        icon: Icons.people_rounded,
                                        inActiveIcon: Icons.telegram,
                                        inActiveText: aT,
                                        status: aT == "request_pending"
                                            ? true
                                            : false,
                                        text: aT,
                                        ontap: () => joinCont.sendReqController(
                                            rutinId, context, ref)),
                                  SqureButton(
                                      inActiveIcon: Icons.bookmark_added,
                                      icon: Icons.bookmark_add_sharp,
                                      text: 'Save',
                                      inActiveText: "add to save",
                                      status: isSave,
                                      ontap: () {
                                        // print(data.activeStatus);
                                        // print("onnnnnn");

                                        saveUn.saveUnsave(
                                            context, rutinId, isSave);
                                      }),
                                  SqureButton(
                                    icon: Icons.more_horiz,
                                    //  inActiveIcon: Icons.more_vert,
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
                              // Consumer(builder: (BuildContext context, ref, _) {
                              //   final saveNotifier = ref.watch(
                              //       svae_unsave_Controller_Provider.notifier);
                              //   final isSaved = saveNotifier.state ?? false;
                              //   final saveText = isSaved ? 'Yes' : 'No';
                              //   return Text("Saved: $isSaved");
                              // }),
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
                                                  builder: (context) {
                                                return AddMembers(
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
                                                );
                                              }),
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
                                                    builder:
                                                        (context) =>
                                                            SeeAllRequest(
                                                              rutin_id: rutinId,
                                                              onRejectUsername:
                                                                  (username) =>
                                                                      members.rejectMembers(
                                                                          ref,
                                                                          rutinId,
                                                                          username,
                                                                          context),
                                                              acceptUsername: (username) =>
                                                                  members.acceptMember(
                                                                      ref,
                                                                      rutinId,
                                                                      username,
                                                                      context),
                                                            )))),
                                        SqureButton(
                                            icon: Icons.person_add_alt_1,
                                            text: "Add members",
                                            ontap: () => Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                    fullscreenDialog: true,
                                                    builder: (context) =>
                                                        AddMembers(
                                                      buttotext: "Add member",
                                                      onUsername:
                                                          (seleted_username,
                                                              _) {
                                                        members.addMember(
                                                            rutinId,
                                                            seleted_username,
                                                            context);
                                                        print(
                                                            "hi an cll back $seleted_username");
                                                      },
                                                    ),
                                                  ),
                                                )),
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
                                                      rutin_member_page(
                                                    rutinId: rutinId,
                                                    onUsername:
                                                        (seleted_username, _) {
                                                      members.addMember(
                                                          rutinId,
                                                          seleted_username,
                                                          context);
                                                      print(
                                                          "hi an cll back $seleted_username");
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
                      error: (error, stackTrace) =>
                          Alart.handleError(context, error)),
                ],
              );
            }),
          );
        });
  }
}
