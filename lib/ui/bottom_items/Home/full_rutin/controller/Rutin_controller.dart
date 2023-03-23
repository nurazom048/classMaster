// ignore_for_file: non_constant_identifier_names, camel_case_types, invalid_return_type_for_catch_error

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/widgets/Alart.dart';
import '../../../../../models/chackStatusModel.dart';
import '../request/Rutin_request/rutin_request.dart';

//.... Controller...//
final chackStatusUser_provider = FutureProvider.family
    .autoDispose<CheckStatusModel, String>((ref, rutin_id) {
  return ref.read(FullRutinProvider).chackStatus(rutin_id);
});

///
///
final RutinControllerProvider = StateNotifierProvider<RutinController, bool?>(
    (ref) => RutinController(ref.watch(FullRutinProvider)));

///
class RutinController extends StateNotifier<bool?> {
  FullRutinrequest FullRutinreques;

  RutinController(this.FullRutinreques) : super(null);

  //... Delete Rutin...//

  void deleteRutin(String rutin_id, context) {
    var res = context.watch(deleteRutinProvider(rutin_id));

    res.when(
      data: (data) {},
      error: (error, stackTrace) => Alart.handleError(context, error),
      loading: () {},
    );
  }

  //......Delete Class....//

  void deleteClass(String classId, BuildContext context) async {
    final result = await FullRutinreques.deleteClass(context, classId)
        .catchError((error) => Alart.handleError(context, error))
        .then((value) => Alart.showSnackBar(context, value.message));
  }
}
