// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_result, use_build_context_synchronously, avoid_print

import 'package:classmate/core/component/heder_component/transition/right_to_left_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/local_data/local_data.dart';
import '../../../../route/route_constant.dart';
import 'package:go_router/go_router.dart';
import 'package:classmate/services/one_signal/one_signal.services.dart';
import 'package:classmate/features/routine/data/models/routine_response_model.dart';
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
import '../../../routine/presentation/utils/routine_dialog.dart';
import '../../../routine/presentation/widgets/dynamic_widgets/routine_box_by_id.dart';
import '../../../routine/presentation/widgets/static_widgets/routine_box_id_skeleton.dart';
import '../../../notice_fetures/presentation/providers/view_recent_notice_controller.dart';
import '../../../../core/widgets/widgets/custom_title_bar.dart';
import '../../../../core/widgets/widgets/slider/recent_notice_slider.dart';
import '../../../routine/presentation/providers/routine_list_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        debugPrint('🏠 HomeScreen rebuilding');

        final homeRoutines = ref.watch(
          routineListProvider(const RoutineListQuery()),
        );
        final homeRoutinesNotifier = ref.watch(
          routineListProvider(const RoutineListQuery()).notifier,
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
          // Mobile view
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
                          color: const Color(0xFFF5F5F5),
                          child: _mobileView,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(color: const Color(0xFFF5F5F5)),
                      ),
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

//============================================
// 📱 Mobile View Widget
//============================================
Widget homeMobileView(
  BuildContext context, {
  required AsyncValue<RoutineResponse> homeRoutines,
  required WidgetRef ref,
  required ScrollController scrollController,
  required homeRoutineNotifier,
  required bool isGuestMode,
}) {
  debugPrint('📱 homeMobileView rebuilding');

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
          ref.refresh(routineListProvider(const RoutineListQuery()));
          ref.refresh(recentNoticeController(null));
        }
      },
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: 100),
        controller: scrollController,
        children: [
          // Title Bar (Mobile only)
          if (Responsive.isMobile(context)) const CustomTitleBar("Home"),

          // Guest Mode Banner
          if (isGuestMode) _buildGuestModeBanner(context),

          // Recent Notices Section
          const HomeRecentNoticeWidget(),

          // Routines Section
          homeRoutines.when(
            data: (data) {
              if (data.routines.isEmpty) {
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
                  itemCount: data.routines.length,
                  itemBuilder: (context, index) {
                    return RoutineBoxById(
                      routineId: data.routines[index].id,
                      routineName: data.routines[index].routineName,
                      onTapMore:
                          () => RoutineDialog.CheckStatusUser_BottomSheet(
                            context,
                            routineID: data.routines[index].id,
                            routineName: data.routines[index].routineName,
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

//============================================
// 🎫 Guest Mode Banner
//============================================
Widget _buildGuestModeBanner(BuildContext context) {
  return Container(
    margin: const EdgeInsets.all(12.0),
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
        const Icon(Icons.info_outline, color: Colors.amberAccent, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            "You are exploring as a guest. Log in to access all features.",
            style: TS
                .heading(fontSize: 14)
                .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
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
  );
}

//============================================
// 📰 Home Recent Notice Widget
//============================================
class HomeRecentNoticeWidget extends ConsumerWidget {
  const HomeRecentNoticeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('📰 HomeRecentNoticeWidget rebuilding');
    final recentNoticeList = ref.watch(recentNoticeController(null));

    return Column(
      children: [
        RecentNoticeTitle(
          onTap: () {
            Navigator.push(
              context,
              RightToLeftTransition(page: const ViewAllRecentNotice()),
            );
          },
        ),
        SizedBox(
          height: 280, // Increased height for better spacing
          child: recentNoticeList.when(
            data: (data) {
              int length = data.notices.length;

              // 🔍 Return empty state if no notices
              if (length == 0) {
                return const Center(
                  child: Text(
                    "No recent notices available",
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return RecentNoticeSlider(
                ukey: 'Home Recent Notice',
                list: <Widget>[
                  // Slide 1: Index 0 & 1
                  RecentNoticeSliderItem(
                    notice: data.notices,
                    index: 0,
                    condition: length >= 2,
                    singleCondition: length == 1,
                    recentNotice: data,
                  ),
                  // Slide 2: Index 2 & 3
                  if (length > 2)
                    RecentNoticeSliderItem(
                      notice: data.notices,
                      index: 2,
                      condition: length >= 4,
                      singleCondition: length == 3,
                      recentNotice: data,
                    ),
                  // Slide 3: Index 4 & 5
                  if (length > 4)
                    RecentNoticeSliderItem(
                      notice: data.notices,
                      index: 4,
                      condition: length >= 6,
                      singleCondition: length == 5,
                      recentNotice: data,
                    ),
                ],
              );
            },
            error: (error, stackTrace) {
              debugPrint('❌ Error loading recent notices: $error');
              return Alert.handleError(context, error);
            },
            loading: () => const RecentNoticeSliderSkelton(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
