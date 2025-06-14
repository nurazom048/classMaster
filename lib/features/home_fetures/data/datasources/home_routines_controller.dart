import 'package:classmate/features/home_fetures/data/datasources/home_req.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/dialogs/alert_dialogs.dart';
import '../../../../core/models/message_model.dart';
import '../models/home_routines_model.dart';

final homeRoutineControllerProvider = StateNotifierProvider.family<
  HomeRoutinesController,
  AsyncValue<RoutineHome>,
  String?
>((ref, userID) {
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
        final newData = await homeReq.homeRoutines(pages: page + 1);

        // Check if the new data's page number is greater than the current page number
        if (newData.currentPage > state.value!.currentPage) {
          int? totalPages = newData.totalPages;
          if (newData.currentPage <= totalPages) {
            // Add new routines to the existing list and update the page number
            List<HomeRoutine> homeRoutines =
                state.value!.homeRoutines..addAll(newData.homeRoutines);
            state = AsyncValue.data(
              state.value!.copyWith(
                homeRoutines: homeRoutines,
                currentPage: newData.currentPage,
              ),
            );
          }
        }
      }
    } catch (error, stackTrace) {
      if (!mounted) return;

      state = AsyncValue.error(error, stackTrace);
    }
  }

  //... Delete Routine...//

  void deleteRoutine(String routineID, context) async {
    try {
      Either<Message, Message> res = await homeReq.deleteRoutine(routineID);

      res.fold(
        (error) {
          return Alert.showSnackBar(context, error.message);
        },
        (data) {
          String? deletedRoutineID = data.routineID;

          //
          if (deletedRoutineID != null) {
            List<HomeRoutine> homeRoutines = state.value!.homeRoutines;
            homeRoutines.removeWhere(
              (routine) => routine.id == deletedRoutineID,
            );
            if (!mounted) return;
            state = AsyncValue.data(
              state.value!.copyWith(homeRoutines: homeRoutines),
            );
            return Alert.showSnackBar(context, data.message);
          }
        },
      );
    } catch (error, stackTrace) {
      if (!mounted) return;

      state = AsyncValue.error(error, stackTrace);
    }
  }
}
