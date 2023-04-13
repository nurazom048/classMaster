// ignore_for_file: camel_case_types, unused_result, avoid_print

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/server/rutinReq.dart';
import '../../../../../core/dialogs/Alart_dialogs.dart';
import '../request/priodeREquest/priode_request.dart';

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
    var deleteRes =
        await ref.read(priodeRequestProvider).deletePriode(priodeId);

    deleteRes.fold(
      (l) {
        state = false;
        return Alart.errorAlartDilog(context, l);
      },
      (r) {
        ref.refresh(rutins_detalis_provider(rutinId));
        state = false;

        Alart.showSnackBar(context, r.message);
      },
    );
  }

  //
  //....addPriode...//
  void addPriode(
      WidgetRef ref, Map<String, dynamic> item, String rutinId, context) async {
    var addRes =
        await ref.watch(priodeRequestProvider).addPriode(item, rutinId);
    print("i am from cont");

    addRes.fold(
      (l) {
        //    state = false;
        return Alart.errorAlartDilog(context, l);
      },
      (r) {
        ref.refresh(rutins_detalis_provider(rutinId));
        //state = false;

        Alart.showSnackBar(context, r.message);
      },
    );
  }
}
