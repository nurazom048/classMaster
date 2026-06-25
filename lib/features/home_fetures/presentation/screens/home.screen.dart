// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_result, use_build_context_synchronously, avoid_print

import 'package:classmate/core/component/heder_component/transition/right_to_left_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/local_data/local_data.dart';
import '../../../../route/route_constant.dart';
import 'package:go_router/go_router.dart';
import 'package:classmate/services/one_signal/one_signal.services.dart';
import 'package:classmate/features/home_fetures/data/models/home_routines_model.dart';
import 'package:classmate/features/home_fetures/presentation/utils/utils.dart';
import 'package:classmate/core/widgets/widgets/mydrawer.dart';
import 'package:classmate/core/widgets/widgets/recent_notice_title.dart';
import 'package:classmate/core/widgets/widgets/recent_notice_slider_skeleton.dart';
import 'package:classmate/core/widgets/widgets/slider/recent_notice_slider_item.dart';
import '../../../../core/component/responsive.dart';
import '../../../../core/dialogs/alert_dialogs.dart';
import '../../../../core/widgets/appWidget/app_text.dart';
import '../../../../core/widgets/error/error.widget.dart';
import '../../../../services/firebase/firebase_analytics.service.dart';
import '../../../../services/notification_services/awn_package.dart';
import '../../../notice_fetures/presentation/screens/view_all_recent_notice.dart';
import '../../../routine_Fetures/presentation/utils/routine_dialog.dart';
import '../../../routine_Fetures/presentation/widgets/dynamic_widgets/routine_box_by_id.dart';
import '../../../routine_Fetures/presentation/widgets/static_widgets/routine_box_id_skeleton.dart';
import '../../../notice_fetures/presentation/providers/view_recent_notice_controller.dart';
import '../../../../core/widgets/widgets/custom_title_bar.dart';
import '../../../../core/widgets/widgets/slider/recent_notice_slider.dart';
import '../../data/datasources/home_routines_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController mobileScrollController;
  late ScrollController recentNoticeScrollController;
  bool isGuestMode = false;

  @override
  void initState() {
    super.initState();
    mobileScrollController = ScrollController();
    recentNoticeScrollController = ScrollController();
    _checkGuestMode();
    FirebaseAnalyticsServices.logHome();
    AwesomeNotificationSetup.takePermission(context);
  }

  void _checkGuestMode() async {
    final guest = await LocalData.isGuest();
    if (mounted) {
      setState(() {
        isGuestMode = guest;
      });
    }
  }

  @override
  void dispose() {
    recentNoticeScrollController.dispose();
    mobileScrollController.dispose();
    super.dispose();
  }

  final Widget homeRecentNoticeWidget = const HomeRecentNoticeWidget();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        print('HomeScreen');

        final homeRoutines = ref.watch(homeRoutineControllerProvider(null));
        final homeRoutinesNotifier = ref.watch(
          homeRoutineControllerProvider(null).notifier,
        );

        final _mobileView = homeMobileView(
          context,
          ref: ref,
          homeRoutines: homeRoutines,
          scrollController: mobileScrollController,
          homeRoutineNotifier: homeRoutinesNotifier,
          isGuestMode: isGuestMode,
        );

        return Responsive(
          // Mobile view - return plain widget without Scaffold
          mobile: _mobileView,

          // Desktop view
          desktop: Scaffold(
            body: Column(
              children: [
                const CustomTitleBar("Home"),
                Expanded(
                  child: Row(
                    children: [
                      const Expanded(flex: 1, child: MyDrawer()),
                      Expanded(
                        flex: 3,
                        child: Container(
                          color: Colors.yellow,
                          child: _mobileView,
                        ),
                      ),
                      Expanded(flex: 1, child: Container(color: Colors.black)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

//************** homeMobileView **************************/
Widget homeMobileView(
  BuildContext context, {
  required AsyncValue<RoutineHome> homeRoutines,
  required WidgetRef ref,
  required ScrollController scrollController,
  required homeRoutineNotifier,
  required bool isGuestMode,
}) {
  print('homeMobileView');
  return NotificationListener<ScrollNotification>(
    onNotification: (scrollNotification) {
      Utils.hideNevBarOnScroll(scrollNotification, ref);
      return false;
    },
    child: RefreshIndicator(
      onRefresh: () async {
        final bool isOnline = await Utils.isOnlineMethod();
        if (!isOnline) {
          Alert.showSnackBar(context, 'You are offline');
        } else {
          ref.refresh(homeRoutineControllerProvider(null));
          ref.refresh(recentNoticeController(null));
        }
      },
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: 100),
        controller: scrollController,
        children: [
          if (Responsive.isMobile(context)) const CustomTitleBar("Home"),

          if (isGuestMode)
            Container(
              margin: const EdgeInsets.all(12.0),
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF37474F), Color(0xFF263238)],
                ),
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Colors.amberAccent,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "You are exploring as a guest. Log in to access all features.",
                      style: TS
                          .heading(fontSize: 14)
                          .copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      await LocalData.emptyLocal();
                      context.goNamed(RouteConst.login);
                    },
                    child: const Text(
                      "LOG IN",
                      style: TextStyle(
                        color: Colors.amberAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          const HomeRecentNoticeWidget(),
          homeRoutines.when(
            data: (data) {
              if (data.homeRoutines.isEmpty) {
                return SizedBox(
                  height: 400,
                  child: Center(
                    child: Text(
                      "You Don't have joined or created any Routines",
                      style: TS.heading(fontSize: 16),
                    ),
                  ),
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
                      routineName: data.homeRoutines[index].routineName,
                      onTapMore:
                          () => RoutineDialog.CheckStatusUser_BottomSheet(
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
            loading: () => ROUTINE_BOX_SKELTON,
            error: (error, stackTrace) {
              return Alert.handleError(
                context,
                error,
                child: SizedBox(
                  height: 400,
                  child: ErrorScreen(error: error.toString()),
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}

class HomeRecentNoticeWidget extends ConsumerWidget {
  const HomeRecentNoticeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('HomeRecentNoticeWidget');
    final recentNoticeList = ref.watch(recentNoticeController(null));

    return Column(
      children: [
        RecentNoticeTitle(
          onTap: () {
            Navigator.push(
              context,
              RightToLeftTransition(page: ViewAllRecentNotice()),
            );
          },
        ),
        SizedBox(
          height: 160,
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
                  RecentNoticeSliderItem(
                    notice: data.notices,
                    index: 2,
                    condition: length >= 4,
                    singleCondition: length == 3,
                    recentNotice: data,
                  ),
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
        const SizedBox(height: 10),
      ],
    );
  }
}
