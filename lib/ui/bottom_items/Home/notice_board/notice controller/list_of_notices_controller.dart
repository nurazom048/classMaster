import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/dialogs/alart_dialogs.dart';
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
    if (!mounted) return;

    try {
      final res =
          await noticeBoardRequest.getNoticesByNoticeBoardId(noticeBoardId);

      state = AsyncData(res);
    } catch (err, stack) {
      state = AsyncValue.error(err, stack);
    }
  }

  void loadMore(int page, BuildContext context) async {
    try {
      final ListOfNoticesModel newData = await noticeBoardRequest
          .getNoticesByNoticeBoardId(noticeBoardId, page: page + 1);

      print(
          "total ${newData.totalPages} : given page $page new cp ${newData.currentPage}");

      if (newData.currentPage != state.value?.currentPage) {
        List<Notice> notices = List.from(state.value!.notices);
        notices.addAll(newData.notices);
        state = AsyncData(state.value!.copyWith(
          notices: notices,
          currentPage: newData.currentPage,
        ));
      }
    } catch (error) {
      Alart.handleError(context, error);
    }
  }
}
