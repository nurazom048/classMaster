// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/constant/app_color.dart';
import 'package:table/core/dialogs/alert_dialogs.dart';

import 'package:table/models/priode/all_priode_models.dart';
import '../../../Add/request/class_request.dart';
import '../../../Add/screens/add_class_screen.dart';
import '../../../Add/screens/add_priode.dart';
import '../controller/priode_controller.dart';

class PriodeAlert {
//
  //! **********     long press to class       *********//
  static Future<dynamic> logPressClass(
    BuildContext context, {
    required String rutinId,
    required String classId,
  }) {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) => Consumer(builder: (context, ref, _) {
        return CupertinoActionSheet(
          title: const Text(" Do you want to.. ?",
              style: TextStyle(fontSize: 22, color: Colors.black87)),
          actions: [
// Eddit

            CupertinoActionSheetAction(
              child: Text("Update Class ",
                  style: TextStyle(color: AppColor.nokiaBlue)),
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => AddClassScreen(
                      routineId: rutinId,
                      classId: classId,
                      isEdit: true,
                    ),
                  ),
                );
              },
            ),
// delete
            CupertinoActionSheetAction(
              child: const Text("Remove class",
                  style: TextStyle(color: Colors.red)),
              onPressed: () {
                // Navigator.of(context).pop();
                //
                Alert.errorAlertDialogCallBack(context,
                    'Do you want to delete this Class? You can\'t undo this action.',
                    onConfirm: () {
                  ClassRequest.deleteClass(context, ref, classId, rutinId);
                  Navigator.of(context).pop();
                });
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
      BuildContext context, priodeId, String routineId, AllPriode Priode) {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) => Consumer(builder: (context, ref, _) {
        //Provider
        final periodNotifier = ref.watch(priodeController(routineId).notifier);
        return CupertinoActionSheet(
          title: const Text(" Do you want to.. ",
              style: TextStyle(fontSize: 22, color: Colors.black87)),
          actions: [
// Eddit

            CupertinoActionSheetAction(
              child: Text(
                "Update",
                style: TextStyle(color: AppColor.nokiaBlue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => AppPriodePage(
                              totalPriode: 1,
                              routineId: routineId,
                              priodeId: Priode.id,
                              isEdit: true,
                            )));
              },
            ),
// delete
            CupertinoActionSheetAction(
              child: const Text("Remove", style: TextStyle(color: Colors.red)),
              onPressed: () {
                periodNotifier.deletePriode(ref, context, priodeId);
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
