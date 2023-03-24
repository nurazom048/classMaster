// ignore_for_file: invalid_return_type_for_catch_error

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/models/summaryModels.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/sunnary/summary_request/summary_request.dart';
import 'package:table/widgets/Alart.dart';
// providers

final sunnaryControllerProvider =
    StateNotifierProvider<SummaryController, Summary?>((ref) {
  return SummaryController(ref.watch(summaryReqProvider));
});

//

//
//
class SummaryController extends StateNotifier<Summary?> {
  SummayReuest summaryReq;
  SummaryController(this.summaryReq) : super(null);

  //.. add summary..
  void addSummary(WidgetRef ref, classId, summatText, context) async {
    var res = summaryReq.addSummary(classId, summatText);

    res.catchError((error) => Alart.handleError(context, error));
    res.then((value) {
      state = value;
      Navigator.pop(context);
      return Alart.showSnackBar(context, "added");
    });
  }
}
