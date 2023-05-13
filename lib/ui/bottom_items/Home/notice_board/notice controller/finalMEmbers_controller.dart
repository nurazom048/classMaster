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

  Ref ref;
  String noticeBoardId;
  FinalNoticeBoardMembersController(this.ref, this.noticeBoardId,
      this.noticeBoardRequest, this.noticeboardMembersRequest)
      : super(const AsyncLoading()) {
    getMembersList();
  }

  void dispose() {
    // Clean up any resources here
    super.dispose();
  }

  Future<void> getMembersList() async {
    if (!mounted) return;
    try {
      final AllMembersModel data =
          await noticeBoardRequest.seeAllMembers(noticeBoardId);

      state = AsyncValue.data(data);
    } catch (err, stack) {
      state = AsyncValue.error(err, stack);
    }
  }
}
