// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classmate/core/constant/app_color.dart';
import 'package:classmate/core/dialogs/alert_dialogs.dart';

import '../../../../../features/routine_Fetures/data/datasources/class_request.dart';
import '../screens/add_class_screen.dart';

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
                      isUpdate: true,
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
                Alert.errorAlertDialogCallBack(context,
                    'Do you want to delete this Class? You can\'t undo this action.',
                    onConfirm: () {
                  ClassRequest.removeClass(context, ref, classId, rutinId);
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
}
