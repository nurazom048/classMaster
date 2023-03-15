// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/add_eddit_remove/addPriode.dart';
import 'package:table/ui/add_eddit_remove/add_class.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/class_request/class_request.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/full_rutin_ui/view_more_details.dart';
import 'package:table/ui/bottom_items/Home/home_req/priode_reuest.dart';
import 'package:table/widgets/Alart.dart';
import 'package:table/widgets/text%20and%20buttons/squareButton.dart';

abstract class full_rutin_assist {
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
          CupertinoActionSheetAction(
            child: const Text("Remove", style: TextStyle(color: Colors.red)),
            onPressed: () {
              ClassesRequest().deleteClass(context, classId);
              print(classId);
              Navigator.pop(context);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text("cancel"),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  //**********     long press to priode       *********//

  static Future<dynamic> logPressOnPriode(BuildContext context, priodeId) {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text(" Do you want to.. ",
            style: TextStyle(fontSize: 22, color: Colors.black87)),
        actions: [
          CupertinoActionSheetAction(
            child: const Text("Remove", style: TextStyle(color: Colors.red)),
            onPressed: () {
              PriodeRequest().deletePriode(context, priodeId);
              print(priodeId);
              Navigator.pop(context);
            },
          ),
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
            color: Colors.grey[200],
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
              ),
              child: Consumer(builder: (context, ref, _) {
                final chackStatus =
                    ref.watch(ChackStatusUser_provider(rutinId));

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    chackStatus.when(
                        data: (data) {
                          print(data.isCaptain.toString());

                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SqureButton(
                                    icon: Icons.people_rounded,
                                    inActiveIcon: Icons.telegram,
                                    inActiveText: "Send Join request",
                                    text: 'Members',
                                    status: false,
                                  ),
                                  SqureButton(
                                    icon: Icons.bookmark_added,
                                    inActiveIcon: Icons.bookmark_add_sharp,
                                    text: 'Save',
                                    inActiveText: "add to save",
                                    status: data.isSave,
                                  ),
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
                                                  AppPriodePage(
                                                      rutinId: rutinId),
                                            ),
                                          ),
                                        ),
                                        const SqureButton(
                                            icon: Icons.person_add_alt_1,
                                            text: "Add captens"),
                                      ],
                                    ),
                                    const Divider(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        SqureButton(
                                            icon: Icons.groups_2,
                                            text: "see all request"),
                                        SqureButton(
                                            icon: Icons.person_add_alt_1,
                                            text: "Add members"),
                                      ],
                                    ),
                                    const Divider(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SqureButton(
                                          icon: Icons.person_remove,
                                          text: "remove members",
                                          color: Colors.redAccent,
                                        ),
                                        const SqureButton(
                                          icon: Icons.person_remove,
                                          color: Colors.redAccent,
                                          text: "remove captens",
                                        ),
                                        if (data.isOwner == true)
                                          const SqureButton(
                                            icon: Icons.delete,
                                            text: "Delete",
                                            color: Colors.red,
                                          )
                                        else
                                          const SizedBox.shrink(),
                                      ],
                                    ),
                                  ],
                                )
                              else
                                SizedBox.shrink()
                            ],
                          );
                        },
                        loading: () => const Text("lofing"),
                        error: (error, stackTrace) =>
                            Alart.handleError(context, error)),
                  ],
                );
              }),
            ),
          );
        });
  }
}
