import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Home/notice_board/models/list_noticeboard.dart';
import '../search_request/search_requests.dart';

// Create a state notifier provider named SearchNoticeBoardController
final searchNoticeBoardController = StateNotifierProvider.family<
        SearchNoticeBoardController, AsyncValue<ListOfNoticeBoard>, String>(
    (ref, searchString) => SearchNoticeBoardController(ref, searchString));

// Define the SearchNoticeBoardController class
class SearchNoticeBoardController
    extends StateNotifier<AsyncValue<ListOfNoticeBoard>> {
  final Ref ref;
  final String searchString;
  SearchNoticeBoardController(this.ref, this.searchString)
      : super(const AsyncLoading()) {
    getItems();
  }

  Future<void> getItems() async {
    try {
      final ListOfNoticeBoard data = await ref
          .read(searchControllersProvider)
          .searchNoticeBord(searchString);
      if (!mounted) return;
      state = AsyncValue.data(data);
    } catch (err, stack) {
      state = AsyncValue.error(err, stack);
    }
  }
}

//
loadeMore() {}
