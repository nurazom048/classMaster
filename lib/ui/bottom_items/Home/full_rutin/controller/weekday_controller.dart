import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:table/core/dialogs/alart_dialogs.dart';
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
    Either<Message, WeekdayList> res =
        await WeekdaRequest.showWeekdayList(classId);

    res.fold((error) {}, (data) {
      state = AsyncData(data);
    });
  }

  // add weekday

  addWeekday(context, WidgetRef ref, num, String room, start, end) async {
    Either<Message, Message> res =
        await WeekdaRequest.addWeekday(classId, room, num, start, end);

    res.fold((error) {
      Alart.showSnackBar(context, error.toString());
    }, (data) {
      Navigator.of(context).pop();

      ref.refresh(weekayControllerStateProvider(classId));
      Alart.showSnackBar(context, data.message.toString());
    });
  }

  //
  deleteWeekday(context, String id) async {
    Either<Message, WeekdayList> res = await WeekdaRequest.deletWeekday(id);
    print(res);

    res.fold((error) {
      Alart.showSnackBar(context, error.message.toString());
    }, (data) {
      // state.value?.weekdays.addAll(data.weekdays);
      state = AsyncData(data);

      Alart.showSnackBar(context, data.message.toString());
    });
  }
}
