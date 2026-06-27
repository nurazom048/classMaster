// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:classmate/features/routine/data/models/weekday_list_models.dart';
import '../../../../core/export_core.dart';
import '../../data/datasources/routine_req.dart';
import '../../data/implements/routine_imp.dart';

final weekdayControllerStateProvider = StateNotifierProvider.autoDispose
    .family<WeekDayControllerClass, AsyncValue<WeekdayList>, String>((
      ref,
      classId,
    ) {
      return WeekDayControllerClass(classId, ref.read(routineReqProvider));
    });

class WeekDayControllerClass extends StateNotifier<AsyncValue<WeekdayList>> {
  final String classId;
  final RoutineRepositoryImp routineRepository;

  WeekDayControllerClass(this.classId, this.routineRepository)
    : super(const AsyncLoading()) {
    getStatus();
  }

  void getStatus() async {
    if (!mounted) return;
    try {
      final WeekdayList data = await routineRepository.getAllWeekdaysInClass(classId);
      state = AsyncValue.data(data);
    } catch (err, stack) {
      state = AsyncValue.error(err, stack);
    }
  }

  Future<void> addWeekday(
    BuildContext context,
    WidgetRef ref,
    String num,
    String room,
    DateTime startTime,
    DateTime endTime,
  ) async {
    Either<Message, Message> res = await routineRepository.addWeekday(
      classID: classId,
      room: room,
      day: num,
      startTime: startTime,
      endTime: endTime,
    );

    res.fold(
      (error) {
        Alert.errorAlertDialog(context, error.message);
      },
      (data) {
        ref.refresh(weekdayControllerStateProvider(classId));
        Alert.showSnackBar(context, data.message);
        Navigator.of(context).pop();
      },
    );
  }

  Future<void> deleteWeekday(BuildContext context, String id, String classId) async {
    Either<Message, WeekdayList> res = await routineRepository.deleteWeekdayById(
      id,
      classID: classId,
    );

    res.fold(
      (error) {
        Alert.showSnackBar(context, error.message.toString());
      },
      (data) {
        state = AsyncData(data);
        Alert.showSnackBar(context, data.message.toString());
      },
    );
  }
}
