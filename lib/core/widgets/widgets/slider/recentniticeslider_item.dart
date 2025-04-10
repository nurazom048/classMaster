// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

import '../../../../features/notice_fetures/data/models/recent_notice_model.dart';
import '../notice_row.dart';

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
      height: 120,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (singleCondition == true)
              NoticeRow(
                notice: notice[index],
                accountModels: recentNotice.notices[index].account,
              )
            else if (condition == true) ...[
              NoticeRow(
                notice: notice[index],
                accountModels: recentNotice.notices[index].account,
              ),
              NoticeRow(
                notice: notice[index + 1],
                accountModels: recentNotice.notices[index + 1].account,
              ),
            ] else
              Expanded(
                  child: Center(
                child: Text(
                    emptyMessage ?? "Join NoticeBoard to see Recent Notices"),
              ))
          ]),
    );
  }
}
