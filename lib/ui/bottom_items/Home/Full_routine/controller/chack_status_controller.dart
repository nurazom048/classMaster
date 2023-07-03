// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:table/core/dialogs/alert_dialogs.dart';
import 'package:table/models/chack_status_model.dart';
import 'package:table/ui/bottom_items/Home/Full_routine/request/member_request.dart';
import 'package:table/ui/bottom_items/Home/Full_routine/request/rutin_request.dart';

import '../../../../../models/message_model.dart';
import '../request/rutine_notification.dart';

//! providers
final chackStatusControllerProvider = StateNotifierProvider.autoDispose
    .family<ChackStatusController, AsyncValue<CheckStatusModel>, String>(
        (ref, rutinId) {
  return ChackStatusController(
    ref,
    rutinId,
    ref.read(FullRutinProvider),
    ref.read(memberRequestProvider),
    ref.read(notificationReqProvider),
  );
});

//? Controllers

class ChackStatusController
    extends StateNotifier<AsyncValue<CheckStatusModel>> {
  var ref;
  final String rutinId;
  final FullRutinrequest fullRutinReq;
  final memberRequest memberRequests;
  final RutineNotification rutineNotification;
  ChackStatusController(this.ref, this.rutinId, this.fullRutinReq,
      this.memberRequests, this.rutineNotification)
      : super(AsyncLoading()) {
    getStatus();
  }

  getStatus() async {
    try {
      // AsyncValue<CheckStatusModel> res =
      //     await ref.watch(chackStatusUser_provider(rutinId));

      final CheckStatusModel res = await fullRutinReq.chackStatus(rutinId);

      if (!mounted) return;
      state = AsyncData(res);

      // res.when(
      //     data: (data) {
      //       state = AsyncData(data);
      //     },
      //     error: (error, stackTrace) {
      //       print(error.toString());
      //       state = AsyncError(error, stackTrace);
      //     },
      //     loading: () {});
    } catch (error, stackTrace) {
      if (!mounted) return;

      print(error.toString());
      // state = throw Exception(error);
      state = AsyncValue.error(error, stackTrace);
    }
  }

  //

  // Define a method for saving or unsaving a rutin
  void saveUnsave(BuildContext context, condition) async {
    final result = await fullRutinReq.saveUnsaveRutinReq(rutinId, condition);
    print("c $rutinId $condition");

    result.fold(
      (errorMessage) => Alert.errorAlertDialog(context, errorMessage),
      (response) {
        state = AsyncData(state.value!.copyWith(isSave: response.save));

        Alert.showSnackBar(context, response.message);
      },
    );
  }

//***********  send join  *********** */
  void sendReqController(context) async {
    final result = await memberRequests.sendRequest(rutinId);

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
        await rutineNotification.notificationOff(rutinId);

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
    final result = await rutineNotification.notificationOn(rutinId);

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
      final res = await memberRequests.leaveRequest(rutinId);

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
