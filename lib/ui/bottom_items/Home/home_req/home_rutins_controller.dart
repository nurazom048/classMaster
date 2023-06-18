//_________________________
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/home_req/home_req.dart';

import '../models/home_rutines_model.dart';

final homeRutinControllerProvider = StateNotifierProvider.autoDispose
    .family<HomeRutinsController, AsyncValue<RoutineHome>, String?>(
        (ref, userID) {
  return HomeRutinsController(ref.read(home_req_provider), userID);
});

class HomeRutinsController extends StateNotifier<AsyncValue<RoutineHome>> {
  HomeReq homeReq;
  final String? userID;
  HomeRutinsController(this.homeReq, this.userID)
      : super(const AsyncLoading()) {
    _init();
  }

  _init() async {
    if (!mounted) return;
    try {
      final res = await homeReq.homeRutines(pages: 1, userID: userID);
      state = AsyncData(res);
    } catch (error, stackTrace) {
      if (!mounted) return;
      state = AsyncValue.error(error, stackTrace);
    }
  }

// loade pore data
  // void loadMore(page) async {
  //   try {
  //     final newData = await homeReq.homeRutines(pages: page + 1);

  //     // ignore: avoid_print
  //     print(
  //         "total ${newData.totalPages} : giver page $page newcp ${newData.currentPage}   ");
  //     // Check if the new data's page number is greater than the current page number
  //     if (newData.currentPage! > state.value!.currentPage!) {
  //       int? totalPages = newData.totalPages ?? 1;
  //       if (newData.currentPage! <= totalPages) {
  //         // add new rutins to list and change the page number
  //         List<Routine> rutins = state.value!.rutins..addAll(newData.rutins);
  //         state = AsyncData(state.value!
  //             .copyWith(rutins: rutins, currentPage: newData.currentPage));
  //       }
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //     state = throw Exception(e);
  //   }
  // }

  void loadMore(page) async {
    print('call fore loader more');
    try {
      final newData = await homeReq.homeRutines(pages: page + 1);

      // Check if the new data's page number is greater than the current page number
      if (newData.currentPage > state.value!.currentPage) {
        int? totalPages = newData.totalPages;
        if (newData.currentPage <= totalPages) {
          // Add new routines to the existing list and update the page number
          List<HomeRoutine> homeRoutines = state.value!.homeRoutines
            ..addAll(newData.homeRoutines);
          state = AsyncData(state.value!.copyWith(
              homeRoutines: homeRoutines, currentPage: newData.currentPage));
        }
      }
    } catch (e) {
      state = throw Exception(e);
    }
  }
}
