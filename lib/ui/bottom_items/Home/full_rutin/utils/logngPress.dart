// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Add/screens/addClassScreen.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/utils/rutin_dialog.dart';
import '../controller/Rutin_controller.dart';
import '../controller/priodeController.dart';

class LongPressDialog {
//
  //! **********     long press to class       *********//
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
                        builder: (context) => AddClassSceen(
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

  //? **********     long press to priode       *********//

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
}
