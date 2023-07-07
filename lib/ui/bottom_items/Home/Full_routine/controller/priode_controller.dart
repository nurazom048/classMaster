// ignore_for_file: unused_result

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/dialogs/alert_dialogs.dart';
import '../request/priode_request.dart';

//.. provider...//
final priodeController = StateNotifierProvider.autoDispose((ref) {
  return PriodeClassController(ref.watch(priodeRequestProvider));
});

//
//...class....//
class PriodeClassController extends StateNotifier<bool> {
  PriodeRequest priodeReq;

  PriodeClassController(this.priodeReq) : super(false);

  //....deletePriode
  void deletePriode(WidgetRef ref, BuildContext context, String priodeId,
      String routineId) async {
    var deleteRes = await PriodeRequest().deletePriode(priodeId);

    deleteRes.fold(
      (l) {
        state = false;
        Navigator.pop(context);

        return Alert.errorAlertDialog(context, l);
      },
      (r) {
        ref.refresh(allPriodeProvider(routineId));
        state = false;

        Alert.showSnackBar(context, r.message);
      },
    );
  }

  //
  //....addPriode...//
  void addPriode(WidgetRef ref, context, String routineId, DateTime startTime,
      DateTime endTime) async {
    var addRes = await PriodeRequest().addPriode(routineId, startTime, endTime);

    addRes.fold(
      (l) {
        // state = false;
        return Alert.errorAlertDialog(context, l);
      },
      (r) {
        //state = false;
        ref.refresh(allPriodeProvider(routineId));
        Alert.showSnackBar(context, r.message);
        Navigator.pop(context);
      },
    );
  }

  //....Eddit priode...//
  void edditPriode(WidgetRef ref, context, String routineId, String priodeId,
      DateTime startTime, DateTime endTime) async {
    var edditPriode =
        await PriodeRequest().edditPriode(priodeId, startTime, endTime);

    edditPriode.fold(
      (l) {
        // state = false;
        return Alert.errorAlertDialog(context, l);
      },
      (r) {
        //state = false;
        ref.refresh(allPriodeProvider(routineId));
        Alert.showSnackBar(context, r.message);
        Navigator.pop(context);
      },
    );
  }
}
