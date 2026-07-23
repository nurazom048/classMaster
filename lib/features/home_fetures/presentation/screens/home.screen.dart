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
import '../../../routine/presentation/providers/routine_list_provider.dart';
import '../../../../features/notice_fetures/presentation/widgets/static_widgets/modern_reusable_notice_card_widget.dart';
import '../../../../features/notice_fetures/data/models/recent_notice_model.dart';
import '../../../../core/constant/app_color.dart';
import '../../../../route/app_router.dart';
import 'package:classmate/core/widgets/widgets/recent_notice_title.dart';
import 'package:classmate/core/widgets/widgets/recent_notice_slider_skeleton.dart';
import 'package:classmate/core/widgets/widgets/promo_ad_widget.dart';

// =====================================================================
// 🏠 MAIN SCREEN: HOME SCREEN STATEFUL WIDGET
// =====================================================================
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late ScrollController _mainScrollController;
  bool isGuestMode = false;

  @override
  void initState() {
    super.initState();
    _mainScrollController = ScrollController();
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
    _mainScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 650; // Mobile breakpoint (aligned with Responsive)

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      // 🏷️ Custom Title Bar (Always on top inside main content column)
      appBar: const CustomTitleBar("Home"),
      body: NotificationListener<ScrollNotification>(
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
          // 📜 Scrollbar wrapped list for desktop/web scrolling ease
          child: Scrollbar(
            controller: _mainScrollController,
            thumbVisibility: !isMobile, // Keep scrollbar visible on desktop/tablet
            trackVisibility: !isMobile,
            child: ListView(
              controller: _mainScrollController,
              padding: const EdgeInsets.only(bottom: 120),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                // 🎫 Guest Mode Banner (if active)
                GuestModeBanner(isGuestMode: isGuestMode),

                // =====================================================================
                // 📰 SECTION: RECENT NOTICES
                // =====================================================================
                const SizedBox(height: 12),
                const RecentNoticeSectionHeader(),
                const SizedBox(height: 8),
                const HomeRecentNoticeWidget(),

                const SizedBox(height: 24),

                // =====================================================================
                // 📅 SECTION: ROUTINES
                // =====================================================================
                const RoutinesSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// 🎫 CUSTOM SUB-WIDGET: GUEST MODE BANNER
// =====================================================================
class GuestModeBanner extends StatelessWidget {
  final bool isGuestMode;

  const GuestModeBanner({
    super.key,
    required this.isGuestMode,
  });

  @override
  Widget build(BuildContext context) {
    if (!isGuestMode) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16.0),
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
                  .heading(fontSize: 13)
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
}

// =====================================================================
// 🎫 CUSTOM SUB-WIDGET: RECENT NOTICE SECTION HEADER
// =====================================================================
class RecentNoticeSectionHeader extends StatelessWidget {
  const RecentNoticeSectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Recent Notices",
            style: TS.heading(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                RightToLeftTransition(page: const ViewAllRecentNotice()),
              );
            },
            child: Row(
              children: [
                Text(
                  "View More",
                  style: TextStyle(
                    color: AppColor.nokiaBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(Icons.arrow_forward_ios, size: 10, color: AppColor.nokiaBlue),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// 📰 CUSTOM SUB-WIDGET: RECENT NOTICE CONTROLLER WIDGET
// =====================================================================
class HomeRecentNoticeWidget extends ConsumerWidget {
  const HomeRecentNoticeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentNoticeList = ref.watch(recentNoticeController(null));
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 650; // Match mobile view standard breakpoint

    final showAd = ref.watch(showAdProvider);

    return recentNoticeList.when(
      data: (data) {
        final noticesLimit = showAd ? 4 : 6;
        final notices = isMobile
            ? data.notices.take(6).toList()
            : data.notices.take(noticesLimit).toList();

        if (notices.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40.0),
              child: Text(
                "No recent notices available",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          );
        }

        if (isMobile) {
          // 📱 Mobile View: Swipeable Carousel (2 stacked items per slide)
          return MobileNoticeCarousel(notices: notices);
        } else {
          // 💻 Desktop/Tablet View: Responsive Grid
          return DesktopNoticeGrid(notices: notices);
        }
      },
      error: (error, stackTrace) {
        debugPrint('❌ Error loading recent notices: $error');
        return Alert.handleError(context, error);
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: RecentNoticeSliderSkelton(),
      ),
    );
  }
}

// =====================================================================
// 📱 CUSTOM SUB-WIDGET: MOBILE CAROUSEL SLIDER (2 notices stacked/slide)
// =====================================================================
class MobileNoticeCarousel extends StatefulWidget {
  final List<Notice> notices;
  const MobileNoticeCarousel({super.key, required this.notices});

  @override
  State<MobileNoticeCarousel> createState() => _MobileNoticeCarouselState();
}

class _MobileNoticeCarouselState extends State<MobileNoticeCarousel> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // 0.9 viewportFraction lets adjacent cards peek through horizontally
    _pageController = PageController(viewportFraction: 0.9);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Group notices by pairs (2 per slide)
    final int pageCount = (widget.notices.length / 2).ceil();

    return Column(
      children: [
        SizedBox(
          height: 236, // Fits 2 stacked PremiumNoticeCard widgets nicely
          child: PageView.builder(
            controller: _pageController,
            itemCount: pageCount,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, pageIndex) {
              final firstIndex = pageIndex * 2;
              final secondIndex = pageIndex * 2 + 1;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (firstIndex < widget.notices.length)
                    PremiumNoticeCard(
                      notice: widget.notices[firstIndex],
                      academyID: widget.notices[firstIndex].publisherId,
                      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      onTap: () {
                        context.push(
                          '/notice/${widget.notices[firstIndex].id}',
                          extra: ViewNoticeExtraData(
                            id: widget.notices[firstIndex].id,
                            notice: widget.notices[firstIndex],
                            accountModel: widget.notices[firstIndex].account,
                          ),
                        );
                      },
                      onLongPress: () {},
                    ),
                  if (secondIndex < widget.notices.length)
                    PremiumNoticeCard(
                      notice: widget.notices[secondIndex],
                      academyID: widget.notices[secondIndex].publisherId,
                      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      onTap: () {
                        context.push(
                          '/notice/${widget.notices[secondIndex].id}',
                          extra: ViewNoticeExtraData(
                            id: widget.notices[secondIndex].id,
                            notice: widget.notices[secondIndex],
                            accountModel: widget.notices[secondIndex].account,
                          ),
                        );
                      },
                      onLongPress: () {},
                    ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        // Indicator Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            pageCount,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 14 : 7,
              height: 7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: _currentPage == index ? AppColor.nokiaBlue : Colors.grey.shade300,
                boxShadow: _currentPage == index
                    ? [
                        BoxShadow(
                          color: AppColor.nokiaBlue.withOpacity(0.3),
                          blurRadius: 4,
                          spreadRadius: 1,
                        )
                      ]
                    : [],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =====================================================================
// 💻 CUSTOM SUB-WIDGET: DESKTOP/TABLET GRID (Max 6 notices)
// =====================================================================
class DesktopNoticeGrid extends StatelessWidget {
  final List<Notice> notices;
  const DesktopNoticeGrid({super.key, required this.notices});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: notices.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: width >= 1200 ? 420 : 500,
          mainAxisExtent: 110,
          crossAxisSpacing: 16,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          final notice = notices[index];
          return PremiumNoticeCard(
            notice: notice,
            academyID: notice.publisherId,
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            onLongPress: () {},
          );
        },
      ),
    );
  }
}

// =====================================================================
// 📅 CUSTOM SUB-WIDGET: ROUTINES SECTION
// =====================================================================
class RoutinesSection extends ConsumerStatefulWidget {
  const RoutinesSection({super.key});

  @override
  ConsumerState<RoutinesSection> createState() => _RoutinesSectionState();
}

class _RoutinesSectionState extends ConsumerState<RoutinesSection> {
  bool _showAllRoutines = false;

  @override
  Widget build(BuildContext context) {
    final homeRoutines = ref.watch(routineListProvider(const RoutineListQuery()));
    final homeRoutinesNotifier = ref.watch(routineListProvider(const RoutineListQuery()).notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Routines Header Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Routines",
                style: TS.heading(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _showAllRoutines = !_showAllRoutines;
                  });
                },
                child: Text(
                  _showAllRoutines ? "Show Less" : "View All Routine",
                  style: TextStyle(
                    color: AppColor.nokiaBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Routine List Body
        homeRoutines.when(
          data: (data) {
            if (data.routines.isEmpty) {
              return SizedBox(
                height: 200,
                child: Center(
                  child: Text(
                    "You don't have joined or created any Routines",
                    style: TS.heading(fontSize: 15, color: Colors.grey.shade500),
                  ),
                ),
              );
            } else {
              final showAd = ref.watch(showAdProvider);
              final width = MediaQuery.of(context).size.width;
              final isMobile = width < 650;
              final int crossAxisCount = isMobile ? 1 : (width < 1100 ? 2 : (showAd ? 2 : 3));
              final int routinesLimit = isMobile ? 4 : (crossAxisCount * 2);

              final routinesList = _showAllRoutines 
                  ? data.routines 
                  : data.routines.take(routinesLimit).toList();

              return Column(
                children: [
                  isMobile
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: routinesList.length,
                          itemBuilder: (context, index) {
                            final routine = routinesList[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: RoutineBoxById(
                                routineId: routine.id,
                                routineName: routine.routineName,
                                onTapMore: () => RoutineDialog.CheckStatusUser_BottomSheet(
                                  context,
                                  routineID: routine.id,
                                  routineName: routine.routineName,
                                  routinesController: homeRoutinesNotifier,
                                ),
                              ),
                            );
                          },
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: routinesList.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              mainAxisExtent: 430,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 12,
                            ),
                            itemBuilder: (context, index) {
                              final routine = routinesList[index];
                              return RoutineBoxById(
                                margin: EdgeInsets.zero,
                                routineId: routine.id,
                                routineName: routine.routineName,
                                onTapMore: () => RoutineDialog.CheckStatusUser_BottomSheet(
                                  context,
                                  routineID: routine.id,
                                  routineName: routine.routineName,
                                  routinesController: homeRoutinesNotifier,
                                ),
                              );
                            },
                          ),
                        ),
                  // "Load More" Button at the bottom (shows only if routines exceed limit and not showing all)
                  if (data.routines.length > routinesLimit && !_showAllRoutines)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _showAllRoutines = true;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColor.nokiaBlue,
                            side: BorderSide(color: AppColor.nokiaBlue.withOpacity(0.5)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.expand_more, size: 18),
                          label: const Text("Load More Routines", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                ],
              );
            }
          },
          loading: () => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ROUTINE_BOX_SKELTON,
          ),
          error: (error, stackTrace) {
            return Alert.handleError(
              context,
              error,
              child: SizedBox(
                height: 300,
                child: ErrorScreen(error: error.toString()),
              ),
            );
          },
        ),
      ],
    );
  }
}
