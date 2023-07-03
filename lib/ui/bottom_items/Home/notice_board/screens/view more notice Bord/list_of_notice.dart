import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:table/core/dialogs/alert_dialogs.dart';
import 'package:table/ui/bottom_items/Home/notice_board/screens/view_notice_screen.dart';

import '../../models/recent_notice_model.dart';
import '../../notice controller/virew_recent_notice_controller.dart';
import '../../widgets/simple_notice_card.dart';

////////////////////////////////////
class ListOfNoticeScreen extends ConsumerWidget {
  final String noticeBoardId;
  ListOfNoticeScreen({super.key, required this.noticeBoardId});
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //! provider
    final listOfNotices = ref.watch(recentNoticeController(null));
    return SizedBox(
      height: 800,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              // margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 600,
              child: listOfNotices.when(
                data: (data) {
                  void scrollListener() {
                    if (scrollController.position.pixels ==
                        scrollController.position.maxScrollExtent) {
                      // print("reached the end");
                      ref
                          .watch(recentNoticeController(null).notifier)
                          .loadMore(data.currentPage, context);
                    }
                  }

                  scrollController.addListener(scrollListener);
                  return ListView.builder(
                    controller: scrollController,
                    itemCount: data.notices.length,
                    itemBuilder: (context, index) {
                      return SimpleNoticeCard(
                        previousDateTime:
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
                              academyId: data.notices[index].academyId,
                              // description: data.notices[index].description,
                              // noticeBoard: data.notices[index].noticeBoard,
                              time: data.notices[index].time,
                            ),
                            accountModel: data.notices[index].academyId,
                          ),
                        ),
                        onLongPress: () {},
                        dateTime: data.notices[index].time,
                      );
                    },
                  );
                },
                error: (error, stackTrace) => Alert.handleError(context, error),
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
