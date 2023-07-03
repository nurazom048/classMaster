// Create a state notifier provider named SearchAccountController
// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../../../models/search_account.dart';
import '../../Collection Fetures/models/account_models.dart';
import '../search_request/search_requests.dart';

final searchAccountController = StateNotifierProvider.family<
    SearchAccountController, AsyncValue<AccountsResponse>, String>(
  (ref, searchString) => SearchAccountController(
    ref,
    searchString,
    ref.read(searchControllersProvider),
  ),
);

// Define the SearchAccountController class
class SearchAccountController
    extends StateNotifier<AsyncValue<AccountsResponse>> {
  final Ref ref;
  final String searchString;
  final SearchRequests search;
  SearchAccountController(this.ref, this.searchString, this.search)
      : super(const AsyncLoading()) {
    getItems();
  }

  Future<void> getItems() async {
    try {
      final AccountsResponse data = await search.searchAccount(searchString);
      if (!mounted) return;
      state = AsyncValue.data(data);
    } catch (err, stack) {
      if (!mounted) return;

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

        final AccountsResponse newData =
            await search.searchAccount(searchString, page: page + 1);
        print('newData');
        print('newData length: ${newData.accounts?.length}');

        // Check if the new data's page number is greater than the current page number
        if (newData.currentPage! > state.value!.currentPage!) {
          int? totalPages = newData.totalPages;
          if (newData.currentPage! <= totalPages!) {
            // Add new accounts to the existing list and update the page number
            List<AccountModels>? newAccountResult = [
              ...(state.value!.accounts ?? []),
              ...(newData.accounts ?? []),
            ];
            state = AsyncData(state.value!.copyWith(
              accounts: newAccountResult,
              currentPage: newData.currentPage,
            ));
          }
        }
      }
    } catch (error) {
      Get.snackbar(
        'error',
        '$error',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
