// ignore_for_file: unused_result

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/dialogs/alert_dialogs.dart';
import '../request/priode_request.dart';

//.. prvider...//
final priodeController = StateNotifierProvider.autoDispose((ref) {
  return PriodeClassController(ref.watch(priodeRequestProvider));
});

//
//...class....//
class PriodeClassController extends StateNotifier<bool> {
  PriodeRequest priodereq;

  PriodeClassController(this.priodereq) : super(false);

  //....deletePriode
  void deletePriode(WidgetRef ref, BuildContext context, String priodeId,
      String rutinId) async {
    var deleteRes = await PriodeRequest().deletePriode(priodeId);

    deleteRes.fold(
      (l) {
        state = false;
        return Alert.errorAlertDialog(context, l);
      },
      (r) {
        ref.refresh(allPriodeProvider(rutinId));
        state = false;

        Alert.showSnackBar(context, r.message);
      },
    );
  }

  //
  //....addPriode...//
  void addPriode(WidgetRef ref, context, String rutinId, DateTime startTime,
      DateTime endTime) async {
    var addRes = await PriodeRequest().addPriode(rutinId, startTime, endTime);

    addRes.fold(
      (l) {
        // state = false;
        return Alert.errorAlertDialog(context, l);
      },
      (r) {
        //state = false;
        ref.refresh(allPriodeProvider(rutinId));
        Alert.showSnackBar(context, r.message);
        Navigator.pop(context);
      },
    );
  }

  //....Eddit priode...//
  void edditPriode(WidgetRef ref, context, String rutinId, String priodeId,
      DateTime startTime, DateTime endTime) async {
    var eddidPriode =
        await PriodeRequest().edditPriode(priodeId, startTime, endTime);
    print("i am from cont");

    eddidPriode.fold(
      (l) {
        // state = false;
        return Alert.errorAlertDialog(context, l);
      },
      (r) {
        //state = false;
        ref.refresh(allPriodeProvider(rutinId));
        Alert.showSnackBar(context, r.message);
        Navigator.pop(context);
      },
    );
  }
}
