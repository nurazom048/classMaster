// ignore_for_file: curly_braces_in_flow_control_structures, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/core/dialogs/Alart_dialogs.dart';
import 'package:table/widgets/heder/hederTitle.dart';

import '../../../../Account/accounu_ui/save_screen.dart';
import '../../request/noticeBoard_request.dart';

class UploadedNoticeBordScreen extends ConsumerWidget {
  const UploadedNoticeBordScreen({super.key});

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
                          rutineName: data.noticeBoards[index].name,
                          owerName: data.noticeBoards[index].owner.name ?? '',
                          image: data.noticeBoards[index].owner.image,
                          username:
                              data.noticeBoards[index].owner.username ?? '',
                          rutinId: data.noticeBoards[index].id,
                        );
                      },
                    );
                  },
                  error: (error, stackTrace) =>
                      Alart.handleError(context, error),
                  loading: () => const Text("loding"))),
        ],
      ),
    );
  }
}
