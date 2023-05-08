import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/notice_board/models/join_request_model.dart';

import '../request/join_request.dart';

// provider

final noticeBoardJoinRequestControllerProvider = StateNotifierProvider.family<
    NoticeBoardJoinRequestControllerClass,
    AsyncValue<JoinRequestsResponseModel>,
    String>((ref, noticeBoardId) {
  return NoticeBoardJoinRequestControllerClass(
      ref: ref,
      noticeBoardId: noticeBoardId,
      noticeBoardJoinRequest: ref.read(noticeBoardJoinRequestProvider));
});

//

// class
class NoticeBoardJoinRequestControllerClass
    extends StateNotifier<AsyncValue<JoinRequestsResponseModel>> {
  // ignore: prefer_typing_uninitialized_variables
  final ref;
  final String noticeBoardId;
  final NoticeBoardJoinRequest noticeBoardJoinRequest;

  //
  NoticeBoardJoinRequestControllerClass(
      {required this.ref,
      required this.noticeBoardId,
      required this.noticeBoardJoinRequest})
      : super(const AsyncLoading()) {
    getStatus();
  }

  getStatus() async {
    try {
      final res = await noticeBoardJoinRequest.joinedNoticeList(noticeBoardId);
      state = AsyncData(res);
      // res.when(data: (data) {
      //   state = AsyncData(data);
      // }, error: (error, stackTrace) {
      //   print(error);
      //   state = AsyncError(error, stackTrace);
      // }, loading: () {
      //   state = const AsyncLoading();
      // });
    } catch (e) {
      state = throw Exception(e);
    }
  }

//..................  loade more ..................................///
}
