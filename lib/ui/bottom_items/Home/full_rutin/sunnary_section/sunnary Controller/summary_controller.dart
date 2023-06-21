// ignore_for_file: invalid_return_type_for_catch_error, prefer_typing_uninitialized_variables, avoid_print, unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:table/models/message_model.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/sunnary_section/models/all_summary_models.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/sunnary_section/summary_request/summary_request.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/sunnary_section/summat_screens/add_summary.dart';
import '../../../../../../core/dialogs/alart_dialogs.dart';

// providers
final sunnaryControllerProvider = StateNotifierProvider.autoDispose
    .family<SummaryController, AsyncValue<AllSummaryModel>, String?>(
        (ref, classId) {
  return SummaryController(ref, classId, ref.watch(summaryReqProvider));
});

class SummaryController extends StateNotifier<AsyncValue<AllSummaryModel>> {
  SummayReuest summaryReq;
  Ref ref;
  String? classId;
  SummaryController(this.ref, this.classId, this.summaryReq)
      : super(const AsyncLoading()) {
    getlist();
  }

// get summary by class id
  getlist() async {
    try {
      AllSummaryModel res = await summaryReq.getSummaryList(classId);
      if (!mounted) return;

      state = AsyncValue.data(res);
    } catch (err, stack) {
      if (!mounted) return;

      state = AsyncValue.error(err, stack);
    }
  }

// Load more summaries
  Future<void> loadMore(int currentPage, int totalPages) async {
    if (currentPage == totalPages) {
      print('r kisu nai vai');
    } else if (currentPage < totalPages) {
      print("current: $currentPage total: $totalPages");
      try {
        AllSummaryModel newData =
            await summaryReq.getSummaryList(classId, pages: currentPage + 1);
        if (!mounted) return;
        print(
            "new current: ${newData.currentPage} total: ${newData.totalPages}");

        if (newData.currentPage != newData.totalCount ||
            newData.currentPage > newData.totalCount) {
          state = AsyncValue.data(state.value!.copyWith(
            summaries: [
              ...state.value!.summaries,
              ...newData.summaries.where((newSummary) {
                // Filter out any summaries with duplicate IDs
                return !state.value!.summaries.any(
                  (existingSummary) => existingSummary.id == newSummary.id,
                );
              }).toList(),
            ],
            currentPage: newData.currentPage,
            totalPages: newData.totalPages,
          ));
          // state = AsyncValue.data(state.value!.copyWith(
          //     summaries: [...state.value!.summaries, ...newData.summaries],
          //     currentPage: newData.currentPage,
          //     totalPages: newData.totalPages));
        }
      } catch (e, stackTrace) {
        print(e.toString());
        state = AsyncValue.error(e, stackTrace);
      }
    }
  }

  //.. add summary..
  void addSummarys(WidgetRef ref, context, text, imageLinks) async {
    ref.watch(loderProvider.notifier).update((state) => true);
    //
    Either<Message, Message> res =
        await SummayReuest.addSummaryRequest(classId!, text, imageLinks);
    ref.watch(loderProvider.notifier).update((state) => false);

    //
    res.fold((error) {
      return Alart.errorAlartDilog(context, error.message);
    }, (r) {
      ref.refresh(sunnaryControllerProvider(classId));
      Navigator.of(context).pop();
      return Alart.showSnackBar(context, r.message);
    });
  }

  // DELETE summary
  void deleteSummarys(context, summaryID) async {
    print('fromController');
    //
    Either<Message, Message> res = await SummayReuest.deleteSummay(summaryID);

    //
    if (!mounted) {}

    res.fold((error) {
      print(error);
      return Alart.errorAlartDilog(context, error.message);
    }, (r) {
      ref.refresh(sunnaryControllerProvider(classId));
      Navigator.pop(context);
      return Alart.showSnackBar(context, r.message);
    });
  }
}
