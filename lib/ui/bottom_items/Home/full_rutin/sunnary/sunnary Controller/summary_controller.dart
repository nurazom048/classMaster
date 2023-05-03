// ignore_for_file: invalid_return_type_for_catch_error, prefer_typing_uninitialized_variables, avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:table/models/messageModel.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/sunnary/models/all_summary_models.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/sunnary/summary_request/summary_request.dart';
import '../../../../../../core/dialogs/Alart_dialogs.dart';

// providers
final sunnaryControllerProvider = StateNotifierProvider.autoDispose
    .family<SummaryController, AsyncValue<AllSummaryModel>, String>(
        (ref, classId) {
  return SummaryController(ref, classId, ref.watch(summaryReqProvider));
});

//
class SummaryController extends StateNotifier<AsyncValue<AllSummaryModel>> {
  SummayReuest summaryReq;
  var ref;
  String classId;
  SummaryController(this.ref, this.classId, this.summaryReq)
      : super(const AsyncLoading()) {
    getlist();
  }

  //
// get summary by class id
  getlist() async {
    try {
      AllSummaryModel res = await summaryReq.getSummaryList(classId);

      state = AsyncData(res);
    } catch (e) {
      print("vai ami error $e ");
      state = throw Exception(e);
    }
  }

  //.. add summary..
  void addSummarys(WidgetRef ref, context, text, imageLinks) async {
    //
    Either<Message, Message> res =
        await SummayReuest.addSummaryRequest(classId, text, imageLinks);

    //
    res.fold((error) {
      return Alart.errorAlartDilog(context, error.message);
    }, (r) {
      ref.refresh(sunnaryControllerProvider(classId));

      return Alart.showSnackBar(context, r.message);
    });
  }
}
