// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:table/core/dialogs/alart_dialogs.dart';
import 'package:table/models/chack_status_model.dart';
import '../../../../../models/message_model.dart';
import '../request/notice_board_request.dart';
import '../request/noticeboard_member.dart';
import '../request/notification_request.dart';

//! providers
final noticeBoardStatusProvider = StateNotifierProvider.family<
    NoticeBoaardStatusProvider,
    AsyncValue<CheckStatusModel>,
    String>((ref, noticeBoardId) {
  return NoticeBoaardStatusProvider(
      ref, noticeBoardId, ref.read(noticeBoardRequestProvider),
      noticeboardMembersRequest: ref.read(noticeboardMeberRequestProvider),
      notificanRequest: ref.read(noticeboardNotificationReqProvider));
});

//? Controllers

class NoticeBoaardStatusProvider
    extends StateNotifier<AsyncValue<CheckStatusModel>> {
  var ref;
  String noticeBoardId;
  NoticeBoardRequest noticeBoardRequest;
  final NoticeBoardNotificationRequest notificanRequest;

  NoticeboardMembersRequest noticeboardMembersRequest;
  NoticeBoaardStatusProvider(
      this.ref, this.noticeBoardId, this.noticeBoardRequest,
      {required this.noticeboardMembersRequest, required this.notificanRequest})
      : super(AsyncLoading()) {
    getStatus();
  }

  getStatus() async {
    try {
      AsyncValue<CheckStatusModel> res =
          await ref.watch(noticeBoardchackStatusUser_provider(noticeBoardId));

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

//***********  send join  *********** */
  void sendReqController(context) async {
    final result = await noticeBoardRequest.sendRequest(noticeBoardId);

    result.fold(
      (errorMessage) => Alart.errorAlartDilog(context, errorMessage),
      (response) {
        state =
            AsyncData(state.value!.copyWith(activeStatus: "request_pending"));

        Alart.showSnackBar(context, response.message);
      },
    );
  }

//
  //***********  notificationOff  *********** */
  void notificationOff(context) async {
    final Either<String, Message> result =
        await notificanRequest.notificationOff(noticeBoardId);

    result.fold(
      (errorMessage) => Alart.errorAlartDilog(context, errorMessage),
      (response) {
        state = AsyncData(
            state.value!.copyWith(notificationOff: response.notificationOff));

        Alart.showSnackBar(context, response.message);
      },
    );
  }

//***********  notificationOn  *********** */
  void notificationOn(context) async {
    final result = await notificanRequest.notificationOn(noticeBoardId);

    result.fold(
      (errorMessage) => Alart.errorAlartDilog(context, errorMessage),
      (response) {
        state = AsyncData(
            state.value!.copyWith(notificationOff: response.notificationOff));

        Alart.showSnackBar(context, response.message);
      },
    );
  }
//...leaveMember ... leave meber

  void leaveMember(BuildContext context) async {
    Either<Message, Message> res =
        await noticeboardMembersRequest.leaveMember(noticeBoardId);
    res.fold((error) => Alart.showSnackBar(context, error.message), (r) {
      state = AsyncData(state.value!.copyWith(activeStatus: "not_joined"));

      return Alart.showSnackBar(context, r.message);
    });
  }
// //
// //***********  leaveMember *********** */
//   leaveMember(context) async {
//     try {
//       final res = await memberRequests.leaveRequest(rutinId);
//       state = AsyncData(state.value!.copyWith(activeStatus: "not_joined"));

//       Alart.showSnackBar(context, res.message);
//     } catch (e) {
//       Alart.handleError(context, e);
//     }
//   }

//
}
