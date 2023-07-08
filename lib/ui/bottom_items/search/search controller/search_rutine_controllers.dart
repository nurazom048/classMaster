// Create a state notifier provider named SearchRutineController
// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../../../models/Routine/search_rutin.dart';
import '../search_request/search_requests.dart';

final searchRutineController = StateNotifierProvider.family<
        SearchRutineController, AsyncValue<RutinQuarry>, String>(
    (ref, searchString) => SearchRutineController(
          ref,
          searchString,
          ref.read(searchControllersProvider),
        ));

// Define the SearchRutineController class
class SearchRutineController extends StateNotifier<AsyncValue<RutinQuarry>> {
  final Ref ref;
  final String searchString;
  final SearchRequests search;

  SearchRutineController(this.ref, this.searchString, this.search)
      : super(const AsyncLoading()) {
    getItems();
  }

  Future<void> getItems() async {
    try {
      final RutinQuarry data = await search.searchRoutine(searchString);
      if (!mounted) return;
      state = AsyncValue.data(data);
    } catch (err, stack) {
      state = AsyncValue.error(err, stack);
    }
  }

  //
// Loader More
  void loadMore(int page) async {
    try {
      if (page == state.value!.totalPages) {
        // Handle case when it's the last page
      } else {
        print('Call for loading more data: $page / ${state.value!.totalPages}');

        final RutinQuarry newData =
            await search.searchRoutine(searchString, page: page + 1);
        print('newData');
        print('newData length: ${newData.routines.length}');

        // Check if the new data's page number is greater than the current page number
        if (newData.currentPage > state.value!.currentPage) {
          int? totalPages = newData.totalPages;
          if (newData.currentPage <= totalPages) {
            // Add new routines to the existing list and update the page number
            List<Routine> newRoutines = [
              ...(state.value!.routines),
              ...(newData.routines),
            ];
            state = AsyncData(state.value!.copyWith(
              routines: newRoutines,
              currentPage: newData.currentPage,
            ));
          }
        }
      }
    } catch (error, stack) {
      Get.snackbar('error', '$error');

      state = AsyncValue.error(error, stack);
    }
  }
}
