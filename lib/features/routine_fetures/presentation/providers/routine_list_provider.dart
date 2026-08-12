// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/dialogs/alert_dialogs.dart';
import '../../data/datasources/routine_req.dart';
import '../../data/implements/routine_imp.dart';
import '../../data/models/routine_model.dart';
import '../../data/models/routine_response_model.dart';

class RoutineListQuery {
  final String? type;
  final String? search;
  final String? username;

  const RoutineListQuery({this.type, this.search, this.username});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoutineListQuery &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          search == other.search &&
          username == other.username;

  @override
  int get hashCode => type.hashCode ^ search.hashCode ^ username.hashCode;
}

final routineListProvider = StateNotifierProvider.family<
    RoutineListNotifier,
    AsyncValue<RoutineResponse>,
    RoutineListQuery
>((ref, query) {
  return RoutineListNotifier(ref.read(routineReqProvider), query);
});

class RoutineListNotifier extends StateNotifier<AsyncValue<RoutineResponse>> {
  final RoutineRepositoryImp routineRepository;
  final RoutineListQuery query;

  RoutineListNotifier(this.routineRepository, this.query)
      : super(const AsyncLoading()) {
    fetchRoutines();
  }

  Future<void> fetchRoutines() async {
    try {
      final res = await routineRepository.listRoutines(
        type: query.type,
        search: query.search,
        username: query.username,
        page: 1,
      );
      if (!mounted) return;
      state = AsyncValue.data(res);
    } catch (e, stack) {
      if (mounted) {
        state = AsyncValue.error(e, stack);
      }
    }
  }

  Future<void> loadMore() async {
    final currentState = state.value;
    if (currentState == null) return;
    if (currentState.currentPage >= currentState.totalPages) return;

    try {
      final nextPage = currentState.currentPage + 1;
      final newData = await routineRepository.listRoutines(
        type: query.type,
        search: query.search,
        username: query.username,
        page: nextPage,
      );

      if (!mounted) return;

      final updatedRoutines = List<Routine>.from(currentState.routines)
        ..addAll(newData.routines);

      state = AsyncValue.data(
        currentState.copyWith(
          routines: updatedRoutines,
          currentPage: newData.currentPage,
          totalPages: newData.totalPages,
          totalCount: newData.totalCount,
        ),
      );
    } catch (e) {
      debugPrint("Failed to load more: $e");
    }
  }

  Future<void> deleteRoutine(String routineID, BuildContext context) async {
    try {
      final res = await routineRepository.deleteRoutineById(routineID);
      res.fold(
        (error) {
          if (context.mounted) Alert.showSnackBar(context, error.message);
        },
        (data) {
          if (!mounted) return;
          final currentState = state.value;
          if (currentState != null) {
            final updatedRoutines = List<Routine>.from(currentState.routines)
              ..removeWhere((r) => r.id == routineID);
            state = AsyncValue.data(currentState.copyWith(routines: updatedRoutines));
          }
          if (context.mounted) Alert.showSnackBar(context, data.message);
        },
      );
    } catch (e) {
      if (context.mounted) Alert.showSnackBar(context, e.toString());
    }
  }
}
