// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:table/core/component/loaders.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/utils/rutin_dialog.dart';
import 'package:table/ui/bottom_items/Home/models/home_rutines_model.dart';
import 'package:table/ui/bottom_items/Home/notice_board/models/recent_notice_model.dart';
import 'package:table/ui/bottom_items/Home/widgets/mydrawer.dart';
import 'package:table/ui/bottom_items/Home/widgets/recent_notice_title.dart';
import 'package:table/ui/bottom_items/Home/widgets/recentnoticeslider_scalton.dart';
import 'package:table/ui/bottom_items/Home/widgets/slider/recentniticeslider_item.dart';
import 'package:table/widgets/error/error.widget.dart';
import '../../../../core/component/responsive.dart';
import '../../../../core/dialogs/alart_dialogs.dart';
import '../../Account/accounu_ui/Account_screen.dart';
import '../full_rutin/widgets/rutin_box/rutin_box_by_id.dart';
import '../full_rutin/widgets/sceltons/rutinebox_id_scelton.dart';
import '../home_req/home_rutins_controller.dart';
import '../notice_board/notice controller/virew_recent_notice_controller.dart';
import '../notice_board/screens/view_all_recent_notice.dart';
import '../widgets/custom_title_bar.dart';
import '../widgets/slider/recentnoticeslider.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({super.key});

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //! provider
    final homeRutins = ref.watch(homeRutinControllerProvider(null));
    final recentNoticeList = ref.watch(recentNoticeController(null));

//notifier
    final homeRutinsNotifier = ref.watch(recentNoticeController(null).notifier);

    //
    final _mobileView =
        homeMobileView(ref, recentNoticeList, context, homeRutins);

    const _appBar = ChustomTitleBar("title");
    return Responsive(
      // Mobile view
      mobile: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFF2F2F2),
          body: homeMobileView(ref, recentNoticeList, context, homeRutins),
        ),
      ),

      // Desktop view
      desktop: Scaffold(
          body: Column(
        children: [
          _appBar,
          Expanded(
            child: Row(
              children: [
                // Drawer
                const Expanded(flex: 1, child: MyDawer()),
                // mobile
                Expanded(
                  flex: 3,
                  child: Container(child: _mobileView, color: Colors.yellow),
                ),
                Expanded(flex: 1, child: Container(color: Colors.black)),
              ],
            ),
          ),
        ],
      )),
    );
  }

/////////////
  homeMobileView(WidgetRef ref, AsyncValue<RecentNotice> recentNoticeList,
      BuildContext context, AsyncValue<RoutineHome> homeRutins) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 100),
      controller: scrollController,
      children: [
        if (Responsive.isMobile(context)) const ChustomTitleBar("title"),
        //_______________________ recent notices _________________//
        RecentNoticeTitle(
          onTap: () => Get.to(() => ViewAllRecentNotice(),
              transition: Transition.rightToLeftWithFade),
        ),

        SizedBox(
          height: 181,
          child: recentNoticeList.when(
            data: (data) {
              int length = data.notices.length;
              return RecentNoticeSlider(
                list: <Widget>[
                  RecentNoticeSliderItem(
                    notice: data.notices,
                    index: 0,
                    conditon: length >= 2,
                  ),

                  //
                  RecentNoticeSliderItem(
                    notice: data.notices,
                    index: 2,
                    conditon: length >= 4,
                  ), //
                  RecentNoticeSliderItem(
                    notice: data.notices,
                    index: 3,
                    conditon: length >= 6,
                  ),

                  RecentNoticeSliderItem(
                    notice: data.notices,
                    index: 4,
                    conditon: length >= 8,
                  ),
                ],
              );
            },
            error: (error, stackTrace) {
              // print('error happend');
              // print(error);
              Alart.handleError(context, error);

              return ErrorScreen(error: error.toString());
            },
            loading: () => const RecentNoticeSliderScealton(),
          ),
        ),

        // uploaded rutines

        homeRutins.when(
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

            //
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 100),
              itemCount: data.homeRoutines.length,
              itemBuilder: (context, index) {
                return RutinBoxById(
                  rutinId: data.homeRoutines[index].rutineId.id,
                  rutinName: data.homeRoutines[index].rutineId.name,
                  onTapMore: () => RutinDialog.ChackStatusUser_BottomSheet(
                    context,
                    data.homeRoutines[index].rutineId.id,
                    data.homeRoutines[index].rutineId.name,
                  ),
                );
              },
            );
          },
          loading: () => RUTINE_BOX_SKELTON,
          error: (error, stackTrace) {
            Alart.handleError(context, error);
            return ErrorScreen(error: error.toString());
          },
        ),
      ],
    );
  }

  //
}

bool hideNevBarOnScroll(ScrollNotification? scrollNotification, WidgetRef ref) {
  // Logic of scrollNotification
  if (scrollNotification is ScrollStartNotification) {
    // ignore: avoid_print
    print("Scroll Started");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.watch(hideNevBarOnScrooingProvider.notifier).update((state) => true);
    });
  } else if (scrollNotification is ScrollUpdateNotification) {
    // print(message);
  } else if (scrollNotification is ScrollEndNotification) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.watch(hideNevBarOnScrooingProvider.notifier).update((state) => false);
    });

    String message = 'Scroll Ended';
    print(message);
  }
  return true;
}
