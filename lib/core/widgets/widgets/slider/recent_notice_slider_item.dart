// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

import '../../../../features/notice_fetures/data/models/recent_notice_model.dart';
import '../../../../features/notice_fetures/presentation/widgets/static_widgets/modern_reusable_notice_card_widget.dart'
    show PremiumNoticeCard;

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
    return SizedBox(
      height: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (singleCondition == true)
            Expanded(
              child: PremiumNoticeCard(
                notice: notice[index],
                academyID: recentNotice.notices[index].publisherId,
                onTap: () {
                  // Handle navigation to notice details
                  debugPrint('Tapped notice: ${notice[index].title}');
                },
                onLongPress: () {
                  // Handle long press action
                  debugPrint('Long pressed notice: ${notice[index].title}');
                },
              ),
            )
          else if (condition == true) ...[
            Expanded(
              child: PremiumNoticeCard(
                notice: notice[index],
                academyID: recentNotice.notices[index].publisherId,
                onTap: () {
                  debugPrint('Tapped notice: ${notice[index].title}');
                },
                onLongPress: () {
                  debugPrint('Long pressed notice: ${notice[index].title}');
                },
              ),
            ),
            Expanded(
              child: PremiumNoticeCard(
                notice: notice[index + 1],
                academyID: recentNotice.notices[index + 1].publisherId,
                onTap: () {
                  debugPrint('Tapped notice: ${notice[index + 1].title}');
                },
                onLongPress: () {
                  debugPrint('Long pressed notice: ${notice[index + 1].title}');
                },
              ),
            ),
          ] else
            Expanded(
              child: Center(
                child: Text(
                  emptyMessage ?? "Join NoticeBoard to see Recent Notices",
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
