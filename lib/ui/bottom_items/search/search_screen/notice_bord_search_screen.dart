import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/search/search_screen/search_page.dart';

import '../../../../core/dialogs/alart_dialogs.dart';
import '../../Home/notice_board/widgets/notice_board_card.dart';
import '../search controller/noticeborrd_search_controller.dart';

class NoticeBordSearch extends ConsumerWidget {
  // ignore: use_key_in_widget_constructors
  const NoticeBordSearch({Key? key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Provider
    final searchText = ref.watch(Serarch_String_Provider);
    final noticeBoardList = ref.watch(searchNoticeBoardController(searchText));

    return SizedBox(
      height: 500,
      width: MediaQuery.of(context).size.width,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 0) {
            return SizedBox(
              width: constraints.maxWidth,
              child: noticeBoardList.when(
                data: (data) {
                  if (data == null) {}
                  return ListView.builder(
                    itemCount: data.noticeBoards.length,
                    itemBuilder: (context, index) {
                      print(data);
                      return MiniNoticeCard(
                        noticeBoarName: data.noticeBoards[index].name,
                        ownerName: data.noticeBoards[index].owner.name,
                        image: data.noticeBoards[index].owner.image,
                        username: data.noticeBoards[index].owner.username,
                        noticeBoardId: data.noticeBoards[index].id,
                      );
                    },
                  );
                },
                error: (error, stackTrace) => Alart.handleError(context, error),
                loading: () => const Text("Loading"),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
