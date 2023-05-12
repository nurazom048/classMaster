import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/notice_board/screens/viewNotice.dart';
import 'package:table/widgets/appWidget/app_text.dart';

import '../../../../../core/dialogs/alart_dialogs.dart';
import '../../../../../widgets/heder/heder_title.dart';
import '../notice controller/virew_recent_notice_controller.dart';
import '../widgets/simple_notice_card.dart';

class ViewAllRecentNotice extends ConsumerWidget {
  ViewAllRecentNotice({Key? key}) : super(key: key);
  final scrollController = ScrollController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentNoticeList = ref.watch(recentNoticeController);

    return Scaffold(
      body: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderTitle("Back to Home", context),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: const AppText("All \nrecent notice..").title(),
                ),
              ],
            ),
          ),
        ],
        body: recentNoticeList.when(
          data: (data) {
            void scrollListener() {
              if (scrollController.position.pixels ==
                  scrollController.position.maxScrollExtent) {
                print("reached the end");
                ref
                    .watch(recentNoticeController.notifier)
                    .loadMore(data.currentPage, context);
              }
            }

            scrollController.addListener(scrollListener);

            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.notices.length + 1,
              itemBuilder: (context, index) {
                if (index < data.notices.length) {
                  final notice = data.notices[index];
                  return SimpleNoticeCard(
                    id: notice.id,
                    dateTime: data.notices[index == 0 ? 0 : index - 1].time,
                    noticeName: notice.contentName,
                    previusDAtetime: notice.time,
                    isfrist: index == 0,
                    onLongPress: () {},
                    ontap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => NoticeViewScreen(
                            notice: notice,
                          ),
                        ),
                      );
                    },
                  );
                } else if (data.currentPage < data.totalPages) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Container();
                }
              },
            );
          },
          error: (error, stackTrace) => Alart.handleError(context, error),
          loading: () => const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
