// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:table/core/dialogs/alert_dialogs.dart';
import 'package:table/models/rutins/weekday/weekday_list.dart';
import '../../../../../models/message_model.dart';
import '../request/weekday_req.dart';

//! providers
final weekayControllerStateProvider = StateNotifierProvider.autoDispose
    .family<WeeekDayControllerClass, AsyncValue<WeekdayList>, String>(
        (ref, classId) {
  return WeeekDayControllerClass(classId, ref.read(weekdayReqProvider));
});

// class
class WeeekDayControllerClass extends StateNotifier<AsyncValue<WeekdayList>> {
  String classId;

  WeekdaRequest weekdaRequest;
  WeeekDayControllerClass(this.classId, this.weekdaRequest)
      : super(const AsyncLoading()) {
    getStatus();
  }

  void getStatus() async {
    if (!mounted) return;
    try {
      final WeekdayList data = await WeekdaRequest.showWeekdayList(classId);

      state = AsyncValue.data(data);
    } catch (err, stack) {
      state = AsyncValue.error(err, stack);
    }
  }

  // add weekday

  addWeekday(
      context, WidgetRef ref, String num, String room, start, end) async {
    Either<Message, Message> res =
        await WeekdaRequest.addWeekday(classId, room, num, start, end);

    res.fold((error) {
      return Alert.errorAlertDialog(context, error.message);
    }, (data) {
      ref.refresh(weekayControllerStateProvider(classId));
      Alert.showSnackBar(context, data.message);
      Navigator.of(context).pop();
    });
  }

  //
  deleteWeekday(context, String id, String classId) async {
    Either<Message, WeekdayList> res =
        await WeekdaRequest.deletWeekday(id, classId);

    res.fold((error) {
      Alert.showSnackBar(context, error.message.toString());
    }, (data) {
      // state.value?.weekdays.addAll(data.weekdays);
      state = AsyncData(data);

      Alert.showSnackBar(context, data.message.toString());
    });
  }
}
