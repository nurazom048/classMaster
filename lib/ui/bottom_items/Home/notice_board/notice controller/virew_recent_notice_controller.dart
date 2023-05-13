import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/core/dialogs/alart_dialogs.dart';

import '../models/notice bord/recentNotice.dart';
import '../request/noticeboard_noticeRequest.dart';

//! Provider
final recentNoticeController = StateNotifierProvider.autoDispose<
    UploadedRutinsController, AsyncValue<RecentNotice>>((ref) {
  return UploadedRutinsController(ref.read(noticeReqProvider));
});

///
class UploadedRutinsController extends StateNotifier<AsyncValue<RecentNotice>> {
  NoticeRequest noticeRequest;
  UploadedRutinsController(this.noticeRequest) : super(const AsyncLoading()) {
    _init();
  }

  /// get all recent notice
  _init() async {
    try {
      final res = await noticeRequest.recentNotice();
      if (!mounted) return;

      state = AsyncData(res);
    } catch (err, stack) {
      if (!mounted) return;

      state = AsyncValue.error(err, stack);
    }
  }

// loade pore data
  void loadMore(page, context) async {
    try {
      final RecentNotice newData =
          await noticeRequest.recentNotice(page: page + 1);

      print(
          "total ${newData.totalPages} : giver page $page newcp ${newData.currentPage}   ");

      if (newData.currentPage != state.value?.currentPage) {
        List<Notice> notices = List.from(
            state.value!.notices); // Create a new list with existing notices
        notices.addAll(newData.notices); // Add new notices to the list
        state = AsyncData(state.value!
            .copyWith(notices: notices, currentPage: newData.currentPage));
      }
    } catch (error) {
      Alart.handleError(context, error);
    }
  }
}
