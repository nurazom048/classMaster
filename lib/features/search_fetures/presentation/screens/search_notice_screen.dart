import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/component/loaders.dart';
import '../../../../core/dialogs/alert_dialogs.dart';
import '../../../../core/widgets/error/error.widget.dart';
import '../../../../route/app_router.dart';
import '../../../notice_fetures/presentation/widgets/static_widgets/modern_reusable_notice_card_widget.dart';
import '../../../notice_fetures/presentation/screens/view_notice_screen.dart';
import '../providers/search_notice_controller.dart';

/// A screen widget that shows the filtered list of notices matching the search term.
class SearchNoticeScreen extends ConsumerWidget {
  const SearchNoticeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchNoticesAsync = ref.watch(searchNoticeProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: searchNoticesAsync.when(
        data: (notices) {
          if (notices.isEmpty) {
            return const Center(
              child: Text(
                "No notices found matching your search.",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.only(bottom: 100, left: 12, right: 12, top: 12),
            itemCount: notices.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final notice = notices[index];
              return PremiumNoticeCard(
                notice: notice,
                academyID: null,
                onLongPress: () {},
                onTap: () {
                  // Navigate to notice details page using router
                  context.push(
                    '/notice/${notice.id}',
                    extra: ViewNoticeExtraData(
                      id: notice.id,
                      notice: notice,
                      accountModel: notice.account,
                    ),
                  );
                },
              );
            },
          );
        },
        error: (error, stackTrace) {
          Alert.handleError(context, error);
          return ErrorScreen(error: error.toString());
        },
        loading: () => Center(child: Loaders.center()),
      ),
    );
  }
}
