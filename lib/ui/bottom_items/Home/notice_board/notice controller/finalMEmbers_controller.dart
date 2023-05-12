// ignore_for_file: prefer_typing_uninitialized_variables, invalid_return_type_for_catch_error, prefer_const_constructors, unused_element, unused_result, use_build_context_synchronously

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/all_members_model.dart';
import '../request/notice_board_request.dart';
import '../request/noticeboard_member.dart';

//! Provider
final finalMemberConollerList = StateNotifierProvider.autoDispose.family<
    FinalNoticeBoardMembersController,
    AsyncValue<AllMembersModel>,
    String>((ref, classId) {
  return FinalNoticeBoardMembersController(
      ref,
      classId,
      ref.read(noticeBoardRequestProvider),
      ref.read(noticeboardMeberRequestProvider));
});
//----------------------------------------------------------------//

class FinalNoticeBoardMembersController
    extends StateNotifier<AsyncValue<AllMembersModel>> {
  NoticeBoardRequest noticeBoardRequest;
  NoticeboardMembersRequest noticeboardMembersRequest;

  var ref;
  String noticeBoardId;
  FinalNoticeBoardMembersController(this.ref, this.noticeBoardId,
      this.noticeBoardRequest, this.noticeboardMembersRequest)
      : super(AsyncLoading()) {
    getMembersList();
  }

  void dispose() {
    // Clean up any resources here
    super.dispose();
  }

  void getMembersList() async {
    try {
      final res = await noticeBoardRequest.seeAllMembers(noticeBoardId);

      if (mounted) {
        state = AsyncData(res);
      }
    } catch (e) {
      print(e.toString());
      if (mounted) {
        state = throw Exception(e);
      }
    }
  }
}
