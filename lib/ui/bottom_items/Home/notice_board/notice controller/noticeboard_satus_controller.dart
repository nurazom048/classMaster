// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_constructors, avoid_print, unnecessary_overrides

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/core/dialogs/alart_dialogs.dart';
import 'package:table/models/chack_status_model.dart';
import '../request/noticeboard_request.dart';

//! providers
final noticeBoardStatusProvider = StateNotifierProvider.autoDispose
    .family<NoticeBoardStatusProvider, AsyncValue<CheckStatusModel>, String>(
        (ref, academyID) {
  return NoticeBoardStatusProvider(
      academyID, ref.read(noticeboardRequestProvider));
});

class NoticeBoardStatusProvider
    extends StateNotifier<AsyncValue<CheckStatusModel>> {
  final String academyID;
  final NoticeboardRequest noticeboardRequest;

  NoticeBoardStatusProvider(
    this.academyID,
    this.noticeboardRequest,
  ) : super(AsyncLoading()) {
    getStatus();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getStatus() async {
    try {
      final CheckStatusModel data =
          await noticeboardRequest.chackStatus(academyID);

      if (mounted) {
        state = AsyncData(data);
      }
    } catch (error, stackTrace) {
      print("error: $error");
      if (mounted) {
        state = AsyncValue.error(error, stackTrace);
      }
    }
  }
  //***********  join  *********** */

  Future<void> join(BuildContext context) async {
    final result = await noticeboardRequest.sendRequest(academyID);

    result.fold(
      (errorMessage) => Alart.errorAlartDilog(context, errorMessage),
      (response) {
        state = AsyncData(
          state.value!.copyWith(activeStatus: "joined"),
        );

        Alart.showSnackBar(context, response.message);
      },
    );
  }
  //***********  notificationOff *********** */

  Future<void> notificationOff(BuildContext context) async {
    final result = await noticeboardRequest.notificationOff(academyID);

    result.fold(
      (errorMessage) => Alart.errorAlartDilog(context, errorMessage),
      (response) {
        state = AsyncData(
          state.value!.copyWith(notificationOn: false),
        );

        Alart.showSnackBar(context, response.message);
      },
    );
  }

  //***********  notificationOn  *********** */
  Future<void> notificationOn(BuildContext context) async {
    final result = await noticeboardRequest.notificationOn(academyID);

    result.fold(
      (errorMessage) => Alart.errorAlartDilog(context, errorMessage),
      (response) {
        state = AsyncData(
          state.value!.copyWith(notificationOn: true),
        );

        Alart.showSnackBar(context, response.message);
      },
    );
  }
  //***********  leaveMember *********** */

  Future<void> leaveMember(BuildContext context) async {
    final result = await noticeboardRequest.leaveMember(academyID);

    result.fold(
      (error) => Alart.showSnackBar(context, error.message),
      (response) {
        state = AsyncData(
          state.value!.copyWith(activeStatus: "not_joined"),
        );

        Alart.showSnackBar(context, response.message);
      },
    );
  }
}
