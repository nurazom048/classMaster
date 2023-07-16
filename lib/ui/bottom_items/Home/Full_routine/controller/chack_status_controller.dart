// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_constructors, avoid_print

import 'package:classmate/ui/bottom_items/Home/Full_routine/controller/saveroutine.controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:classmate/core/dialogs/alert_dialogs.dart';
import 'package:classmate/models/check_status_model.dart';
import 'package:classmate/ui/bottom_items/Home/Full_routine/request/member_request.dart';
import 'package:classmate/ui/bottom_items/Home/Full_routine/request/routine_request.dart';

import '../../../../../models/message_model.dart';
import '../request/rutine_notification.dart';

//! providers
final checkStatusControllerProvider = StateNotifierProvider.autoDispose
    .family<CheckStatusController, AsyncValue<CheckStatusModel>, String>(
        (ref, routineId) {
  return CheckStatusController(
    ref,
    routineId,
    ref.read(fullRoutineProvider),
    ref.read(memberRequestProvider),
    ref.read(notificationReqProvider),
  );
});

//? Controllers

class CheckStatusController
    extends StateNotifier<AsyncValue<CheckStatusModel>> {
  var ref;
  final String routineId;
  final FullRoutineRequest fullRoutineRequest;
  final MemberRequest memberRequests;
  final RoutineNotification routineNotification;
  CheckStatusController(this.ref, this.routineId, this.fullRoutineRequest,
      this.memberRequests, this.routineNotification)
      : super(AsyncLoading()) {
    getStatus();
  }

  getStatus() async {
    try {
      final CheckStatusModel res =
          await fullRoutineRequest.chalkStatus(routineId);

      if (!mounted) return;
      state = AsyncData(res);
    } catch (error, stackTrace) {
      if (!mounted) return;

      print(error.toString());
      // state = throw Exception(error);
      state = AsyncValue.error(error, stackTrace);
    }
  }

  //

  // Define a method for saveUnsaved
  void saveUnsaved(BuildContext context, condition) async {
    final result =
        await fullRoutineRequest.saveUnsavedRoutineReq(routineId, condition);
    print("c $routineId $condition");

    result.fold(
      (errorMessage) => Alert.errorAlertDialog(context, errorMessage),
      (response) {
        state = AsyncData(state.value!.copyWith(isSave: response.save));

        ref.refresh(saveRoutineProvider);
        Alert.showSnackBar(context, response.message);
      },
    );
  }

//***********  send join  *********** */
  void sendReqController(context) async {
    final result = await memberRequests.sendRequest(routineId);

    result.fold(
      (errorMessage) => Alert.errorAlertDialog(context, errorMessage),
      (response) {
        state = AsyncData(
            state.value!.copyWith(activeStatus: response.activeStatus));

        Alert.showSnackBar(context, response.message);
      },
    );
  }
//

//***********  notificationOff  *********** */
  void notificationOff(context) async {
    final Either<String, Message> result =
        await routineNotification.notificationOff(routineId);

    result.fold(
      (errorMessage) => Alert.errorAlertDialog(context, errorMessage),
      (response) {
        state = AsyncData(
            state.value!.copyWith(notificationOn: response.notificationOn));

        Alert.showSnackBar(context, response.message);
      },
    );
  }

//***********  notificationOn  *********** */
  void notificationOn(context) async {
    final result = await routineNotification.notificationOn(routineId);

    result.fold(
      (errorMessage) => Alert.errorAlertDialog(context, errorMessage),
      (response) {
        state = AsyncData(
            state.value!.copyWith(notificationOn: response.notificationOn));

        Alert.showSnackBar(context, response.message);
      },
    );
  }

//
//***********  leaveMember *********** */
  leaveMember(context, WidgetRef ref) async {
    try {
      final res = await memberRequests.leaveRequest(routineId);

      res.fold((error) {
        return Alert.errorAlertDialog(context, error.message);
      }, (data) {
        state = AsyncData(state.value!.copyWith(activeStatus: "not_joined"));

        return Alert.showSnackBar(context, data.message);
      });
    } catch (e) {
      Alert.handleError(context, e);
    }
  }
}
