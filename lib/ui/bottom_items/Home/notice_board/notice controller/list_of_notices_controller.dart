import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/notices models/list_ofz_notices.dart';
import '../request/notice_board_request.dart';

//! provider
final listofNoticesProvider = StateNotifierProvider.family<ListOfNotoces,
    AsyncValue<ListOfNoticesModel>, String>((ref, noticeBoardId) {
  return ListOfNotoces(
    ref.read(noticeBoardRequestProvider),
    noticeBoardId,
  );
});

//

class ListOfNotoces extends StateNotifier<AsyncValue<ListOfNoticesModel>> {
  final NoticeBoardRequest noticeBoardRequest;
  final String noticeBoardId;
  ListOfNotoces(this.noticeBoardRequest, this.noticeBoardId)
      : super(const AsyncLoading()) {
    getStatus();
  }

  getStatus() async {
    try {
      final res =
          await noticeBoardRequest.getNoticesByNoticeBoardId(noticeBoardId);
      state = AsyncData(res);
    } catch (e) {
      state = throw Future.error(e);
    }
  }

  //
}
