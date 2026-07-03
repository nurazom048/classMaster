// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classmate/features/account_fetures/data/models/account_models.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/export_core.dart';
import '../../../../core/helper/timer.helper.dart' show getTimeGroupLabel;
import '../../../../route/app_router.dart';
import '../providers/view_recent_notice_controller.dart';
import '../utils/notice_board_dialog.dart';
import '../widgets/static_widgets/modern_reusable_notice_card_widget.dart'
    show PremiumNoticeCard;
import 'view_notice_screen.dart';

class ViewAllRecentNotice extends ConsumerStatefulWidget {
  const ViewAllRecentNotice({super.key, this.accountData});

  final AccountModels? accountData;

  @override
  ConsumerState<ViewAllRecentNotice> createState() =>
      _ViewAllRecentNoticeState();
}

class _ViewAllRecentNoticeState extends ConsumerState<ViewAllRecentNotice> {
  final scrollController = ScrollController();
  String selectedCategory = 'all';

  final List<Map<String, String>> categories = [
    {'key': 'all', 'label': 'All'},
    {'key': 'job_circular', 'label': 'Job Circular'},
    {'key': 'notice', 'label': 'Notice'},
    {'key': 'result', 'label': 'Result'},
    {'key': 'other', 'label': 'Other'},
  ];

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String? academyID = widget.accountData?.id;
    final String title = widget.accountData?.name ?? "Back to Home";

    final recentNoticeList = ref.watch(recentNoticeController(academyID));

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FD),
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
                          vertical: 15,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "All Recent Notice",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.search,
                                color: Colors.blueAccent,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),

                      // কাস্টম ক্যাটাগরি টগল বাটন রো
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 5,
                        ),
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children:
                              categories.map((cat) {
                                final isSelected =
                                    selectedCategory == cat['key'];
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedCategory = cat['key']!;
                                    });
                                    ref
                                        .read(
                                          recentNoticeController(
                                            academyID,
                                          ).notifier,
                                        )
                                        .changeCategoryFilter(cat['key']!);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          isSelected
                                              ? const Color(0xFF0052CC)
                                              : Colors.white,
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                        color:
                                            isSelected
                                                ? Colors.transparent
                                                : Colors.grey.shade300,
                                        width: 1,
                                      ),
                                      boxShadow:
                                          isSelected
                                              ? [
                                                BoxShadow(
                                                  color: const Color(
                                                    0xFF0052CC,
                                                  ).withOpacity(0.3),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ]
                                              : null,
                                    ),
                                    child: Text(
                                      cat['label']!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight:
                                            isSelected
                                                ? FontWeight.bold
                                                : FontWeight.w500,
                                        color:
                                            isSelected
                                                ? Colors.white
                                                : Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ],
          body: recentNoticeList.when(
            data: (data) {
              void scrollListener() {
                if (scrollController.position.pixels ==
                    scrollController.position.maxScrollExtent) {
                  ref
                      .read(recentNoticeController(academyID).notifier)
                      .loadMore(data.currentPage, context);
                }
              }

              scrollController.removeListener(scrollListener);
              scrollController.addListener(scrollListener);

              if (data.notices.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: Text(
                      "No notices found in this category.",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 20),
                physics: const BouncingScrollPhysics(),
                itemCount: data.notices.length + 1,
                itemBuilder: (context, index) {
                  if (index < data.notices.length) {
                    final notice = data.notices[index];
                    final accountModel = notice.account;

                    // 🎯 Today / Yesterday গ্রুপিং চেক করা
                    bool isFirstInGroup = true;
                    if (index > 0) {
                      final previousNotice = data.notices[index - 1];
                      if (getTimeGroupLabel(notice.createdAt) ==
                          getTimeGroupLabel(previousNotice.createdAt)) {
                        isFirstInGroup = false;
                      }
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🎯 গ্রুপ হেডার রেন্ডার করা (যেমন: Today, Yesterday)
                        if (isFirstInGroup)
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 24,
                              top: 20,
                              bottom: 8,
                            ),
                            child: Text(
                              getTimeGroupLabel(notice.createdAt),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF374151),
                              ),
                            ),
                          ),

                        PremiumNoticeCard(
                          notice: notice,
                          academyID: academyID,
                          onLongPress: () {
                            NoticeboardDialog.logPressNotice(
                              context,
                              noticeBoardId: accountModel.id!,
                              academyID: academyID,
                              noticeId: notice.id,
                            );
                          },
                          onTap: () {
                            context.push(
                              '/notice/${notice.id}',
                              extra: ViewNoticeExtraData(
                                id: notice.id,
                                notice: notice,
                                accountModel: notice.account,
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  } else if (data.currentPage < data.totalPages) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Loaders.center(),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              );
            },
            error: (error, stackTrace) => Alert.handleError(context, error),
            loading: () => Center(child: Loaders.center()),
          ),
        ),
      ),
    );
  }
}
