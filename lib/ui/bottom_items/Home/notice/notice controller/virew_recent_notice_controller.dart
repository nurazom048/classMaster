import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:table/ui/bottom_items/Home/notice/models/notice%20bord/recentNotice.dart';
import 'package:table/ui/bottom_items/Home/notice/notice%20controller/noticeRequest.dart';

//! Provider
final recentNoticeController = StateNotifierProvider.autoDispose<
    UploadedRutinsController, AsyncValue<Either<String, RecentNotice>>>((ref) {
  return UploadedRutinsController(ref.read(noticeReqProvider));
});

///
class UploadedRutinsController
    extends StateNotifier<AsyncValue<Either<String, RecentNotice>>> {
  NoticeRequest noticeRequest;
  UploadedRutinsController(this.noticeRequest) : super(const AsyncLoading()) {
    _init();
  }

  /// get all recent notice
  _init() async {
    try {
      final res = await noticeRequest.recentNotice();
      state = AsyncData(res);
    } catch (e) {
      state = throw Exception(e);
    }
  }

// // loade pore data
//   void loadMore(page) async {
//     try {
//       final newData = await noticeRequest.uplodedRutins(pages: page + 1);

//       // ignore: avoid_print
//       print(
//           "total ${newData.totalPages} : giver page ${page} newcp ${newData.currentPage}   ");
//       // Check if the new data's page number is greater than the current page number
//       if (newData.currentPage! > state.value!.currentPage!) {
//         int? totalPages = newData.totalPages ?? 1;
//         if (newData.currentPage! <= totalPages) {
//           // add new rutins to list and change the page number
//           List<Routine> rutins = state.value!.rutins..addAll(newData.rutins);
//           state = AsyncData(state.value!
//               .copyWith(rutins: rutins, currentPage: newData.currentPage));
//         }
//       }
//     } catch (e) {
//       print(e.toString());
//       state = throw Exception(e);
//     }
  //}
}
