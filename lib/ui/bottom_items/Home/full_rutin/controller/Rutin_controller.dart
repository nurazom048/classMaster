// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/models/seeAllRequestModel.dart';
import 'package:table/widgets/Alart.dart';
import '../../../../../models/chackStatusModel.dart';
import '../Rutin_request/rutin_request.dart';
import '../request/rutin_request.dart';

class accept {
  final String rutin_id;
  final String? usernme;

  accept({required this.rutin_id, this.usernme});
}

//.... Controller...//
final chackStatusUser_provider = FutureProvider.family
    .autoDispose<CheckStatusModel, String>((ref, rutin_id) {
  return ref.read(FullRutinProvider.notifier).chackStatus(rutin_id);
});

final see_all_request_provider =
    FutureProvider.family.autoDispose<RequestModel, String>((ref, rutin_id) {
  return ref.read(RutinProvider).sell_all_request(rutin_id);
});
final accept_request_provider =
    FutureProvider.autoDispose.family<dynamic, accept>((ref, accept) async {
  return await ref
      .read(RutinProvider)
      .acceptRequest(accept.rutin_id, accept.usernme);
});
final reject_request_provider =
    FutureProvider.autoDispose.family<dynamic, accept>((ref, accept) async {
  return await ref
      .read(RutinProvider)
      .rejectRequest(accept.rutin_id, accept.usernme);
});

///
///
final RutinControllerProvider = StateNotifierProvider<RutinController, bool?>(
    (ref) => RutinController(ref.read(RutinProvider)));

///
class RutinController extends StateNotifier<bool?> {
  var FullRutinReq;

  RutinController(this.FullRutinReq) : super(null);

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
    final result = await FullRutinReq.deleteClass(context, classId);

    result.fold(
      (errorMessage) => Alart.errorAlartDilog(context, errorMessage),
      (response) {
        state = response.activeStatus;

        Alart.showSnackBar(context, response.message);
      },
    );
  }
}
