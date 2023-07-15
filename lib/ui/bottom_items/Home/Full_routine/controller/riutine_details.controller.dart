//! ** Providers ****/

// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../models/class_details_model.dart';
import '../request/routine_api.dart';

final routineDetailsProvider = StateNotifierProvider.family<
        RoutineDetailsController, AsyncValue<NewClassDetailsModel>, String>(
    (ref, routineId) =>
        RoutineDetailsController(ref.read(routine_Req_provider), routineId));

//** RoutineDetailsController ****/
class RoutineDetailsController
    extends StateNotifier<AsyncValue<NewClassDetailsModel>> {
  final Routine_Req homeApi;
  final String routineId;

  RoutineDetailsController(this.homeApi, this.routineId)
      : super(const AsyncLoading()) {
    getStatus();
  }
  getStatus() async {
    try {
      final NewClassDetailsModel? res =
          await homeApi.routine_class_and_priode(routineId);

      if (res == null) {}

      if (!mounted) return;
      state = AsyncData(res!);
    } catch (error, stackTrace) {
      if (!mounted) return;
      print(error.toString());
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
