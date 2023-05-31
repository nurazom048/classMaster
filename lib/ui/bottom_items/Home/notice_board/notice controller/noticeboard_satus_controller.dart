// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/core/dialogs/alart_dialogs.dart';
import 'package:table/models/chack_status_model.dart';
import '../request/noticeboard_request.dart';

//! providers
final noticeBoardStatusProvider = StateNotifierProvider.family<
    NoticeBoardStatusProvider,
    AsyncValue<CheckStatusModel>,
    String>((ref, noticeboardId) {
  return NoticeBoardStatusProvider(
    ref,
    noticeboardId,
    ref.read(noticeboardRequestProvider),
  );
});

class NoticeBoardStatusProvider
    extends StateNotifier<AsyncValue<CheckStatusModel>> {
  final reference;
  final String noticeboardId;
  final NoticeboardRequest noticeboardRequest;

  NoticeBoardStatusProvider(
    this.reference,
    this.noticeboardId,
    this.noticeboardRequest,
  ) : super(AsyncLoading()) {
    getStatus();
  }

  Future<void> getStatus() async {
    try {
      final CheckStatusModel data =
          await noticeboardRequest.chackStatus(noticeboardId);
      state = AsyncData(data);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  //***********  join  *********** */

  Future<void> join(BuildContext context) async {
    final result = await noticeboardRequest.sendRequest(noticeboardId);

    result.fold(
      (errorMessage) => Alart.errorAlartDilog(context, errorMessage),
      (response) {
        state = AsyncData(
          state.value!.copyWith(activeStatus: "request_pending"),
        );

        Alart.showSnackBar(context, response.message);
      },
    );
  }
  //***********  notificationOff *********** */

  Future<void> notificationOff(BuildContext context) async {
    final result = await noticeboardRequest.notificationOff(noticeboardId);

    result.fold(
      (errorMessage) => Alart.errorAlartDilog(context, errorMessage),
      (response) {
        state = AsyncData(
          state.value!.copyWith(notificationOff: response.notificationOff),
        );

        Alart.showSnackBar(context, response.message);
      },
    );
  }

  //***********  notificationOn  *********** */
  Future<void> notificationOn(BuildContext context) async {
    final result = await noticeboardRequest.notificationOn(noticeboardId);

    result.fold(
      (errorMessage) => Alart.errorAlartDilog(context, errorMessage),
      (response) {
        state = AsyncData(
          state.value!.copyWith(notificationOff: response.notificationOff),
        );

        Alart.showSnackBar(context, response.message);
      },
    );
  }
  //***********  leaveMember *********** */

  Future<void> leaveMember(BuildContext context) async {
    final result = await noticeboardRequest.leaveMember(noticeboardId);

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
