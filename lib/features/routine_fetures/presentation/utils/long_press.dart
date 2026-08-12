// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classmate/core/constant/app_color.dart';
import 'package:classmate/core/dialogs/alert_dialogs.dart';

import 'package:classmate/features/routine_fetures/presentation/providers/routine_controller.dart';
import '../screens/screens.dart';

class PeriodAlert {
  //
  //! **********     long press to class       *********//
  static Future<dynamic> logPressClass(
    BuildContext context, {
    required String routineId,
    required String classId,
    required bool canModify,
  }) {
    return showCupertinoModalPopup(
      context: context,
      builder:
          (context) => Consumer(
            builder: (context, ref, _) {
              return CupertinoActionSheet(
                title: const Text(
                  "Do you want to.. ?",
                  style: TextStyle(fontSize: 22, color: Colors.black87),
                ),
                actions: [
                  if (canModify) ...[
                    // Edit
                    CupertinoActionSheetAction(
                      child: Text(
                        "Update Class ",
                        style: TextStyle(color: AppColor.nokiaBlue),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            fullscreenDialog: true,
                            builder:
                                (context) => AddClassScreen(
                                  routineId: routineId,
                                  classId: classId,
                                  isUpdate: true,
                                ),
                          ),
                        );
                      },
                    ),
                    // delete
                    CupertinoActionSheetAction(
                      child: const Text(
                        "Remove class",
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Alert.errorAlertDialogCallBack(
                          context,
                          'Do you want to delete this Class? You can\'t undo this action.',
                          onConfirm: (isConfirmed) {
                            if (isConfirmed) {
                              ref
                                  .read(routineControllerProvider.notifier)
                                  .deleteClass(classId, routineId, ref, context);
                            }
                          },
                        );
                      },
                    ),
                  ] else
                    CupertinoActionSheetAction(
                      onPressed: () {},
                      child: const Text('Sorry No Action Here'),
                    ),
                ],
                cancelButton: CupertinoActionSheetAction(
                  child: const Text("cancel"),
                  onPressed: () => Navigator.pop(context),
                ),
              );
            },
          ),
    );
  }

  //! **********     long press to exam       *********//
  static Future<dynamic> logPressExam(
    BuildContext context, {
    required String routineId,
    required String examId,
    required bool canModify,
  }) {
    return showCupertinoModalPopup(
      context: context,
      builder:
          (context) => Consumer(
            builder: (context, ref, _) {
              return CupertinoActionSheet(
                title: const Text(
                  "Do you want to.. ?",
                  style: TextStyle(fontSize: 22, color: Colors.black87),
                ),
                actions: [
                  if (canModify) ...[
                    CupertinoActionSheetAction(
                      child: Text(
                        "Update Exam",
                        style: TextStyle(color: AppColor.nokiaBlue),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        // Route to update exam
                      },
                    ),
                    CupertinoActionSheetAction(
                      child: const Text(
                        "Remove Exam",
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Alert.errorAlertDialogCallBack(
                          context,
                          'Do you want to delete this Exam? You can\'t undo this action.',
                          onConfirm: (isConfirmed) {
                            if (isConfirmed) {
                              // Delete exam action
                            }
                          },
                        );
                      },
                    ),
                  ] else
                    CupertinoActionSheetAction(
                      onPressed: () {},
                      child: const Text('Sorry No Action Here'),
                    ),
                ],
                cancelButton: CupertinoActionSheetAction(
                  child: const Text("cancel"),
                  onPressed: () => Navigator.pop(context),
                ),
              );
            },
          ),
    );
  }
}
