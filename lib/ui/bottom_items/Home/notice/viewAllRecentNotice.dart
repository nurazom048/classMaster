import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/notice/noticeRequest.dart';
import 'package:table/widgets/appWidget/appText.dart';

import '../../../../core/dialogs/Alart_dialogs.dart';
import '../../../../main.dart';
import '../../../../widgets/heder/hederTitle.dart';
import '../widgets/notice_row.dart';

class ViewAllRecentNotice extends StatelessWidget {
  const ViewAllRecentNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(builder: (context, ref, _) {
        final recentNoticeList = ref.watch(recentNoticeProvider);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderTitle("Back to Home", context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: const AppText("view All \nrecent notice").title(),
            ),
            recentNoticeList.when(
                data: (data) {
                  return data.fold(
                      (error) => Alart.handleError(context, error),
                      (r) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: List.generate(
                                r.notices.length,
                                (index) => NoticeRow(
                                  notice: r.notices[index],
                                  date: r.notices[index].time.toString(),
                                  title: r.notices[index].contentName,
                                ),
                              ),
                            ),
                          ));
                },
                error: (error, stackTrace) => Alart.handleError(context, error),
                loading: () => const Text("loding")),
          ],
        );
      }),
    );
  }
}
