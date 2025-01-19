// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_result, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:classmate/services/one%20signal/onesignla.services.dart';
import 'package:classmate/features/home_fetures/data/models/home_routines_model.dart';
import 'package:classmate/features/home_fetures/presentation/utils/utils.dart';
import 'package:classmate/core/widgets/widgets/mydrawer.dart';
import 'package:classmate/core/widgets/widgets/recent_notice_title.dart';
import 'package:classmate/core/widgets/widgets/recentnoticeslider_scalton.dart';
import 'package:classmate/core/widgets/widgets/slider/recentniticeslider_item.dart';
import '../../../../core/component/responsive.dart';
import '../../../../core/dialogs/alert_dialogs.dart';
import '../../../../core/widgets/appWidget/app_text.dart';
import '../../../../core/widgets/error/error.widget.dart';
import '../../../../services/firebase/firebase_analytics.service.dart';
import '../../../../services/notification services/awn_package.dart';
import '../../../notice_fetures/presentation/screens/view_all_recent_notice.dart';
import '../../../routine_Fetures/presentation/utils/routine_dialog.dart';
import '../../../routine_Fetures/presentation/widgets/dynamic_widgets/routine_box_by_id.dart';
import '../../../routine_Fetures/presentation/widgets/static_widgets/routine_box_id_scelton.dart';
import '../../../notice_fetures/presentation/providers/view_recent_notice_controller.dart';
import '../../../../core/widgets/widgets/custom_title_bar.dart';
import '../../../../core/widgets/widgets/slider/recentnoticeslider.dart';
import '../../data/datasources/home_routines_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController mobileScrollController;
  late ScrollController recentNoticeScrollController;

  @override
  void initState() {
    super.initState();
    // Initialize the scrollController
    mobileScrollController = ScrollController();
    recentNoticeScrollController = ScrollController();

    // One signal
    OneSignalServices.initialize();
    OneSignalServices.oneSignalPermission();
    // Firebase
    FirebaseAnalyticsServices.logHome();
    // AwesomeNotificationSetup

    AwesomeNotificationSetup.takePermiton(context);
  }

  @override
  void dispose() {
    // Dispose of the scrollController
    recentNoticeScrollController.dispose();
    mobileScrollController.dispose();
    super.dispose();
  }

  final Widget homeRecentNoticeWidget = const HomeRecentNoticeWidget();

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      print('HomeScreen');

      // provider
      final homeRoutines = ref.watch(homeRoutineControllerProvider(null));
      // final recentNoticeList = ref.watch(recentNoticeController(null));

      //notifier
      final homeRoutinesNotifier =
          ref.watch(homeRoutineControllerProvider(null).notifier);
      //
      final _mobileView = homeMobileView(
        context,
        ref: ref,
        homeRoutines: homeRoutines,
        scrollController: mobileScrollController,
        homeRoutineNotifier: homeRoutinesNotifier,
      );

      return Responsive(
        // Mobile view
        mobile: SafeArea(
          child: Scaffold(
            backgroundColor: const Color(0xFFF2F2F2),
            body: _mobileView,
          ),
        ),

        // Desktop view
        desktop: Scaffold(
          body: Column(
            children: [
              const CustomTitleBar("title"),
              Expanded(
                child: Row(
                  children: [
                    // Drawer
                    const Expanded(flex: 1, child: MyDrawer()),
                    // mobile
                    Expanded(
                      flex: 3,
                      child:
                          Container(color: Colors.yellow, child: _mobileView),
                    ),
                    Expanded(flex: 1, child: Container(color: Colors.black)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

//**************  homeMobileView **************************/
Widget homeMobileView(
  BuildContext context, {
  required AsyncValue<RoutineHome> homeRoutines,
  required WidgetRef ref,
  required ScrollController scrollController,
  required homeRoutineNotifier,
}) {
  print('homeMobileView');
  //
  return NotificationListener<ScrollNotification>(
    // hide bottom nav bar on scroll
    onNotification: (scrollNotification) =>
        Utils.hideNevBarOnScroll(scrollNotification, ref),
    child: RefreshIndicator(
      onRefresh: () async {
        final bool isOnline = await Utils.isOnlineMethod();
        if (!isOnline) {
          Alert.showSnackBar(context, 'You are in offline mode');
        } else {
          //! provider

          ref.refresh(homeRoutineControllerProvider(null));
          ref.refresh(recentNoticeController(null));
        }
      },
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: 100),
        controller: scrollController,
        children: [
          if (Responsive.isMobile(context)) const CustomTitleBar("title"),

          //_______________________ recent notices _________________//
          const HomeRecentNoticeWidget(),
          // // uploaded Routine
          homeRoutines.when(
              data: (data) {
                // void scrollListener() {
                //   if (scrollController.position.pixels ==
                //       scrollController.position.maxScrollExtent) {
                //     print('end.........................');
                //     ref
                //         .watch(homeRoutineControllerProvider(null).notifier)
                //         .loadMore(data.currentPage);
                //   }
                // }

                // scrollController.addListener(scrollListener);

                if (data.homeRoutines.isEmpty) {
                  return SizedBox(
                    height: 400,
                    child: Center(
                        child: Text(
                      "You Don't have joined or created any Routines",
                      style: TS.heading(fontSize: 16),
                    )),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: data.homeRoutines.length,
                    itemBuilder: (context, index) {
                      return RoutineBoxById(
                        routineId: data.homeRoutines[index].id,
                        rutinName: data.homeRoutines[index].routineName,
                        onTapMore: () =>
                            RoutineDialog.CheckStatusUser_BottomSheet(
                          context,
                          routineID: data.homeRoutines[index].id,
                          routineName: data.homeRoutines[index].routineName,
                          routinesController: homeRoutineNotifier,
                        ),
                      );
                    },
                  );
                }
              },
              loading: () => RUTINE_BOX_SKELTON,
              error: (error, stackTrace) {
                return Alert.handleError(
                  context,
                  error,
                  child: SizedBox(
                    height: 400,
                    child: ErrorScreen(
                      error: error.toString(),
                    ),
                  ),
                );
              }),

          //
        ],
      ),
    ),
  );
}

class HomeRecentNoticeWidget extends ConsumerWidget {
  const HomeRecentNoticeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('HomeRecentNoticeWidget');
    final recentNoticeList = ref.watch(recentNoticeController(null));

    return Column(
      children: [
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
                ukey: 'Home Recent Notice',
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
              return Alert.handleError(context, error);
            },
            loading: () => const RecentNoticeSliderSkelton(),
          ),
        ),

        //
        const SizedBox(height: 10),
      ],
    );
  }
}
