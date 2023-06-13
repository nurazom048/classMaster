// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:table/core/dialogs/alart_dialogs.dart';
import 'package:table/models/chack_status_model.dart';

import '../../../../../../models/message_model.dart';
import '../summary_request/summary_request.dart';

//! Providers
final summaryStatusProvider = StateNotifierProvider.family.autoDispose<
    SummaryChackStatusController,
    AsyncValue<CheckStatusModel>,
    String>((ref, summaryID) {
  return SummaryChackStatusController(
    summaryID: summaryID,
    summayReuest: ref.read(summaryReqProvider),
  );
});

//? Controllers

class SummaryChackStatusController
    extends StateNotifier<AsyncValue<CheckStatusModel>> {
  final String summaryID;
  final SummayReuest summayReuest;

  SummaryChackStatusController({
    required this.summaryID,
    required this.summayReuest,
  }) : super(AsyncLoading()) {
    getStatus();
  }

  // Get the summary status
  getStatus() async {
    try {
      if (!mounted) return;
      CheckStatusModel data = await summayReuest.chackStatus(summaryID);
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
      Either<Message, Message> res =
          await SummayReuest().saveSummary(summaryID, true);

      res.fold(
        (error) {
          print(error);
          return Alart.errorAlartDilog(context, error.message);
        },
        (r) {
          state = AsyncData(state.value!.copyWith(isSave: r.save));
          return Alart.showSnackBar(context, r.message);
        },
      );
    } catch (error) {
      print(error);
      // ignore: void_checks
      return Alart.errorAlartDilog(context, error.toString());
    }
  }

  // Unsave the summary
  Future<void> unsaveSummary(
    BuildContext context, {
    required String summaryID,
    required bool condition,
  }) async {
    try {
      Either<Message, Message> res =
          await SummayReuest().saveSummary(summaryID, condition);

      res.fold(
        (error) {
          print(error);
          Navigator.pop(context);
          return Alart.errorAlartDilog(context, error.message);
        },
        (r) {
          print('*************************************');
          print(r.save);
          state = AsyncData(state.value!.copyWith(isSave: r.save));
          Navigator.pop(context);
          return Alart.showSnackBar(context, r.message);
        },
      );
    } catch (error) {
      print(error);
      return Alart.errorAlartDilog(context, error.toString());
    }
  }
}
