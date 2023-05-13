import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/notice_board/widgets/notice_board_card.dart';
import 'package:table/widgets/heder/heder_title.dart';
import 'package:flutter/material.dart' as ma;

import '../../../../../../core/dialogs/alart_dialogs.dart';
import '../../request/notice_board_request.dart';

class JoinedNoticeBoardScreen extends ConsumerWidget {
  const JoinedNoticeBoardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //! provider
    final noticeBoardList = ref.watch(uploadedNoticeBoardProvider);
    return Scaffold(
      body: Column(
        children: [
          HeaderTitle("All Uploaded NoticeBoard", context),
          const SizedBox(height: 10),
          SizedBox(
              height: 400,
              child: noticeBoardList.when(
                  data: (data) {
                    return ListView.builder(
                      itemCount: data.noticeBoards.length,
                      itemBuilder: (context, index) {
                        return MiniNoticeCard(
                          noticeBoarName: data.noticeBoards[index].name,
                          noticeBoardId: data.noticeBoards[index].id,
                          ownerName: data.noticeBoards[index].owner.name,
                          image: data.noticeBoards[index].owner.image,
                          username: data.noticeBoards[index].owner.username,
                        );
                      },
                    );
                  },
                  error: (error, stackTrace) =>
                      Alart.handleError(context, error),
                  loading: () => const ma.Text("loding"))),
        ],
      ),
    );
  }
}
