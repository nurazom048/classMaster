// Create a state notifier provider named SearchRutineController
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/rutins/search_rutin.dart';
import '../search_request/search_requests.dart';

final searchRutineController = StateNotifierProvider.family<
    SearchRutineController,
    AsyncValue<RutinQuarry>,
    String>((ref, searchString) => SearchRutineController(ref, searchString));

// Define the SearchRutineController class
class SearchRutineController extends StateNotifier<AsyncValue<RutinQuarry>> {
  final Ref ref;
  final String searchString;
  SearchRutineController(this.ref, this.searchString)
      : super(const AsyncLoading()) {
    getItems();
  }

  Future<void> getItems() async {
    try {
      final RutinQuarry data =
          await ref.read(searchControllersProvider).searchRoutine(searchString);
      if (!mounted) return;
      state = AsyncValue.data(data);
    } catch (err, stack) {
      state = AsyncValue.error(err, stack);
    }
  }

  //
  loadeMore() {}
}
