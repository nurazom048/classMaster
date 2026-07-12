// ignore_for_file: invalid_return_type_for_catch_error, prefer_typing_uninitialized_variables, avoid_print, unused_result

import 'package:classmate/features/routine_summary_fetures/data/implements/routine_summary_imp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:classmate/features/routine_summary_fetures/data/models/all_summary_models.dart';
import 'package:classmate/features/routine_summary_fetures/data/datasources/summary_request.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/dialogs/alert_dialogs.dart';
import '../../../../core/models/message_model.dart';
import '../../presentation/screens/add_summary_screen.dart';

// providers
// 🆕 Repository Provider
final summaryRepoProvider = Provider<ISummaryRepository>(
  (ref) => SummaryRepository(),
);

// Providers
final summaryControllerProvider = StateNotifierProvider.autoDispose
    .family<SummaryController, AsyncValue<AllSummaryModel>, String?>((
      ref,
      classId,
    ) {
      // 🆕 Injecting ISummaryRepository instead of SummaryRequest
      return SummaryController(ref, classId, ref.watch(summaryRepoProvider));
    });

class SummaryController extends StateNotifier<AsyncValue<AllSummaryModel>> {
  final ISummaryRepository summaryRepo; // 🆕
  final Ref ref;
  final String? classId;

  SummaryController(this.ref, this.classId, this.summaryRepo)
    : super(const AsyncLoading()) {
    getList();
  }

  // Get summary by class id
  Future<void> getList() async {
    try {
      AllSummaryModel res = await summaryRepo.getSummaries(classId: classId);
      if (!mounted) return;

      state = AsyncValue.data(res);
    } catch (err, stack) {
      if (!mounted) return;

      state = AsyncValue.error(err, stack);
    }
  }

  // Load more summaries
  Future<void> loadMore(int currentPage, int totalPages) async {
    if (currentPage >= totalPages) {
      print('reached to end');
      return;
    }

    print("current: $currentPage total: $totalPages");
    try {
      AllSummaryModel newData = await summaryRepo.getSummaries(
        classId: classId,
        page: currentPage + 1,
      );

      if (!mounted) return;
      print("new current: ${newData.currentPage} total: ${newData.totalPages}");

      if (newData.currentPage != newData.totalCount ||
          newData.currentPage > newData.totalCount) {
        state = AsyncValue.data(
          state.value!.copyWith(
            summaries: [
              ...state.value!.summaries,
              ...newData.summaries.where((newSummary) {
                // Filter out any summaries with duplicate IDs
                return !state.value!.summaries.any(
                  (existingSummary) => existingSummary.id == newSummary.id,
                );
              }),
            ],
            currentPage: newData.currentPage,
            totalPages: newData.totalPages,
          ),
        );
      }
    } catch (e, stackTrace) {
      print(e.toString());
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Add summary
  void addSummary(
    WidgetRef ref,
    BuildContext context, {
    required String classId,
    required String routineId, // UI compatibility kept, but backend infers it
    required String message,
    required List<XFile> imageLinks,
    required bool checkedType, // UI compatibility kept
  }) async {
    ref.read(loaderProvider.notifier).update((state) => true);

    try {
      // 🆕 Using Repository
      await summaryRepo.addSummary(
        classId: classId,
        message: message,
        files: imageLinks,
      );

      ref.refresh(summaryControllerProvider(classId));
      Navigator.of(context).pop();
      Alert.showSnackBar(context, "Summary created successfully!");
    } catch (error) {
      Alert.errorAlertDialog(context, error.toString());
    } finally {
      ref.read(loaderProvider.notifier).update((state) => false);
    }
  }

  // DELETE summary
  void deleteSummary(BuildContext context, String summaryID) async {
    print('fromController: deleting summary');

    try {
      // 🆕 Using Repository
      await summaryRepo.removeSummary(summaryID);

      ref.refresh(summaryControllerProvider(classId));
      Navigator.pop(context);
      Alert.showSnackBar(context, "Summary deleted successfully!");
    } catch (error) {
      print(error);
      Alert.errorAlertDialog(context, error.toString());
    }
  }

  // Vote in a poll
  void voteSummaryPoll(BuildContext context, String summaryID, int optionIndex) async {
    try {
      await summaryRepo.votePoll(summaryId: summaryID, optionIndex: optionIndex);
      if (!mounted) return;
      ref.refresh(summaryControllerProvider(classId));
    } catch (error) {
      if (!mounted) return;
      Alert.errorAlertDialog(context, error.toString());
    }
  }
}
