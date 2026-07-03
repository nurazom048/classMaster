// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../features/notice_fetures/data/models/recent_notice_model.dart';
import '../../../../features/notice_fetures/presentation/widgets/static_widgets/modern_reusable_notice_card_widget.dart';
import '../../../../route/app_router.dart';

class RecentNoticeSliderItem extends StatelessWidget {
  const RecentNoticeSliderItem({
    super.key,
    required this.notice,
    required this.condition,
    required this.index,
    required this.singleCondition,
    required this.recentNotice,
    this.emptyMessage,
  });

  final List<Notice> notice;
  final int index;
  final bool condition;
  final bool singleCondition;
  final RecentNotice recentNotice;
  final String? emptyMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (singleCondition == true)
              // ✅ Single notice card
              PremiumNoticeCard(
                notice: notice[index],
                academyID: recentNotice.notices[index].publisherId,
                onTap: () {
                  debugPrint('🔗 Navigating to notice: ${notice[index].id}');
                  context.push(
                    '/notice/${notice[index].id}',
                    extra: ViewNoticeExtraData(
                      id: notice[index].id,
                      notice: notice[index],
                      accountModel: notice[index].account,
                    ),
                  );
                },
                onLongPress: () {
                  debugPrint('📌 Long pressed notice: ${notice[index].title}');
                },
              )
            else if (condition == true) ...[
              // ✅ First card with navigation
              PremiumNoticeCard(
                notice: notice[index],
                academyID: recentNotice.notices[index].publisherId,
                onTap: () {
                  debugPrint('🔗 Navigating to notice: ${notice[index].id}');
                  context.push(
                    '/notice/${notice[index].id}',
                    extra: ViewNoticeExtraData(
                      id: notice[index].id,
                      notice: notice[index],
                      accountModel: notice[index].account,
                    ),
                  );
                },
                onLongPress: () {
                  debugPrint('📌 Long pressed notice: ${notice[index].title}');
                },
              ),
              const SizedBox(height: 12),

              // ✅ Second card with navigation
              PremiumNoticeCard(
                notice: notice[index + 1],
                academyID: recentNotice.notices[index + 1].publisherId,
                onTap: () {
                  debugPrint(
                    '🔗 Navigating to notice: ${notice[index + 1].id}',
                  );
                  context.push(
                    '/notice/${notice[index + 1].id}',
                    extra: ViewNoticeExtraData(
                      id: notice[index + 1].id,
                      notice: notice[index + 1],
                      accountModel: notice[index + 1].account,
                    ),
                  );
                },
                onLongPress: () {
                  debugPrint(
                    '📌 Long pressed notice: ${notice[index + 1].title}',
                  );
                },
              ),
            ] else
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    emptyMessage ?? "Join NoticeBoard to see Recent Notices",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
