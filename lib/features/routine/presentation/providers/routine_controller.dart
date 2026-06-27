// ignore_for_file: unused_result
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classmate/core/dialogs/alert_dialogs.dart';

import '../../data/datasources/routine_req.dart';
import '../../data/implements/routine_imp.dart';
import 'routine_details.controller.dart';

final routineControllerProvider = StateNotifierProvider<RoutineController, bool?>(
  (ref) => RoutineController(ref.watch(routineReqProvider)),
);

class RoutineController extends StateNotifier<bool?> {
  final RoutineRepositoryImp routineRepository;

  RoutineController(this.routineRepository) : super(null);

  Future<void> deleteClass(String classId, String routineId, WidgetRef ref, BuildContext context) async {
    try {
      final value = await routineRepository.removeClass(classId);
      ref.refresh(routineDetailsProvider(routineId));
      if (context.mounted) {
        Alert.showSnackBar(context, value.message);
      }
    } catch (error) {
      if (context.mounted) {
        Alert.handleError(context, error);
      }
    }
  }
}
