// ignore_for_file: invalid_return_type_for_catch_error, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/models/summaryModels.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/sunnary/summary_request/summary_request.dart';
import '../../../../../../core/dialogs/Alart_dialogs.dart';

// providers

final sunnaryControllerProvider = StateNotifierProvider.autoDispose
    .family<SummaryController, AsyncValue<SummayModels>, String>(
        (ref, classId) {
  return SummaryController(ref, classId, ref.watch(summaryReqProvider));
});

//

//
//
class SummaryController extends StateNotifier<AsyncValue<SummayModels>> {
  SummayReuest summaryReq;
  var ref;
  String classId;
  SummaryController(this.ref, this.classId, this.summaryReq)
      : super(AsyncLoading()) {
    getlist();
  }

  getlist() async {
    try {
      final res = await ref.watch(getSumarisProvider(classId));

      print("vai ami controller ${res}");
      state = res;
    } catch (e) {
      print("vai ami error $e ");
      state = throw Exception(e);
    }
  }

  //.. add summary..
  // void addSummary(WidgetRef ref, classId, summatText, context) async {
  // //  var res = summaryReq.addSummary(classId, summatText);

  //   res.catchError((error) => Alart.handleError(context, error));
  //   res.then((value) {
  //     state = AsyncData(state.value!.copyWith(
  //       summaries: [...state.value!.summaries, value],
  //     ));
  //     Navigator.pop(context);
  //     return Alart.showSnackBar(context, "added");
  //   });
  // }
}
