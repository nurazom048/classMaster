//_________________________
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/home_req/home_req.dart';

import '../../../../models/rutins/list_of_save_rutin.dart';
import '../../../../models/rutins/rutins.dart';

final uploadedRutinsControllerProvider = StateNotifierProvider.autoDispose<
    UploadedRutinsController, AsyncValue<ListOfUploadedRutins>>((ref) {
  return UploadedRutinsController(ref.read(home_req_provider));
});

class UploadedRutinsController
    extends StateNotifier<AsyncValue<ListOfUploadedRutins>> {
  HomeReq homeReq;
  UploadedRutinsController(this.homeReq) : super(const AsyncLoading()) {
    _init();
  }

  _init() async {
    try {
      final res = await homeReq.uplodedRutins(pages: 1);
      state = AsyncData(res);
    } catch (e) {
      if (!mounted) return;
      state = throw Exception(e);
    }
  }

// loade pore data
  void loadMore(page) async {
    try {
      final newData = await homeReq.uplodedRutins(pages: page + 1);

      // ignore: avoid_print
      print(
          "total ${newData.totalPages} : giver page ${page} newcp ${newData.currentPage}   ");
      // Check if the new data's page number is greater than the current page number
      if (newData.currentPage! > state.value!.currentPage!) {
        int? totalPages = newData.totalPages ?? 1;
        if (newData.currentPage! <= totalPages) {
          // add new rutins to list and change the page number
          List<Routine> rutins = state.value!.rutins..addAll(newData.rutins);
          state = AsyncData(state.value!
              .copyWith(rutins: rutins, currentPage: newData.currentPage));
        }
      }
    } catch (e) {
      print(e.toString());
      state = throw Exception(e);
    }
  }
}
