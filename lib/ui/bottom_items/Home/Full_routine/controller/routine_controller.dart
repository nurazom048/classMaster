// ignore_for_file: non_constant_identifier_names, camel_case_types, invalid_return_type_for_catch_error

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/core/dialogs/alert_dialogs.dart';
import 'package:table/ui/bottom_items/Home/Full_routine/request/rutin_request.dart';

//.... Controller...//
// final chackStatusUser_provider = FutureProvider.family
//     .autoDispose<CheckStatusModel, String>((ref, rutin_id) {
//   return ref.read(FullRutinProvider).chackStatus(rutin_id);
// });

///
///
final RutinControllerProvider = StateNotifierProvider<RutinController, bool?>(
    (ref) => RutinController(ref.watch(FullRutinProvider)));

///
class RutinController extends StateNotifier<bool?> {
  FullRutinrequest FullRutinreques;

  RutinController(this.FullRutinreques) : super(null);

  //......Delete Class....//

  void deleteClass(String classId, BuildContext context) {
    FullRutinreques.deleteClass(context, classId)
        .catchError((error) => Alert.handleError(context, error))
        .then((value) => Alert.showSnackBar(context, value.message));
  }
}
