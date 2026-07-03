import 'package:classmate/core/component/heder_component/transition/right_to_left_transition.dart';
import 'package:classmate/features/notice_fetures/data/models/recent_notice_model.dart';
import 'package:classmate/features/notice_fetures/presentation/screens/view_notice_screen.dart';
import 'package:classmate/route/app_router.dart';
import 'package:classmate/route/route_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classmate/core/dialogs/alert_dialogs.dart';
import 'package:go_router/go_router.dart';
import '../providers/view_recent_notice_controller.dart';
import '../widgets/static_widgets/modern_reusable_notice_card_widget.dart';

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
                      return PremiumNoticeCard(
                        notice: data.notices[index],
                        academyID: data.notices[index].id,

                        onTap: () {
                          final notice = data.notices[index];

                          context.push(
                            '/notice/${notice.id}',
                            extra: ViewNoticeExtraData(
                              id: notice.id,
                              notice: notice,
                              accountModel: notice.account,
                            ),
                          );
                        },
                        onLongPress: () {},
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
