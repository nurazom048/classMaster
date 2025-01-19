// ignore_for_file: invalid_return_type_for_catch_error, prefer_typing_uninitialized_variables, avoid_print, unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:classmate/features/routine_summary_fetures/data/models/all_summary_models.dart';
import 'package:classmate/features/routine_summary_fetures/data/datasources/summary_request.dart';
import '../../../../core/dialogs/alert_dialogs.dart';
import '../../../../core/models/message_model.dart';
import '../screens/add_summary.dart';

// providers
final summaryControllerProvider = StateNotifierProvider.autoDispose
    .family<SummaryController, AsyncValue<AllSummaryModel>, String?>(
        (ref, classId) {
  return SummaryController(ref, classId, ref.watch(summaryReqProvider));
});

class SummaryController extends StateNotifier<AsyncValue<AllSummaryModel>> {
  SummaryRequest summaryReq;
  Ref ref;
  String? classId;
  SummaryController(this.ref, this.classId, this.summaryReq)
      : super(const AsyncLoading()) {
    getList();
  }

// get summary by class id
  getList() async {
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
  void addSummary(
    WidgetRef ref,
    context, {
    required String classId,
    required String routineId,
    required String message,
    required List<String> imageLinks,
    required bool checkedType,
  }) async {
    ref.watch(loaderProvider.notifier).update((state) => true);
    //
    Either<Message, Message> res = await SummaryRequest.addSummaryRequest(
      classId: classId,
      routineId: routineId,
      message: message,
      imageLinks: imageLinks,
      checkedType: checkedType,
    );
    ref.watch(loaderProvider.notifier).update((state) => false);

    //
    res.fold((error) {
      return Alert.errorAlertDialog(context, error.message);
    }, (r) {
      ref.refresh(summaryControllerProvider(classId));

      Navigator.of(context).pop();
      return Alert.showSnackBar(context, r.message);
    });
  }

  // DELETE summary
  void deleteSummary(context, summaryID) async {
    print('fromController');
    //
    Either<Message, Message> res =
        await SummaryRequest.deleteSummary(summaryID);

    //
    if (!mounted) {}

    res.fold((error) {
      print(error);
      return Alert.errorAlertDialog(context, error.message);
    }, (r) {
      ref.refresh(summaryControllerProvider(classId));
      Navigator.pop(context);
      return Alert.showSnackBar(context, r.message);
    });
  }
}
