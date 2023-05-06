// ignore_for_file: non_constant_identifier_names, use_key_in_widget_constructors, unnecessary_null_comparison

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as ma;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/utils/rutin_dialog.dart';
import 'package:table/ui/bottom_items/Home/home_req/uploaded_rutine_controller.dart';
import 'package:table/ui/bottom_items/Home/notice/notice%20controller/noticeRequest.dart';
import 'package:table/ui/bottom_items/Home/notice/screens/viewAllRecentNotice.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/widgets/rutin_box/rutin_box_by_id.dart';
import 'package:table/ui/bottom_items/Home/widgets/recent_notice_title.dart';
import '../../../../core/dialogs/alart_dialogs.dart';
import '../../Account/accounu_ui/account_screen.dart';
import '../full_rutin/widgets/sceltons/rutinebox_id_scelton.dart';
import '../widgets/custom_title_bar.dart';
import '../widgets/notice_row.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({Key? key});
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //! provider
    final uploaded_rutins = ref.watch(uploadedRutinsControllerProvider);
    final recentNoticeList = ref.watch(recentNoticeProvider);
    return SafeArea(
        child: Scaffold(
            backgroundColor: const Color(0xFFF2F2F2),
            body: NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                // Logic of scrollNotification
                if (scrollNotification is ScrollStartNotification) {
                  print("Scroll Started");

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ref
                        .watch(hideNevBarOnScrooingProvider.notifier)
                        .update((state) => true);
                  });
                } else if (scrollNotification is ScrollUpdateNotification) {
                  String message = 'Scroll Updated';
                  // print(message);
                } else if (scrollNotification is ScrollEndNotification) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ref
                        .watch(hideNevBarOnScrooingProvider.notifier)
                        .update((state) => false);
                  });

                  String message = 'Scroll Ended';
                  print(message);
                }
                return true;
              },
              child: ListView(
                padding: const EdgeInsets.only(bottom: 100),
                controller: scrollController,
                children: [
                  const ChustomTitleBar("title"),

                  RecentNoticeTitle(
                    //
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => const ViewAllRecentNotice()),
                      );
                    },
                  ),

                  Container(
                    height: 140,
                    margin: const EdgeInsets.symmetric(horizontal: 18),
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: recentNoticeList.when(
                        data: (data) {
                          return data.fold(
                              (error) => Alart.handleError(context, error),
                              (r) => ListView.builder(
                                    // physics: const NeverScrollableScrollPhysics(),
                                    itemCount: r.notices.length,
                                    itemBuilder: (context, index) {
                                      return NoticeRow(
                                        notice: r.notices[index],
                                        date: r.notices[index].time.toString(),
                                        title: r.notices[index].contentName,
                                      );
                                    },
                                  ));
                        },
                        error: (error, stackTrace) =>
                            Alart.handleError(context, error),
                        loading: () => ma.Text("loding")),
                  ),

                  // uploaded rutines

                  uploaded_rutins.when(
                    data: (data) {
                      if (data == null) return const ma.Text("Data not found");

                      void scrollListener() {
                        if (scrollController.position.pixels ==
                                scrollController.position.maxScrollExtent &&
                            data.currentPage! < data.totalPages!) {
                          ref
                              .watch(uploadedRutinsControllerProvider.notifier)
                              .loadMore(data.currentPage);
                        }
                      }

                      scrollController.addListener(scrollListener);

                      //
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 100),
                        itemCount: data.rutins.length,
                        itemBuilder: (context, index) {
                          if (data.rutins.length - 1 != index) {
                            return RutinBoxById(
                              rutinId: data.rutins[index].id,
                              rutinName: data.rutins[index].name,
                              onTapMore: () =>
                                  RutinDialog.ChackStatusUser_BottomSheet(
                                context,
                                data.rutins[index].id,
                                data.rutins[index].name,
                              ),
                            );
                          }
                          {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(bottom: 100),
                              itemCount: 1,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    RutinBoxById(
                                      rutinId: data.rutins[index].id,
                                      rutinName: data.rutins[index].name,
                                      onTapMore: () => RutinDialog
                                          .ChackStatusUser_BottomSheet(
                                        context,
                                        data.rutins[index].id,
                                        data.rutins[index].name,
                                      ),
                                    ),
                                    data.currentPage == data.totalPages
                                        ? const SizedBox.shrink()
                                        : const RutinBoxByIdSkelton(),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      );
                    },
                    loading: () => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return const RutinBoxByIdSkelton();
                      },
                    ),
                    error: (error, stackTrace) =>
                        Alart.handleError(context, error),
                  ),
                ],
              ),
            )));
  }
}
