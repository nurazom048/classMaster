import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/notice_fetures/presentation/providers/view_recent_notice_controller.dart';
import '../../../../features/notice_fetures/data/models/recent_notice_model.dart';
import '../screens/search_page.dart' show searchStringProvider;

/// A Riverpod provider that filters the list of notices dynamically based on the current search query.
/// It automatically invalidates/disposes when not in use.
final searchNoticeProvider = Provider.autoDispose<AsyncValue<List<Notice>>>((ref) {
  // Watch search query from SearchPage
  final searchText = ref.watch(searchStringProvider).toLowerCase();
  
  // Watch recent notices provider (academyID = null for all notices)
  final recentNoticesAsync = ref.watch(recentNoticeController(null));

  return recentNoticesAsync.when(
    data: (recentNotice) {
      if (searchText.isEmpty) {
        return AsyncValue.data(recentNotice.notices);
      }
      
      // Filter notices client-side for absolute responsiveness
      final filtered = recentNotice.notices.where((notice) {
        final title = notice.title.toLowerCase();
        final description = notice.description?.toLowerCase() ?? '';
        return title.contains(searchText) || description.contains(searchText);
      }).toList();
      
      return AsyncValue.data(filtered);
    },
    error: (err, stack) => AsyncValue.error(err, stack),
    loading: () => const AsyncValue.loading(),
  );
});
