//! ** Providers ****/

// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/routine_api.dart';
import '../../data/models/class_details_model.dart';

final routineDetailsProvider = StateNotifierProvider.family<
        RoutineDetailsController, AsyncValue<AllClassesResponse>, String>(
    (ref, routineId) =>
        RoutineDetailsController(ref.read(routine_Req_provider), routineId));

//** RoutineDetailsController ****/
class RoutineDetailsController
    extends StateNotifier<AsyncValue<AllClassesResponse>> {
  final Routine_Req homeApi;
  final String routineId;

  RoutineDetailsController(this.homeApi, this.routineId)
      : super(const AsyncLoading()) {
    getStatus();
  }
  getStatus() async {
    try {
      final AllClassesResponse? res =
          await homeApi.all_class_in_routine(routineId);

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
