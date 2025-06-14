import 'package:classmate/core/component/heder%20component/transition/right_to_left_transition.dart';
import 'package:classmate/features/notice_fetures/presentation/screens/view_notice_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classmate/core/dialogs/alert_dialogs.dart';

import '../../data/models/recent_notice_model.dart';
import '../providers/view_recent_notice_controller.dart';
import '../widgets/static_widgets/simple_notice_card.dart';

////////////////////////////////////
class ListOfNoticeScreen extends ConsumerWidget {
  final String noticeBoardId;
  ListOfNoticeScreen({super.key, required this.noticeBoardId});

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listOfNotices = ref.watch(recentNoticeController(null));

    return SizedBox(
      height: 800,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 600,
              child: listOfNotices.when(
                data: (data) {
                  void scrollListener() {
                    if (scrollController.position.pixels ==
                        scrollController.position.maxScrollExtent) {
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
                            data.notices[index == 0 ? 0 : index - 1].createdAt,
                        id: data.notices[index].id,
                        noticeName: data.notices[index].title,
                        ontap: () {
                          Navigator.push(
                            context,
                            RightToLeftTransition(
                              page: NoticeViewScreen(
                                notice: Notice(
                                  id: data.notices[index].id,
                                  title: data.notices[index].title,
                                  pdf: data.notices[index].pdf,
                                  account: data.notices[index].account,
                                  description: data.notices[index].description,
                                  createdAt: data.notices[index].createdAt,
                                ),
                                accountModel: data.notices[index].account,
                              ),
                            ),
                          );
                        },
                        onLongPress: () {},
                        dateTime: data.notices[index].createdAt,
                      );
                    },
                  );
                },
                error: (error, stackTrace) => Alert.handleError(context, error),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
