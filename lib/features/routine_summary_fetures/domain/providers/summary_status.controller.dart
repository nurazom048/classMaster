// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_constructors, avoid_print, use_build_context_synchronously

import 'package:classmate/features/routine_summary_fetures/domain/providers/summary_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:classmate/core/dialogs/alert_dialogs.dart';
import '../../../../core/models/message_model.dart';
import '../../../routine/data/models/check_status_model.dart';
import '../../data/datasources/summary_request.dart';
import '../../data/implements/routine_summary_imp.dart';

//! Providers
final summaryStatusProvider = StateNotifierProvider.family.autoDispose<
  SummaryCheckStatusController,
  AsyncValue<CheckStatusModel>,
  String
>((ref, summaryID) {
  return SummaryCheckStatusController(
    summaryID: summaryID,
    summaryRepo: ref.watch(summaryRepoProvider), // 🆕 Inject Repository
  );
});

//? Controllers
class SummaryCheckStatusController
    extends StateNotifier<AsyncValue<CheckStatusModel>> {
  final String summaryID;
  final ISummaryRepository summaryRepo; // 🆕

  SummaryCheckStatusController({
    required this.summaryID,
    required this.summaryRepo,
  }) : super(AsyncLoading()) {
    getStatus();
  }

  // Get the summary status
  Future<void> getStatus() async {
    try {
      if (!mounted) return;
      // 🆕 Fetch map from repository and parse it to CheckStatusModel
      final statusMap = await summaryRepo.getSummaryStatus(summaryID);
      CheckStatusModel data = CheckStatusModel.fromJson(statusMap);

      state = AsyncData(data);
    } catch (error, stackTrace) {
      if (!mounted) return;
      print(error.toString());
      state = AsyncError(error, stackTrace);
    }
  }

  // Save the summary
  void saveSummary(BuildContext context, String summaryID) async {
    try {
      // 🆕 Direct boolean response
      final bool isSaved = await summaryRepo.toggleSaveSummary(
        summaryId: summaryID,
        save: true,
      );

      if (!mounted) return;
      state = AsyncData(state.value!.copyWith(isSave: isSaved));
      Alert.showSnackBar(context, "Summary saved successfully!");
    } catch (error) {
      print(error);
      Alert.errorAlertDialog(context, error.toString());
    }
  }

  // Unsave the summary
  Future<void> unsavedSummary(
    BuildContext context, {
    required String summaryID,
    required bool condition,
  }) async {
    try {
      // 🆕 Direct boolean response
      final bool isSaved = await summaryRepo.toggleSaveSummary(
        summaryId: summaryID,
        save: condition,
      );

      if (!mounted) return;
      state = AsyncData(state.value!.copyWith(isSave: isSaved));
      Navigator.pop(context);
      Alert.showSnackBar(context, "Summary unsaved successfully!");
    } catch (error) {
      print(error);
      Navigator.pop(context);
      Alert.errorAlertDialog(context, error.toString());
    }
  }
}
