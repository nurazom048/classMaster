// ignore_for_file: non_constant_identifier_names, camel_case_types, invalid_return_type_for_catch_error

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classmate/core/dialogs/alert_dialogs.dart';

import '../../data/datasources/routine_request.dart';

//.... Controller...//

///
final routineControllerProvider =
    StateNotifierProvider<RoutineController, bool?>(
      (ref) => RoutineController(ref.watch(fullRoutineProvider)),
    );

///
class RoutineController extends StateNotifier<bool?> {
  FullRoutineRequest fullRoutineRequest;

  RoutineController(this.fullRoutineRequest) : super(null);

  //......Delete Class....//
  Future<void> deleteClass(String classId, BuildContext context) async {
    try {
      final value = await fullRoutineRequest.deleteClass(context, classId);
      if (context.mounted) {
        Alert.showSnackBar(context, value.message);
      }
    } catch (error) {
      if (context.mounted) {
        Alert.handleError(context, error);
      }
    }
  }
}
