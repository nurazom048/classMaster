// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_result, use_build_context_synchronously, avoid_print

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:table/services/one%20signal/onesignla.services.dart';
import 'package:table/ui/bottom_items/Home/Full_routine/utils/routine_dialog.dart';
import 'package:table/ui/bottom_items/Home/models/home_routines_model.dart';
import 'package:table/ui/bottom_items/Home/notice_board/models/recent_notice_model.dart';
import 'package:table/ui/bottom_items/Home/utils/utils.dart';
import 'package:table/ui/bottom_items/Home/widgets/mydrawer.dart';
import 'package:table/ui/bottom_items/Home/widgets/recent_notice_title.dart';
import 'package:table/ui/bottom_items/Home/widgets/recentnoticeslider_scalton.dart';
import 'package:table/ui/bottom_items/Home/widgets/slider/recentniticeslider_item.dart';
import 'package:table/widgets/error/error.widget.dart';
import '../../../../core/component/responsive.dart';
import '../../../../core/dialogs/alert_dialogs.dart';
import '../../../../services/firebase/firebase_analytics.service.dart';
import '../../../../services/notification services/awn_package.dart';
import '../../Collection Fetures/Ui/collections.screen.dart';
import '../Full_routine/widgets/routine_box/routine_box_by_id.dart';
import '../Full_routine/widgets/skelton/routine_box_id_scelton.dart';
import '../home_req/home_routines_controller.dart';
import '../notice_board/notice controller/virew_recent_notice_controller.dart';
import '../notice_board/screens/view_all_recent_notice.dart';
import '../widgets/custom_title_bar.dart';
import '../widgets/slider/recentnoticeslider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final scrollController = ScrollController();
FirebaseAnalytics analytics = FirebaseAnalytics.instance;

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // //firebase
    FirebaseAnalyticsServices.logHome();
    // AwesomeNotificationSetup
    AwesomeNotificationSetup.initialize();
    AwesomeNotificationSetup.takePermiton(context);
    // One signal
    OneSignalServices.initialize();
    OneSignalServices.oneSignalPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      //! provider

      final homeRoutines = ref.watch(homeRoutineControllerProvider(null));
      final recentNoticeList = ref.watch(recentNoticeController(null));

//notifier
      final homeRoutinesNotifier =
          ref.watch(homeRoutineControllerProvider(null).notifier);
      //
      final _mobileView = homeMobileView(
          ref, recentNoticeList, context, homeRoutines,
          homeRoutineNotifier: homeRoutinesNotifier);

      Widget _appBar = const CustomTitleBar("title");
      return Responsive(
        // Mobile view
        mobile: SafeArea(
          child: Scaffold(
            backgroundColor: const Color(0xFFF2F2F2),
            body: homeMobileView(ref, recentNoticeList, context, homeRoutines,
                homeRoutineNotifier: homeRoutinesNotifier),
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
                  const Expanded(flex: 1, child: MyDrawer()),
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
    });
  }
}

/////////////
homeMobileView(WidgetRef ref, AsyncValue<RecentNotice> recentNoticeList,
    BuildContext context, AsyncValue<RoutineHome> homeRoutines,
    {required homeRoutineNotifier}) {
  return RefreshIndicator(
    onRefresh: () async {
      final bool isOnline = await Utils.isOnlineMethod();
      if (!isOnline) {
        Alert.showSnackBar(context, 'You are in offline mood');
      } else {
        //! provider
        ref.refresh(homeRoutineControllerProvider(null));
        ref.refresh(recentNoticeController(null));
      }
    },
    child: ListView(
      padding: const EdgeInsets.only(bottom: 100),
      controller: scrollController,
      children: [
        if (Responsive.isMobile(context)) const CustomTitleBar("title"),

        //_______________________ recent notices _________________//
        RecentNoticeTitle(
          onTap: () => Get.to(() => ViewAllRecentNotice(),
              transition: Transition.rightToLeftWithFade),
        ),

        SizedBox(
          height: 160,
          // color: Colors.red,
          child: recentNoticeList.when(
            data: (data) {
              int length = data.notices.length;
              return RecentNoticeSlider(
                list: <Widget>[
                  RecentNoticeSliderItem(
                    notice: data.notices,
                    index: 0,
                    condition: length >= 2,
                    singleCondition: length == 1,
                    recentNotice: data,
                  ),

                  //
                  RecentNoticeSliderItem(
                    notice: data.notices,
                    index: 2,
                    condition: length >= 4,
                    singleCondition: length == 3,
                    recentNotice: data,
                  ), //
                  RecentNoticeSliderItem(
                    notice: data.notices,
                    index: 3,
                    condition: length >= 6,
                    singleCondition: length == 5,
                    recentNotice: data,
                  ),

                  RecentNoticeSliderItem(
                    notice: data.notices,
                    index: 4,
                    condition: length >= 8,
                    singleCondition: length == 7,
                    recentNotice: data,
                  ),
                ],
              );
            },
            error: (error, stackTrace) {
              Alert.handleError(context, error);

              return ErrorScreen(error: error.toString());
            },
            loading: () => const RecentNoticeSliderSkelton(),
          ),
        ),
        const SizedBox(height: 10),
        // uploaded Routine

        homeRoutines.when(
          data: (data) {
            void scrollListener() {
              if (scrollController.position.pixels ==
                  scrollController.position.maxScrollExtent) {
                print('end.........................');
                ref
                    .watch(homeRoutineControllerProvider(null).notifier)
                    .loadMore(data.currentPage);
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
                return RoutineBoxById(
                  rutinId: data.homeRoutines[index].rutineId.id,
                  rutinName: data.homeRoutines[index].rutineId.name,
                  onTapMore: () => RoutineDialog.CheckStatusUser_BottomSheet(
                    context,
                    routineID: data.homeRoutines[index].rutineId.id,
                    routineName: data.homeRoutines[index].rutineId.name,
                    routinesController: homeRoutineNotifier,
                  ),
                );
              },
            );
          },
          loading: () => RUTINE_BOX_SKELTON,
          error: (error, stackTrace) {
            Alert.handleError(context, error);
            return ErrorScreen(error: error.toString());
          },
        ),

        //
      ],
    ),
  );
}

//

bool hideNevBarOnScroll(ScrollNotification? scrollNotification, WidgetRef ref) {
  // Logic of scrollNotification
  if (scrollNotification is ScrollStartNotification) {
    print("Scroll Started");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.watch(hideNevBarOnScorningProvider.notifier).update((state) => true);
    });
  } else if (scrollNotification is ScrollUpdateNotification) {
    // print(message);
  } else if (scrollNotification is ScrollEndNotification) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.watch(hideNevBarOnScorningProvider.notifier).update((state) => false);
    });

    String message = 'Scroll Ended';
    print(message);
  }
  return true;
}
