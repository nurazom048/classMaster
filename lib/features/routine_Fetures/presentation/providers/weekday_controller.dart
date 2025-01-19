// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:classmate/features/routine_Fetures/data/models/weekday_list.dart';
import '../../../../core/export_core.dart';
import '../../data/datasources/weekday_req.dart';

//! providers
final weekdayControllerStateProvider = StateNotifierProvider.autoDispose
    .family<WeekDayControllerClass, AsyncValue<WeekdayList>, String>(
        (ref, classId) {
  return WeekDayControllerClass(classId, ref.read(weekdayReqProvider));
});

// class
class WeekDayControllerClass extends StateNotifier<AsyncValue<WeekdayList>> {
  String classId;

  WeekdayRequest weekdayRequest;
  WeekDayControllerClass(this.classId, this.weekdayRequest)
      : super(const AsyncLoading()) {
    getStatus();
  }

  void getStatus() async {
    if (!mounted) return;
    try {
      final WeekdayList data = await WeekdayRequest.showWeekdayList(classId);

      state = AsyncValue.data(data);
    } catch (err, stack) {
      state = AsyncValue.error(err, stack);
    }
  }

//******************************************************************************** */
//-------------------------- Add Weekday ------------------------------------------//
//******************************************************************************** */
  addWeekday(context, WidgetRef ref, String num, String room,
      DateTime startTime, DateTime endTime) async {
    Either<Message, Message> res =
        await WeekdayRequest.addWeekday(classId, room, num, startTime, endTime);

    res.fold((error) {
      return Alert.errorAlertDialog(context, error.message);
    }, (data) {
      ref.refresh(weekdayControllerStateProvider(classId));
      Alert.showSnackBar(context, data.message);
      Navigator.of(context).pop();
    });
  }

//******************************************************************************** */
//-------------------------- Delete Weekday ------------------------------------------//
//******************************************************************************** */
  deleteWeekday(context, String id, String classId) async {
    Either<Message, WeekdayList> res =
        await WeekdayRequest.deleteWeekday(id, classId);

    res.fold((error) {
      Alert.showSnackBar(context, error.message.toString());
    }, (data) {
      // state.value?.weekdays.addAll(data.weekdays);
      state = AsyncData(data);

      Alert.showSnackBar(context, data.message.toString());
    });
  }
}
