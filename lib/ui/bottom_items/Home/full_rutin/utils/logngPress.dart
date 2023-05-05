// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/helper/constant/app_color.dart';
import 'package:flutter/material.dart' as ma;

import 'package:table/models/priode/all_priode_models.dart';
import '../../../Add/request/class_request.dart';
import '../../../Add/screens/add_class_screen.dart';
import '../../../Add/screens/add_priode.dart';
import '../controller/priodeController.dart';

class PriodeAlart {
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
          title: const ma.Text(" Do you want to.. ",
              style: TextStyle(fontSize: 22, color: Colors.black87)),
          actions: [
// Eddit

            CupertinoActionSheetAction(
              child: ma.Text("Eddit Class ",
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
// ddelete
            CupertinoActionSheetAction(
              child: const ma.Text("Remove class",
                  style: TextStyle(color: Colors.red)),
              onPressed: () {
                ClassRequest.deleteClass(context, ref, classId, rutinId);
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const ma.Text("cancel"),
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
          title: const ma.Text(" Do you want to.. ",
              style: TextStyle(fontSize: 22, color: Colors.black87)),
          actions: [
// Eddit

            CupertinoActionSheetAction(
              child:
                  ma.Text("Eddit", style: TextStyle(color: AppColor.nokiaBlue)),
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
              child:
                  const ma.Text("Remove", style: TextStyle(color: Colors.red)),
              onPressed: () {
                ref
                    .watch(priodeController.notifier)
                    .deletePriode(ref, context, priodeId, rutinId);

                Navigator.pop(context);
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const ma.Text("cancel"),
            onPressed: () => Navigator.pop(context),
          ),
        );
      }),
    );
  }
}
