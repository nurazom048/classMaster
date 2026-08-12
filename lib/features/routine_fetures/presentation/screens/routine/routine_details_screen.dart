// ignore_for_file: avoid_print, unused_local_variable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:classmate/features/routine_summary_fetures/presentation/socket_services/socketCon.dart';
import 'package:classmate/features/home_fetures/presentation/utils/utils.dart';
import 'package:classmate/features/routine_fetures/presentation/providers/routine_details.controller.dart';
import '../../providers/chack_status_controller.dart';
import '../../../../../core/export_core.dart';
import '../../../../../core/local_data/local_data.dart';
import 'package:classmate/features/notice_fetures/presentation/widgets/static_widgets/custom_share_bottom_sheet.dart';
import 'package:classmate/features/routine_summary_fetures/presentation/screens/summary_screen.dart';
import 'package:classmate/ui/bottom_nevbar_items/bottom_navbar.dart';
import 'package:classmate/core/constant/enums.dart';
import 'package:classmate/core/component/heder_component/transition/right_to_left_transition.dart';

import '../../../data/models/class_details_model.dart';
import '../class_routine/add_class_screen.dart';
import '../exam_routine/create_exam_screen.dart';
import '../../widgets/dynamic_widgets/routine_theme.dart';
import '../../widgets/dynamic_widgets/routine_header_banner.dart';
import '../../widgets/dynamic_widgets/routine_tab_bar.dart';
import 'tab_items/export_tab_items.dart';
import '../../widgets/dynamic_widgets/routine_options_card.dart';
import '../../widgets/dynamic_widgets/routine_bottom_bar.dart';

final totalClassCountProvider = StateProvider.autoDispose<int>((ref) => 0);
final mainDetailTabProvider = StateProvider.autoDispose<int>((ref) => 0);
final selectedWeekdayIndexProvider = StateProvider.autoDispose<int>((ref) {
  return (DateTime.now().weekday + 1) % 7;
});

class RoutineDetailsScreen extends ConsumerStatefulWidget {
  final String routineId;
  final String routineName;
  final AllClassesResponse? data;
  final bool? isOwnerOrCaptain;

  const RoutineDetailsScreen({
    super.key,
    required this.routineId,
    this.routineName = '',
    this.data,
    this.isOwnerOrCaptain,
  });

  @override
  ConsumerState<RoutineDetailsScreen> createState() =>
      _RoutineDetailsScreenState();
}

class _RoutineDetailsScreenState extends ConsumerState<RoutineDetailsScreen> {
  @override
  void initState() {
    super.initState();
    _initializeSocket();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref
            .read(hideBottomNavBarProvider.notifier)
            .update((state) => state + 1);
      }
    });
  }

  Future<void> _initializeSocket() async {
    try {
      await SocketService.initializeSocket();
      print('Socket initialized for routine ${widget.routineId}');
    } catch (e) {
      print('Socket initialization error: $e');
    }
  }

  @override
  void dispose() {
    SocketService.disconnect();
    print('Socket disconnected and cleaned up');
    ref
        .read(hideBottomNavBarProvider.notifier)
        .update((state) => (state - 1).clamp(0, 999));
    super.dispose();
  }

  Future<void> _handleBackNavigation() async {
    final String? token = await LocalData.getAuthToken();
    final bool hasToken = token != null && token.isNotEmpty;

    if (!mounted) return;

    if (hasToken) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
        final navState = collectionNavigatorKey.currentState;
        if (navState != null && !navState.canPop()) {
          final prevIndex = ref.read(previousBottomNavBarIndexProvider);
          ref.read(bottomNavBarIndexProvider.notifier).state = prevIndex;
          if (prevIndex == 0) {
            ref.read(drawerActiveItemProvider.notifier).state = DrawerItem.home;
          }
        }
      } else {
        context.go('/home');
      }
    } else {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
        final navState = collectionNavigatorKey.currentState;
        if (navState != null && !navState.canPop()) {
          final prevIndex = ref.read(previousBottomNavBarIndexProvider);
          ref.read(bottomNavBarIndexProvider.notifier).state = prevIndex;
          if (prevIndex == 0) {
            ref.read(drawerActiveItemProvider.notifier).state = DrawerItem.home;
          }
        }
      } else {
        context.go('/auth/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data != null) {
      return DesktopLayoutWrapper(child: _buildScaffoldWithData(widget.data!));
    }

    final routineDetails = ref.watch(routineDetailsProvider(widget.routineId));

    return DesktopLayoutWrapper(
      child: routineDetails.when(
        data: (data) => _buildScaffoldWithData(data),
        loading:
            () => Scaffold(
              backgroundColor: const Color(0xFFF8FAFC),
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0.5,
                leading: IconButton(
                  onPressed: _handleBackNavigation,
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Color(0xFF0F172A),
                    size: 20,
                  ),
                ),
                title: Text(
                  widget.routineName.isNotEmpty
                      ? widget.routineName
                      : "Routine Details",
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
              ),
              body: const Center(child: CircularProgressIndicator()),
            ),
        error:
            (error, stack) => Scaffold(
              backgroundColor: const Color(0xFFF8FAFC),
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0.5,
                leading: IconButton(
                  onPressed: _handleBackNavigation,
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Color(0xFF0F172A),
                    size: 20,
                  ),
                ),
                title: const Text(
                  "Error Loading Routine",
                  style: TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
              ),
              body: Center(child: Text("Error: $error")),
            ),
      ),
    );
  }

  Widget _buildScaffoldWithData(AllClassesResponse data) {
    final checkStatus = ref.watch(
      checkStatusControllerProvider(widget.routineId),
    );
    final statusData = checkStatus.value;
    final isExam = data.routineType.toUpperCase() == "EXAM";
    final canModify =
        widget.isOwnerOrCaptain ??
        (statusData?.isOwner == true || statusData?.isCaptain == true);

    final String appBarTitle =
        widget.routineName.isNotEmpty
            ? widget.routineName
            : (isExam ? "Exam Routine Details" : "Class Routine Details");

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBackNavigation();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            onPressed: _handleBackNavigation,
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF0F172A),
              size: 20,
            ),
          ),
          title: Text(
            appBarTitle,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                final controller = ref.read(
                  checkStatusControllerProvider(widget.routineId).notifier,
                );
                final isSave = statusData?.isSave ?? false;
                controller.saveUnsaved(context, !isSave);
              },
              icon: Icon(
                (statusData?.isSave ?? false)
                    ? Icons.bookmark
                    : Icons.bookmark_border_rounded,
                color:
                    (statusData?.isSave ?? false)
                        ? (isExam
                            ? const Color(0xFF7C3AED)
                            : const Color(0xFF2563EB))
                        : const Color(0xFF0F172A),
                size: 24,
              ),
            ),
            IconButton(
              onPressed:
                  () => CustomShareButton.show(
                    context,
                    "https://classmaster.top/routine?routineId=${widget.routineId}",
                  ),
              icon: const Icon(
                Icons.ios_share_rounded,
                color: Color(0xFF0F172A),
                size: 20,
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            final bool isOnline = await Utils.isOnlineMethod();
            if (!isOnline) {
              Alert.showSnackBar(context, 'You are in offline mode');
            } else {
              ref.invalidate(routineDetailsProvider(widget.routineId));
              ref.invalidate(checkStatusControllerProvider(widget.routineId));
            }
          },
          child: _buildBodyContent(data, isExam, canModify, statusData),
        ),
      ),
    );
  }

  Widget _buildBodyContent(
    AllClassesResponse data,
    bool isExam,
    bool canModify,
    dynamic statusData,
  ) {
    final theme = RoutineTheme.of(isExam);
    final activeTab = ref.watch(mainDetailTabProvider);
    final selectedDayIndex = ref.watch(selectedWeekdayIndexProvider);

    final String ownerName =
        (data.owner.name != null && data.owner.name!.isNotEmpty)
            ? data.owner.name!
            : (data.owner.username != null && data.owner.username!.isNotEmpty
                ? data.owner.username!
                : "Routine Creator");

    final String displayTitle =
        widget.routineName.isNotEmpty
            ? widget.routineName
            : ((data.routineName != null && data.routineName!.isNotEmpty)
                ? data.routineName!
                : (isExam ? "Exam Routine" : "Class Routine"));

    final String displaySubtitle = isExam ? "Exam Details" : "Class Schedule";
    final String displayDescription =
        isExam
            ? "This is the exam routine for $displayTitle."
            : "This is the class routine for $displayTitle.";

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. HERO HEADER BANNER (Gradient, artwork, owner info)
                RoutineHeaderBanner(
                  theme: theme,
                  title: displayTitle,
                  subtitle: displaySubtitle,
                  ownerName: ownerName,
                  ownerAvatarUrl: data.owner.imageUrl,
                  description: displayDescription,
                ),

                const SizedBox(height: 16),

                // 2. 4-TAB NAVIGATION BAR
                RoutineTabBar(
                  theme: theme,
                  activeTab: activeTab,
                  mainItemCount:
                      isExam ? data.exams.length : data.allClass.length,
                  memberCount: statusData?.memberCount ?? 1,
                  requestCount: statusData?.sentRequestCount ?? 0,
                  onTabChanged: (index) {
                    ref.read(mainDetailTabProvider.notifier).state = index;
                  },
                ),

                const SizedBox(height: 20),

                // 3. ACTIVE TAB CONTENT
                if (activeTab == 0) ...[
                  if (isExam)
                    ExamListTabView(
                      theme: theme,
                      exams: data.exams,
                      canModify: canModify,
                      onAddExamPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => CreateExamScreen(
                                  routineId: widget.routineId,
                                  serialNumber: data.exams.length + 1,
                                ),
                          ),
                        );
                      },
                    )
                  else
                    ClassListTabView(
                      theme: theme,
                      weekdayClasses: data.weekdayClasses,
                      selectedDayIndex: selectedDayIndex,
                      canModify: canModify,
                      onDaySelected: (dayIdx) {
                        ref.read(selectedWeekdayIndexProvider.notifier).state =
                            dayIdx;
                      },
                      onAddClassPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    AddClassScreen(routineId: widget.routineId),
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 24),

                  // 4. ADDITIONAL OPTIONS CARD
                  RoutineOptionsCard(
                    theme: theme,
                    routineDescription: data.routineName,
                    routineId: widget.routineId,
                    displayTitle: displayTitle,
                    ownerName: ownerName,
                    about: data.about,
                    onDiscussionTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => SummaryScreen(
                                classId:
                                    data.allClass.isNotEmpty
                                        ? data.allClass.first.id
                                        : widget.routineId,
                                routineID: widget.routineId,
                                className: displayTitle,
                                subjectCode: "ROUTINE",
                              ),
                        ),
                      );
                    },
                  ),
                ] else if (activeTab == 1) ...[
                  MemberListTabView(routineId: widget.routineId),
                ] else if (activeTab == 2) ...[
                  JoinRequestTabView(routineID: widget.routineId),
                ] else if (activeTab == 3) ...[
                  RoutineSettingsTabView(
                    theme: theme,
                    routineId: widget.routineId,
                    isOwnerOrCaptain: canModify,
                  ),
                ],

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),

        // 5. BOTTOM NAVIGATION BAR
        RoutineBottomBar(
          theme: theme,
          onSharePressed: () {
            CustomShareButton.show(
              context,
              "https://classmaster.top/routine?routineId=${widget.routineId}",
            );
          },
          onNotifyPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Notifications enabled for $displayTitle!"),
                backgroundColor: theme.primaryColor,
              ),
            );
          },
        ),
      ],
    );
  }
}
