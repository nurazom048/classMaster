// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../features/account_fetures/data/models/account_models.dart';
import '../../../../core/export_core.dart';
import '../providers/view_recent_notice_controller.dart';
import '../utils/notice_board_dialog.dart';
import '../widgets/static_widgets/simple_notice_card.dart';
import 'view_notice_screen.dart';

class ViewAllRecentNotice extends ConsumerWidget {
  ViewAllRecentNotice({super.key, this.accountData});

  final AccountModels? accountData;
  final scrollController = ScrollController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? academyID = accountData?.id;
    final String title = accountData?.name ?? "Back to Home";

    //! View Recent Notices
    final recentNoticeList = ref.watch(recentNoticeController(academyID));

    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          controller: scrollController,
          headerSliverBuilder:
              (context, innerBoxIsScrolled) => [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeaderTitle(title, context),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child:
                            const AppText("All \nrecent notice.....").title(),
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
                      .watch(recentNoticeController(null).notifier)
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
                    final accountModel = data.notices[index].account;
                    return SimpleNoticeCard(
                      id: notice.id,
                      dateTime:
                          data.notices[index == 0 ? 0 : index - 1].createdAt,
                      noticeName: notice.title,
                      previousDateTime: notice.createdAt,
                      isFirst: index == 0,
                      onLongPress: () {
                        print(accountModel.id!);
                        print(academyID);
                        return NoticeboardDialog.logPressNotice(
                          context,
                          noticeBoardId: accountModel.id!,
                          academyID: academyID,
                          noticeId: notice.id,
                        );
                      },
                      ontap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => NoticeViewScreen(
                                  notice: notice,
                                  accountModel: accountModel,
                                ),
                          ),
                        );
                      },
                    );
                  } else if (data.currentPage < data.totalPages) {
                    return Column(
                      children: [const SizedBox(height: 20), Loaders.center()],
                    );
                  } else {
                    return Container();
                  }
                },
              );
            },
            error: (error, stackTrace) => Alert.handleError(context, error),
            loading: () => Loaders.center(),
          ),
        ),
      ),
    );
  }
}
