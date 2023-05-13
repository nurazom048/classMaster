// ignore_for_file: prefer_typing_uninitialized_variables, invalid_return_type_for_catch_error, prefer_const_constructors, unused_element, unused_result

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/dialogs/alart_dialogs.dart';
import '../models/join_request_model.dart';
import '../request/noticeboard_joine_request.dart';
import 'finalMEmbers_controller.dart';

//! Provider
final noticeboardJoinRequestController = StateNotifierProvider.autoDispose
    .family<NoticeBoardJoinClass, AsyncValue<JoinRequestsResponseModel>,
        String>((ref, noticeBoardId) {
  return NoticeBoardJoinClass(
      ref, noticeBoardId, ref.read(noticeBoardMemberRequestProvider));
});
//----------------------------------------------------------------//

class NoticeBoardJoinClass
    extends StateNotifier<AsyncValue<JoinRequestsResponseModel>> {
  NoticeBaordJoinRequest noticeboardJoinReq;

  var ref;
  String noticeBoardId;
  NoticeBoardJoinClass(this.ref, this.noticeBoardId, this.noticeboardJoinReq)
      : super(AsyncLoading()) {
    getAllRequestList();
  }

  void dispose() {
    // Clean up any resources here
    super.dispose();
  }

  void getAllRequestList() async {
    try {
      final res = await noticeboardJoinReq.joinedNoticeList(noticeBoardId);

      if (mounted) return;
      state = AsyncData(res);
    } catch (err, stack) {
      if (mounted) return;
      state = AsyncValue.error(err, stack);
    }
  }
//... Accept request.....//

  void acceptRequest(userid, context, WidgetRef ref) async {
    final res = noticeboardJoinReq.acceptRequest(noticeBoardId, userid);

    res.catchError((error) => Alart.handleError(context, error));
    res.then((value) {
      ref.refresh(finalMemberConollerList(noticeBoardId));

      ref.refresh(noticeboardJoinRequestController(noticeBoardId));
      return Alart.showSnackBar(context, value.message);
    });
  }
//... Accept request.....//

  void rejectMembers(userid, context, WidgetRef ref) async {
    final res = noticeboardJoinReq.rejectRequest(noticeBoardId, userid);

    res.catchError((error) => Alart.handleError(context, error));
    res.then((value) {
      // ref.refresh(finalMemberConollerList(noticeBoardId));

      ref.refresh(noticeboardJoinRequestController(noticeBoardId));
      return Alart.showSnackBar(context, value.message);
    });
  }
// //... rejectMembers request.....//
// loade more
}
