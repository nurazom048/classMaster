import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/export_core.dart';
import '../../../../route/app_router.dart';
import '../widgets/static_widgets/modern_reusable_notice_card_widget.dart';
import '../providers/saved_notices_provider.dart';
import 'view_notice_screen.dart';

/// A screen that displays all the saved/bookmarked notices.
class SavedNoticesScreen extends ConsumerWidget {
  const SavedNoticesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedNotices = ref.watch(savedNoticesProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FD),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom Header with back option
            HeaderTitle("Saved Notices", context),

            Expanded(
              child:
                  savedNotices.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.bookmark_border_rounded,
                              size: 72,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "No saved notices yet",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                              ),
                              child: Text(
                                "Notices you bookmark will appear here for quick access even when offline.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: savedNotices.length,
                        separatorBuilder:
                            (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final notice = savedNotices[index];
                          return PremiumNoticeCard(
                            notice: notice,
                            academyID: null,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 4,
                            ),
                            onLongPress: () {},
                            onTap: () {
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
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
