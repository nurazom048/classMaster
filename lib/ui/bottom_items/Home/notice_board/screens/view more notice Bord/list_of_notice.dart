import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:table/core/dialogs/alart_dialogs.dart';
import 'package:table/ui/bottom_items/Home/notice_board/screens/viewNotice.dart';

import '../../models/notice bord/recentNotice.dart';
import '../../notice controller/list_of_notices_controller.dart';
import '../../widgets/simple_notice_card.dart';

////////////////////////////////////
class ListOfNoticeScreen extends ConsumerWidget {
  final String noticeBoardId;
  const ListOfNoticeScreen({super.key, required this.noticeBoardId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //! provider
    final listOfNotices = ref.watch(listofNoticesProvider(noticeBoardId));
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              // margin: const EdgeInsets.symmetric(horizontal: 10),
              // height: 200,
              child: listOfNotices.when(
                data: (data) {
                  return ListView.builder(
                    itemCount: data.notices.length,
                    itemBuilder: (context, index) {
                      return SimpleNoticeCard(
                        previusDAtetime:
                            data.notices[index == 0 ? 0 : index - 1].time,
                        id: data.notices[index].id,
                        noticeName: data.notices[index].contentName,
                        ontap: () => Get.to(
                          transition: Transition.rightToLeft,
                          NoticeViewScreen(
                              notice: Notice(
                            id: data.notices[index].id,
                            contentName: data.notices[index].contentName,
                            pdf: data.notices[index].pdf,
                            description: data.notices[index].description,
                            noticeBoard: data.notices[index].noticeBoard,
                            time: data.notices[index].time,
                          )),
                        ),
                        onLongPress: () {},
                        dateTime: data.notices[index].time,
                      );
                    },
                  );
                },
                error: (error, stackTrace) => Alart.handleError(context, error),
                loading: () {
                  return const Text("Loding");
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
