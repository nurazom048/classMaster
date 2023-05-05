// ignore_for_file: camel_case_types, unused_result, avoid_print

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/dialogs/alart_dialogs.dart';
import '../request/priode_request.dart';

//.. prvider...//
final priodeController = StateNotifierProvider.autoDispose(
    (ref) => priodeClassController(ref.watch(priodeRequestProvider)));

//
//...class....//
class priodeClassController extends StateNotifier<bool> {
  PriodeRequest priodereq;

  priodeClassController(this.priodereq) : super(false);

  //....deletePriode
  void deletePriode(WidgetRef ref, BuildContext context, String priodeId,
      String rutinId) async {
    var deleteRes = await PriodeRequest().deletePriode(priodeId);

    deleteRes.fold(
      (l) {
        state = false;
        return Alart.errorAlartDilog(context, l);
      },
      (r) {
        ref.refresh(allPriodeProvider(rutinId));
        state = false;

        Alart.showSnackBar(context, r.message);
      },
    );
  }

  //
  //....addPriode...//
  void addPriode(WidgetRef ref, context, String rutinId, DateTime StartTime,
      DateTime EndTime) async {
    var addRes = await PriodeRequest().addPriode(rutinId, StartTime, EndTime);
    print("i am from cont");

    addRes.fold(
      (l) {
        // state = false;
        return Alart.errorAlartDilog(context, l);
      },
      (r) {
        //state = false;
        ref.refresh(allPriodeProvider(rutinId));
        Alart.showSnackBar(context, r.message);
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
        return Alart.errorAlartDilog(context, l);
      },
      (r) {
        //state = false;
        ref.refresh(allPriodeProvider(rutinId));
        Alart.showSnackBar(context, r.message);
        Navigator.pop(context);
      },
    );
  }
}
