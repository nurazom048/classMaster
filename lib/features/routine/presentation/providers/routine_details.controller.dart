import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/routine_req.dart';
import '../../data/implements/routine_imp.dart';
import '../../data/models/class_details_model.dart';

final routineDetailsProvider = StateNotifierProvider.family<
    RoutineDetailsController, AsyncValue<AllClassesResponse>, String>(
  (ref, routineId) => RoutineDetailsController(
    ref.read(routineReqProvider),
    routineId,
  ),
);

class RoutineDetailsController extends StateNotifier<AsyncValue<AllClassesResponse>> {
  final RoutineRepositoryImp routineRepository;
  final String routineId;

  RoutineDetailsController(this.routineRepository, this.routineId)
      : super(const AsyncLoading()) {
    getStatus();
  }

  getStatus() async {
    try {
      final AllClassesResponse res = await routineRepository.getAllClasses(routineId);
      if (!mounted) return;
      state = AsyncData(res);
    } catch (error, stackTrace) {
      if (!mounted) return;
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
