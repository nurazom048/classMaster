import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:table/models/rutins/weekday/weekday_list.dart';

import '../../../../../models/chackStatusModel.dart';
import '../../../../../models/messageModel.dart';
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
      : super(AsyncLoading()) {
    getStatus();
  }

  void getStatus() async {
    Either<Message, WeekdayList> res =
        await WeekdaRequest.showWeekdayList(classId);

    res.fold((error) {
      print(error);
    }, (data) {
      state = AsyncData(data);
    });
  }
}
