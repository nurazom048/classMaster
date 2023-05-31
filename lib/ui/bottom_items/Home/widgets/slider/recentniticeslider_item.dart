// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

import '../notice_row.dart';

class RecentNoticeSliderItem extends StatelessWidget {
  const RecentNoticeSliderItem(
      {super.key,
      required this.notice,
      required this.conditon,
      required this.index});
  final notice;
  final int index;
  final bool conditon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (conditon == true) ...[
              NoticeRow(
                notice: notice[index],
                date: notice[index].time.toString(),
                title: notice[index].contentName,
              ),
              NoticeRow(
                notice: notice[index + 1],
                date: notice[index + 1].time.toString(),
                title: notice[index + 1].contentName,
              )
            ],
          ]),
    );
  }
}
