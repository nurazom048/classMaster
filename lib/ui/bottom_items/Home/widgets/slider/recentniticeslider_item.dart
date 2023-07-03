// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

import '../../notice_board/models/recent_notice_model.dart';
import '../notice_row.dart';

class RecentNoticeSliderItem extends StatelessWidget {
  const RecentNoticeSliderItem({
    super.key,
    required this.notice,
    required this.conditon,
    required this.index,
    required this.singleCondition,
    required this.recentNotice,
  });
  final List<Notice> notice;
  final int index;
  final bool conditon;
  final bool singleCondition;
  final RecentNotice recentNotice;

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
                accountModels: recentNotice.notices[index].academyId,
              )
            else if (conditon == true) ...[
              NoticeRow(
                notice: notice[index],
                accountModels: recentNotice.notices[index].academyId,
              ),
              NoticeRow(
                notice: notice[index + 1],
                accountModels: recentNotice.notices[index + 1].academyId,
              ),
            ] else
              const SizedBox(
                height: 120,
                child: Center(
                  child: Text("Join NoticeBoard to see Recent Notices"),
                ),
              )
          ]),
    );
  }
}
