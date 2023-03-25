// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/core/dialogs/Alart_dialogs.dart';
import 'package:table/models/chackStatusModel.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/controller/Rutin_controller.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/request/Rutin_request/rutin_request.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/request/member_request.dart';
import '../../../../../widgets/Alart.dart';

//! providers
final chackStatusControllerProvider = StateNotifierProvider.autoDispose
    .family<ChackStatusController, AsyncValue<CheckStatusModel>, String>(
        (ref, rutinId) {
  return ChackStatusController(ref, rutinId, ref.read(FullRutinProvider),
      ref.read(memberRequestProvider));
});

//? Controllers

class ChackStatusController
    extends StateNotifier<AsyncValue<CheckStatusModel>> {
  var ref;
  String rutinId;
  FullRutinrequest fullRutinReq;
  memberRequest memberRequests;
  ChackStatusController(
      this.ref, this.rutinId, this.fullRutinReq, this.memberRequests)
      : super(AsyncLoading()) {
    getStatus();
  }

  getStatus() async {
    try {
      AsyncValue<CheckStatusModel> res =
          await ref.watch(chackStatusUser_provider(rutinId));

      res.when(
          data: (data) {
            state = AsyncData(data);
          },
          error: (error, stackTrace) {
            print(error.toString());
            state = AsyncError(error, stackTrace);
          },
          loading: () {});
    } catch (e) {
      print(e.toString());
      state = throw Exception(e);
    }
  }

  //

  // Define a method for saving or unsaving a rutin
  void saveUnsave(BuildContext context, condition) async {
    final result = await fullRutinReq.saveUnsaveRutinReq(rutinId, condition);
    print("c $rutinId $condition");

    result.fold(
      (errorMessage) => Alart.errorAlartDilog(context, errorMessage),
      (response) {
        state = AsyncData(state.value!.copyWith(isSave: response.save));

        Alart.showSnackBar(context, response.message);
      },
    );
  }

//***********  send join  *********** */
  void sendReqController(context) async {
    final result = await memberRequests.sendRequest(rutinId);

    result.fold(
      (errorMessage) => Alart.errorAlartDilog(context, errorMessage),
      (response) {
        state = AsyncData(
            state.value!.copyWith(activeStatus: response.activeStatus));

        Alart.showSnackBar(context, response.message);
      },
    );
  }

//
//***********  leaveMember *********** */
  leaveMember(context) async {
    try {
      final res = await memberRequests.leaveRequest(rutinId);
      state = AsyncData(state.value!.copyWith(activeStatus: "not_joined"));

      Alart.showSnackBar(context, res.message);
    } catch (e) {
      Alart.handleError(context, e);
    }
  }
}
