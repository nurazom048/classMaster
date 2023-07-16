import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:classmate/ui/bottom_items/Home/home_req/home_req.dart';

import '../../../../core/dialogs/alert_dialogs.dart';
import '../../../../models/message_model.dart';
import '../models/home_routines_model.dart';

final homeRoutineControllerProvider = StateNotifierProvider.family<
    HomeRoutinesController, AsyncValue<RoutineHome>, String?>((ref, userID) {
  return HomeRoutinesController(ref.read(home_req_provider), userID);
});

class HomeRoutinesController extends StateNotifier<AsyncValue<RoutineHome>> {
  HomeReq homeReq;
  final String? userID;
  HomeRoutinesController(this.homeReq, this.userID)
      : super(const AsyncLoading()) {
    _init();
  }

  _init() async {
    if (!mounted) return;
    try {
      final res = await homeReq.homeRoutines(pages: 1, userID: userID);
      if (!mounted) return; // Check if the controller is still mounted
      state = AsyncValue.data(res);
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
        // print('call fore loader more $page ${state.value!.totalPages}');

        final newData = await homeReq.homeRoutines(pages: page + 1);

        // Check if the new data's page number is greater than the current page number
        if (newData.currentPage > state.value!.currentPage) {
          int? totalPages = newData.totalPages;
          if (newData.currentPage <= totalPages) {
            // Add new routines to the existing list and update the page number
            List<HomeRoutine> homeRoutines = state.value!.homeRoutines
              ..addAll(newData.homeRoutines);
            state = AsyncValue.data(state.value!.copyWith(
                homeRoutines: homeRoutines, currentPage: newData.currentPage));
          }
        }
      }
    } catch (error, stackTrace) {
      if (!mounted) return;

      state = AsyncValue.error(error, stackTrace);
    }
  }

  // DELETED routine
  //... Delete Rutin...//

  void deleteRutin(String routineID, context) async {
    try {
      Either<Message, Message> res = await homeReq.deleteRutin(routineID);

      res.fold((error) {
        return Alert.showSnackBar(context, error.message);
      }, (data) {
        String? deletedRoutineID = data.routineID;

        //
        if (deletedRoutineID != null) {
          List<HomeRoutine> homeRoutines = state.value!.homeRoutines;
          homeRoutines.removeWhere(
              (routine) => routine.rutineId.id == deletedRoutineID);
          if (!mounted) return;
          state = AsyncValue.data(
              state.value!.copyWith(homeRoutines: homeRoutines));
          return Alert.showSnackBar(context, data.message);
        }
      });
    } catch (error, stackTrace) {
      if (!mounted) return;

      state = AsyncValue.error(error, stackTrace);
    }
  }
}
