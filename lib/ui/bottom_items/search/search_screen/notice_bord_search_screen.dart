import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/search/search_request/notice_bord_search.dart';
import 'package:table/ui/bottom_items/search/search_screen/search_page.dart';
import 'package:flutter/material.dart' as ma;

import '../../../../core/dialogs/alart_dialogs.dart';
import '../../Home/notice_board/widgets/notice_board_card.dart';

class NoticeBordSearch extends ConsumerWidget {
  const NoticeBordSearch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //! provider
    final searchText = ref.watch(Serarch_String_Provider);
    final noticeBoardList = ref.watch(noticeSearchProvider(searchText));
    return SizedBox(
      height: 500,
      width: MediaQuery.of(context).size.width,
      child: SizedBox(
        child: noticeBoardList.when(
            data: (data) {
              return ListView.builder(
                itemCount: data.noticeBoards.length,
                itemBuilder: (context, index) {
                  return MiniNoticeCard(
                    noticeBoarName: "",
                    ownerName: data.noticeBoards[index].owner.name ?? '',
                    image: data.noticeBoards[index].owner.image,
                    username: data.noticeBoards[index].owner.username ?? '',
                    noticeBoardId: data.noticeBoards[index].id,
                  );
                },
              );
            },
            error: (error, stackTrace) => Alart.handleError(context, error),
            loading: () => const ma.Text("loding")),
      ),
    );
  }
}
