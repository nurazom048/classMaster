// ignore_for_file: invalid_return_type_for_catch_error, prefer_typing_uninitialized_variables, avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:table/models/message_model.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/sunnary_section/models/all_summary_models.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/sunnary_section/summary_request/summary_request.dart';
import '../../../../../../core/dialogs/alart_dialogs.dart';

// providers
final sunnaryControllerProvider = StateNotifierProvider.autoDispose
    .family<SummaryController, AsyncValue<AllSummaryModel>, String>(
        (ref, classId) {
  return SummaryController(ref, classId, ref.watch(summaryReqProvider));
});

//
class SummaryController extends StateNotifier<AsyncValue<AllSummaryModel>> {
  SummayReuest summaryReq;
  Ref ref;
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
      state = AsyncValue.data(res);
    } catch (err, stack) {
      state = AsyncValue.error(err, stack);
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
