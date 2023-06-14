// Create a state notifier provider named SearchAccountController
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/search_account.dart';
import '../search_request/search_requests.dart';

final searchAccountController = StateNotifierProvider.family<
    SearchAccountController,
    AsyncValue<AccountsResponse>,
    String>((ref, searchString) => SearchAccountController(ref, searchString));

// Define the SearchAccountController class
class SearchAccountController
    extends StateNotifier<AsyncValue<AccountsResponse>> {
  final Ref ref;
  final String searchString;
  SearchAccountController(this.ref, this.searchString)
      : super(const AsyncLoading()) {
    getItems();
  }

  Future<void> getItems() async {
    try {
      final AccountsResponse data =
          await ref.read(searchControllersProvider).searchAccount(searchString);
      if (!mounted) return;
      state = AsyncValue.data(data);
    } catch (err, stack) {
      if (!mounted) return;

      state = AsyncValue.error(err, stack);
    }
  }

  //
  loadeMore() {}
}
