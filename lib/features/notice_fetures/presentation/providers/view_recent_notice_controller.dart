// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classmate/core/dialogs/alert_dialogs.dart';

import '../../data/datasources/notice_request.dart';
import '../../data/models/recent_notice_model.dart';

//! Provider
final recentNoticeController = StateNotifierProvider.family<
    UploadedRutinsController,
    AsyncValue<RecentNotice>,
    String?>((ref, academyID) {
  return UploadedRutinsController(ref.read(noticeReqProvider), academyID);
});

///
class UploadedRutinsController extends StateNotifier<AsyncValue<RecentNotice>> {
  NoticeRequest noticeRequest;
  String? academyID;
  UploadedRutinsController(this.noticeRequest, this.academyID)
      : super(const AsyncLoading()) {
    _init();
  }

  /// get all recent notice
  _init() async {
    try {
      final res = await noticeRequest.recentNotice(academyID: academyID);
      if (!mounted) return;

      state = AsyncData(res);
    } catch (err, stack) {
      if (!mounted) return;

      state = AsyncValue.error(err, stack);
    }
  }

// loaded more data
  void loadMore(page, context) async {
    try {
      final RecentNotice newData =
          await noticeRequest.recentNotice(page: page + 1);

      // print(
      //     "total ${newData.totalPages} : giver page $page new current page  ${newData.currentPage}   ");

      if (newData.currentPage != state.value?.currentPage) {
        List<Notice> notices = List.from(
            state.value!.notices); // Create a new list with existing notices
        notices.addAll(newData.notices); // Add new notices to the list
        state = AsyncData(state.value!
            .copyWith(notices: notices, currentPage: newData.currentPage));
      }
    } catch (error) {
      Alert.handleError(context, error);
    }
  }

  // Delete Notice
  void deleteNotice(context, WidgetRef ref, {required String noticeId}) async {
    final response = await noticeRequest.deleteNotice(noticeId: noticeId);

    response.fold((error) {
      return Alert.errorAlertDialog(context, error.message);
    }, (data) {
      // ignore: unused_result
      ref.refresh(recentNoticeController(academyID));

      return Alert.showSnackBar(context, data.message);
    });
  }
}
