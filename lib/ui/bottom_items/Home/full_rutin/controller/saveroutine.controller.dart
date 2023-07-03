import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../models/rutins/saveRutine.dart';
import '../../home_req/home_req.dart';
import 'package:table/models/rutins/search_rutin.dart';

final saveroutineProvider = StateNotifierProvider<SaveRoutineController,
    AsyncValue<SaveRutineResponse>>((ref) {
  return SaveRoutineController(ref.read(home_req_provider));
});

class SaveRoutineController
    extends StateNotifier<AsyncValue<SaveRutineResponse>> {
  HomeReq homeReq;
  SaveRoutineController(this.homeReq) : super(const AsyncLoading()) {
    _init();
  }

  _init() async {
    if (!mounted) return;
    try {
      final res = await homeReq.savedRutins(pages: 1);
      if (!mounted) return; // Check if the controller is still mounted
      state = AsyncData(res);
    } catch (error, stackTrace) {
      if (!mounted) return;
      state = AsyncValue.error(error, stackTrace);
    }
  }

// Loader More
  void loadMore(page) async {
    try {
      if (page == state.value!.totalPages) {
      } else {
        print('call fore loader more ${page} ${state.value!.totalPages}');

        final SaveRutineResponse newData =
            await homeReq.savedRutins(pages: page + 1);

        // Check if the new data's page number is greater than the current page number
        if (newData.currentPage > state.value!.currentPage) {
          int? totalPages = newData.totalPages;
          if (newData.currentPage <= totalPages) {
            // Add new routines to the existing list and update the page number
            List<Routine> routines = state.value!.savedRoutines
              ..addAll(newData.savedRoutines);
            state = AsyncData(state.value!.copyWith(
                savedRoutines: routines, currentPage: newData.currentPage));
          }
        }
      }
    } catch (e) {
      state = throw Exception(e);
    }
  }
}