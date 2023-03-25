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
class priodeClassController extends StateNotifier<bool?> {
  priodeRequest priodereq;

  priodeClassController(this.priodereq) : super(null);

  //....deletePriode
  void deletePriode(
      WidgetRef ref, BuildContext context, String priodeId, String rutinId) {
    var deleteRes = ref.watch(deletePriodeProvider(priodeId));

    deleteRes.when(
      data: (data) {
        ref.refresh(rutins_detalis_provider(rutinId));
        return Alart.showSnackBar(context, data?.message);
      },
      error: (error, stackTrace) => Alart.handleError(context, error),
      loading: () {},
    );
  }

  //
  //....addPriode...//
  void addPriode(WidgetRef ref, BuildContext context, DateTime startTime,
      DateTime endTime, String rutinId) async {
    var addRes = await ref
        .watch(priodeRequestProvider)
        .addPriode(startTime, endTime, rutinId);
    print("i am from cont");

    addRes.fold(
      (l) {
        state = false;
        return Alart.errorAlartDilog(context, l);
      },
      (r) {
        state = false;

        Alart.showSnackBar(context, r.message);
      },
    );
  }
}
