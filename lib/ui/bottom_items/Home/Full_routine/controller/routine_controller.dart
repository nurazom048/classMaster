// ignore_for_file: non_constant_identifier_names, camel_case_types, invalid_return_type_for_catch_error

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/core/dialogs/alert_dialogs.dart';
import 'package:table/ui/bottom_items/Home/Full_routine/request/routine_request.dart';

//.... Controller...//

///
final routineControllerProvider =
    StateNotifierProvider<RoutineController, bool?>(
        (ref) => RoutineController(ref.watch(fullRoutineProvider)));

///
class RoutineController extends StateNotifier<bool?> {
  FullRoutineRequest fullRoutineRequest;

  RoutineController(this.fullRoutineRequest) : super(null);

  //......Delete Class....//

  void deleteClass(String classId, BuildContext context) {
    fullRoutineRequest
        .deleteClass(context, classId)
        .catchError((error) => Alert.handleError(context, error))
        .then((value) => Alert.showSnackBar(context, value.message));
  }
}
