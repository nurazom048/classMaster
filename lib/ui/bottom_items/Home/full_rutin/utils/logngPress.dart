// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/helper/constant/AppColor.dart';
import 'package:table/models/priode/all_priode_models.dart';
import 'package:table/ui/bottom_items/Add/screens/addClassScreen.dart';
import '../../../Add/screens/addPriode.dart';
import '../controller/Rutin_controller.dart';
import '../controller/priodeController.dart';

class PriodeAlart {
//
  //! **********     long press to class       *********//
  static Future<dynamic> logPressClass(
    BuildContext context, {
    rutinId,
    classId,
  }) {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) => Consumer(builder: (context, ref, _) {
        return CupertinoActionSheet(
          title: const Text(" Do you want to.. ",
              style: TextStyle(fontSize: 22, color: Colors.black87)),
          actions: [
// Eddit

            CupertinoActionSheetAction(
              child: Text("Eddit Class ",
                  style: TextStyle(color: AppColor.nokiaBlue)),
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => AddClassSceen(
                      rutinId: rutinId,
                      classId: classId,
                      isEdit: true,
                    ),
                  ),
                );
              },
            ),
// ddelete
            CupertinoActionSheetAction(
              child: const Text("Remove class",
                  style: TextStyle(color: Colors.red)),
              onPressed: () {
                // ref
                //     .watch(priodeController.notifier)
                //     .deletePriode(ref, context, priodeId, rutinId);

                Navigator.pop(context);
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text("cancel"),
            onPressed: () => Navigator.pop(context),
          ),
        );
      }),
    );
  }

  //? **********     long press to priode       *********//

  static Future<dynamic> logPressOnPriode(
      BuildContext context, priodeId, rutinId, AllPriode Priode) {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) => Consumer(builder: (context, ref, _) {
        return CupertinoActionSheet(
          title: const Text(" Do you want to.. ",
              style: TextStyle(fontSize: 22, color: Colors.black87)),
          actions: [
// Eddit

            CupertinoActionSheetAction(
              child: Text("Eddit", style: TextStyle(color: AppColor.nokiaBlue)),
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => AppPriodePage(
                              totalpriode: 1,
                              rutinId: rutinId,
                              priode_id: Priode.id,
                              isEddit: true,
                            )));
              },
            ),
// ddelete
            CupertinoActionSheetAction(
              child: const Text("Remove", style: TextStyle(color: Colors.red)),
              onPressed: () {
                ref
                    .watch(priodeController.notifier)
                    .deletePriode(ref, context, priodeId, rutinId);

                Navigator.pop(context);
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text("cancel"),
            onPressed: () => Navigator.pop(context),
          ),
        );
      }),
    );
  }
}
