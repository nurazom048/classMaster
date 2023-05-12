import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/core/dialogs/alart_dialogs.dart';
import 'package:table/widgets/heder/heder_title.dart';

import '../../request/notice_board_request.dart';
import '../../widgets/notice_board_card.dart';
import '../view_more_notice_bord.dart';

class UploadedNoticeBordScreen extends ConsumerWidget {
  const UploadedNoticeBordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //!provider
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
                    return InkWell(
                      child: MiniNoticeCard(
                        noticeBoardId: data.noticeBoards[index].id,
                        noticeBoarName: data.noticeBoards[index].name,
                        ownerName: data.noticeBoards[index].owner.name ?? '',
                        image: data.noticeBoards[index].owner.image,
                        username: data.noticeBoards[index].owner.username ?? '',
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ViewMoreNoticeBord(
                              id: data.noticeBoards[index].id,
                              noticeBoardName: data.noticeBoards[index].name,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              error: (error, stackTrace) => Alart.handleError(context, error),
              loading: () => const Text("Loading"),
            ),
          ),
        ],
      ),
    );
  }
}
