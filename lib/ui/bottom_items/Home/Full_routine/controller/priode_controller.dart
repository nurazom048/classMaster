// ignore_for_file: unused_result

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/dialogs/alert_dialogs.dart';
import '../../../../../models/priode/all_priode_models.dart';
import '../request/priode_request.dart';

//.. provider...//
final priodeController = StateNotifierProvider.family<PriodeClassController,
    AsyncValue<AllPriodeList>, String>((ref, routineID) {
  return PriodeClassController(
    priodeReq: ref.watch(priodeRequestProvider),
    routineID: routineID,
  );
});

//
//...class....//
class PriodeClassController extends StateNotifier<AsyncValue<AllPriodeList>> {
  final PriodeRequest priodeReq;
  final String routineID;

  PriodeClassController({
    required this.priodeReq,
    required this.routineID,
  }) : super(const AsyncLoading()) {
    getPriode();
  }
  void getPriode() async {
    final allPriode = await PriodeRequest().allPriode(routineID);

    allPriode.fold(
      (l) {
        state = AsyncValue.error(l, StackTrace.current);
      },
      (r) {
        state = AsyncValue.data(r);
      },
    );
  }

  //*********************   deletePriode  *************************//
  void deletePriode(
    WidgetRef ref,
    BuildContext context,
    String priodeId,
  ) async {
    Navigator.pop(context);

    var deleteRes = await PriodeRequest().deletePriode(priodeId);

    deleteRes.fold(
      (l) {
        //  state = AsyncLoading();

        return Alert.errorAlertDialog(context, l);
      },
      (r) {
        ref.refresh(priodeController(routineID));
        // state = false;

        Alert.showSnackBar(context, r.message);
      },
    );
  }

  //*********************   addPriode  *************************//

  void addPriode(
      WidgetRef ref, context, DateTime startTime, DateTime endTime) async {
    var addRes = await PriodeRequest().addPriode(routineID, startTime, endTime);

    addRes.fold(
      (l) {
        // state = false;
        return Alert.errorAlertDialog(context, l);
      },
      (r) {
        //state = false;
        ref.refresh(priodeController(routineID));
        Alert.showSnackBar(context, r.message);
        Navigator.pop(context);
      },
    );
  }

  //****************** Eddit priode  *************************//

  void edditPriode(WidgetRef ref, context, String priodeId, DateTime startTime,
      DateTime endTime) async {
    // state = true;

    var edditPriode =
        await PriodeRequest().edditPriode(priodeId, startTime, endTime);

    edditPriode.fold(
      (l) {
        // state = false;
        return Alert.errorAlertDialog(context, l);
      },
      (r) {
        // state = false;
        ref.refresh(priodeController(routineID));
        Alert.showSnackBar(context, r.message);
        Navigator.pop(context);
      },
    );
  }
}
