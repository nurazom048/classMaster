// ignore_for_file: avoid_print, unused_local_variable, use_build_context_synchronously, unused_result

import 'package:classmate/features/routine_summary_fetures/presentation/socket_services/socketCon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:classmate/features/home_fetures/presentation/utils/utils.dart';
import 'package:classmate/features/routine/presentation/providers/routine_details.controller.dart';
import 'package:classmate/features/routine/data/datasources/routine_req.dart';
import '../../providers/chack_status_controller.dart';
import '../../../../../core/export_core.dart';
import '../../../../../core/local_data/local_data.dart';
import '../../../../../route/route_constant.dart';
import '../../../../routine_summary_fetures/presentation/screens/summary_screen.dart';
import '../routine/member_list.dart';
import '../../../data/models/class_details_model.dart';
import 'package:classmate/features/notice_fetures/presentation/widgets/static_widgets/custom_share_bottom_sheet.dart';
import '../../utils/long_press.dart';
import '../exam_routine/exam_routine_detail_view.dart';
import '../exam_routine/create_exam_screen.dart';
import '../../widgets/dynamic_widgets/routine_footer.dart';
import 'package:classmate/ui/bottom_nevbar_items/bottom_navbar.dart';
import 'package:classmate/core/constant/enums.dart';
import 'package:classmate/core/component/heder_component/transition/right_to_left_transition.dart';

typedef ViewMore = ClassListPage;

final totalClassCountProvider = StateProvider.autoDispose<int>((ref) => 0);
final mainDetailTabProvider = StateProvider.autoDispose<int>((ref) => 0);
final selectedWeekdayIndexProvider = StateProvider.autoDispose<int>((ref) {
  // Default to today's weekday index: 0=Sun, 1=Mon, 2=Tue, 3=Wed, 4=Thu, 5=Fri, 6=Sat
  return DateTime.now().weekday % 7;
});

class ClassListPage extends ConsumerStatefulWidget {
  final String routineId;
  final String routineName;

  const ClassListPage({
    super.key,
    required this.routineId,
    required this.routineName,
  });

  @override
  ConsumerState<ClassListPage> createState() => _ClassListPageState();
}

class _ClassListPageState extends ConsumerState<ClassListPage> {
  void _navigateToShellPage(Widget page, bool isMobile, DrawerItem drawerItem) {
    if (isMobile) Navigator.pop(context);
    ref.read(drawerActiveItemProvider.notifier).state = drawerItem;
    ref.read(bottomNavBarIndexProvider.notifier).state = 2;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      collectionNavigatorKey.currentState?.popUntil((route) => route.isFirst);
      collectionNavigatorKey.currentState?.push(
        RightToLeftTransition(page: page),
      );
    });
  }

  Future<void> _handleBackNavigation() async {
    final String? token = await LocalData.getAuthToken();
    final bool hasToken = token != null && token.isNotEmpty;

    if (!mounted) return;

    if (hasToken) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        context.go('/home');
      }
    } else {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        context.go('/auth/login');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeSocket();
  }

  Future<void> _initializeSocket() async {
    try {
      await SocketService.initializeSocket();
      print('Socket initialized for routine ${widget.routineId}');

      SocketService.socket.onConnect((_) {
        print(
          '✅ Connected to Socket.IO server for routine ${widget.routineId}',
        );
      });

      SocketService.socket.onDisconnect((_) {
        print('❌ Disconnected from server for routine ${widget.routineId}');
      });
    } catch (e) {
      print('Socket initialization error: $e');
      if (mounted) {
        Alert.showSnackBar(context, 'Failed to connect to live updates');
      }
    }
  }

  @override
  void dispose() {
    SocketService.disconnect();
    print('Socket disconnected and cleaned up');
    super.dispose();
  }

  List<Day> _getClassesForDay(Classes weekdayClasses, int dayIndex) {
    switch (dayIndex) {
      case 0:
        return weekdayClasses.sunday;
      case 1:
        return weekdayClasses.monday;
      case 2:
        return weekdayClasses.tuesday;
      case 3:
        return weekdayClasses.wednesday;
      case 4:
        return weekdayClasses.thursday;
      case 5:
        return weekdayClasses.friday;
      case 6:
        return weekdayClasses.saturday;
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return DesktopLayoutWrapper(
      child: Consumer(
        builder: (context, ref, _) {
          final scaffoldKey = GlobalKey<ScaffoldState>();
          final routineDetails = ref.watch(
            routineDetailsProvider(widget.routineId),
          );
          final checkStatus = ref.watch(
            checkStatusControllerProvider(widget.routineId),
          );
          final selectedDayIndex = ref.watch(selectedWeekdayIndexProvider);

          return Scaffold(
            key: scaffoldKey,
            backgroundColor: const Color(0xFFF8FAFC),
            body: RefreshIndicator(
              onRefresh: () async {
                final bool isOnline = await Utils.isOnlineMethod();
                if (!isOnline) {
                  Alert.showSnackBar(context, 'You are in offline mode');
                } else {
                  ref.refresh(routineDetailsProvider(widget.routineId));
                  ref.refresh(checkStatusControllerProvider(widget.routineId));
                }
              },
              child: routineDetails.when(
                data: (data) {
                  final isExam = data.routineType.toUpperCase() == "EXAM";
                  final statusData = checkStatus.value;
                  final canModify =
                      statusData?.isOwner == true ||
                      statusData?.isCaptain == true;

                  final String displayRoutineName = widget.routineName.isNotEmpty
                      ? widget.routineName
                      : ((data.routineName != null && data.routineName!.isNotEmpty)
                          ? data.routineName!
                          : (isExam ? "Exam Routine" : "Class Routine"));

                  // CLASS ROUTINE DESIGN MATCHING MOCKUP (IMAGE 1)
                  final daysList = [
                    'Sun',
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                  ];
                  final fullDaysList = [
                    'Sunday',
                    'Monday',
                    'Tuesday',
                    'Wednesday',
                    'Thursday',
                    'Friday',
                    'Saturday',
                  ];
                  final todayIndex = DateTime.now().weekday % 7;
                  final isSelectedDayToday = selectedDayIndex == todayIndex;

                  final dayClasses = _getClassesForDay(
                    data.weekdayClasses,
                    selectedDayIndex,
                  );

                  return ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    children: [
                      // 0. TOP NAVIGATION BAR (Matching Image 1)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: _handleBackNavigation,
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Color(0xFF0F172A),
                              size: 20,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  final controller = ref.read(
                                    checkStatusControllerProvider(
                                      widget.routineId,
                                    ).notifier,
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
                                          ? const Color(0xFF2563EB)
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
                                  size: 22,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // 2. ROUTINE INFO HEADER CARD (Only for Class Routine)
                      if (!isExam) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEFF6FF),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.calendar_month_rounded,
                                      color: Color(0xFF2563EB),
                                      size: 26,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFEFF6FF),
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: const Text(
                                            "Class Routine",
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF2563EB),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          displayRoutineName,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF0F172A),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text(
                                              data.owner.name ?? "",
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF475569),
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            const Icon(
                                              Icons.verified,
                                              color: Color(0xFF2563EB),
                                              size: 15,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "This routine is for ${widget.routineName} students.",
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // 3-TAB SELECTOR CARD (Class List | Members | Join Req)
                        Consumer(
                          builder: (context, ref, _) {
                            final activeTab = ref.watch(mainDetailTabProvider);

                            return Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  // TAB 0: Class List
                                  Expanded(
                                    child: InkWell(
                                      onTap:
                                          () =>
                                              ref
                                                  .read(
                                                    mainDetailTabProvider
                                                        .notifier,
                                                  )
                                                  .state = 0,
                                      borderRadius: BorderRadius.circular(12),
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 180,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              activeTab == 0
                                                  ? Colors.white
                                                  : Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          boxShadow:
                                              activeTab == 0
                                                  ? [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.04),
                                                      blurRadius: 4,
                                                      offset: const Offset(
                                                        0,
                                                        2,
                                                      ),
                                                    ),
                                                  ]
                                                  : [],
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.class_outlined,
                                                  size: 16,
                                                  color:
                                                      activeTab == 0
                                                          ? const Color(
                                                            0xFF2563EB,
                                                          )
                                                          : const Color(
                                                            0xFF64748B,
                                                          ),
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  "Class List",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        activeTab == 0
                                                            ? FontWeight.bold
                                                            : FontWeight.w600,
                                                    color:
                                                        activeTab == 0
                                                            ? const Color(
                                                              0xFF2563EB,
                                                            )
                                                            : const Color(
                                                              0xFF64748B,
                                                            ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              "${data.allClass.length} Classes",
                                              style: TextStyle(
                                                fontSize: 10,
                                                color:
                                                    activeTab == 0
                                                        ? const Color(0xFF2563EB)
                                                        : const Color(0xFF94A3B8),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  // TAB 1: Members
                                  Expanded(
                                    child: InkWell(
                                      onTap:
                                          () =>
                                              ref
                                                  .read(
                                                    mainDetailTabProvider
                                                        .notifier,
                                                  )
                                                  .state = 1,
                                      borderRadius: BorderRadius.circular(12),
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 180,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              activeTab == 1
                                                  ? Colors.white
                                                  : Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          boxShadow:
                                              activeTab == 1
                                                  ? [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.04),
                                                      blurRadius: 4,
                                                      offset: const Offset(
                                                        0,
                                                        2,
                                                      ),
                                                    ),
                                                  ]
                                                  : [],
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.people_outline,
                                                  size: 16,
                                                  color:
                                                      activeTab == 1
                                                          ? const Color(
                                                            0xFF2563EB,
                                                          )
                                                          : const Color(
                                                            0xFF64748B,
                                                          ),
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  "Members",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        activeTab == 1
                                                            ? FontWeight.bold
                                                            : FontWeight.w600,
                                                    color:
                                                        activeTab == 1
                                                            ? const Color(
                                                              0xFF2563EB,
                                                            )
                                                            : const Color(
                                                              0xFF64748B,
                                                            ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              "${statusData?.memberCount ?? 0} Students",
                                              style: TextStyle(
                                                fontSize: 10,
                                                color:
                                                    activeTab == 1
                                                        ? const Color(0xFF2563EB)
                                                        : const Color(0xFF94A3B8),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  // TAB 2: Join Req
                                  Expanded(
                                    child: InkWell(
                                      onTap:
                                          () =>
                                              ref
                                                  .read(
                                                    mainDetailTabProvider
                                                        .notifier,
                                                  )
                                                  .state = 2,
                                      borderRadius: BorderRadius.circular(12),
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 180,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              activeTab == 2
                                                  ? Colors.white
                                                  : Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          boxShadow:
                                              activeTab == 2
                                                  ? [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.04),
                                                      blurRadius: 4,
                                                      offset: const Offset(
                                                        0,
                                                        2,
                                                      ),
                                                    ),
                                                  ]
                                                  : [],
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.person_add_alt_1_outlined,
                                                  size: 16,
                                                  color:
                                                      activeTab == 2
                                                          ? const Color(
                                                            0xFF2563EB,
                                                          )
                                                          : const Color(
                                                            0xFF64748B,
                                                          ),
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  "Join Req",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        activeTab == 2
                                                            ? FontWeight.bold
                                                            : FontWeight.w600,
                                                    color:
                                                        activeTab == 2
                                                            ? const Color(
                                                              0xFF2563EB,
                                                            )
                                                            : const Color(
                                                              0xFF64748B,
                                                            ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              "${statusData?.sentRequestCount ?? 0} Requests",
                                              style: TextStyle(
                                                fontSize: 10,
                                                color:
                                                    activeTab == 2
                                                        ? const Color(0xFF2563EB)
                                                        : const Color(0xFF94A3B8),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 14),
                      ],

                      const SizedBox(height: 16),

                      if (!isExam && ref.watch(mainDetailTabProvider) == 1) ...[
                        MemberList(routineId: widget.routineId),
                      ] else if (!isExam && ref.watch(mainDetailTabProvider) == 2) ...[
                        JoinRequestPart(routineID: widget.routineId),
                      ] else if (data.routineType.toUpperCase() == "EXAM") ...[
                        ExamRoutineDetailView(
                          data: data,
                          routineId: widget.routineId,
                          routineName: displayRoutineName,
                          isOwnerOrCaptain:
                              statusData?.isOwner == true ||
                              statusData?.isCaptain == true,
                        ),
                      ] else ...[
                        // 3. WEEKDAY SELECTOR BAR (Sun, Mon, Tue, Wed, Thu, Fri, Sat)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(7, (index) {
                            final isSelected = selectedDayIndex == index;
                            return InkWell(
                              onTap: () {
                                ref
                                    .read(selectedWeekdayIndexProvider.notifier)
                                    .state = index;
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? const Color(0xFF2563EB)
                                          : const Color(0xFFF1F5F9),
                                  shape: BoxShape.circle,
                                  boxShadow:
                                      isSelected
                                          ? [
                                            BoxShadow(
                                              color: const Color(
                                                0xFF2563EB,
                                              ).withOpacity(0.3),
                                              blurRadius: 6,
                                              offset: const Offset(0, 3),
                                            ),
                                          ]
                                          : [],
                                ),
                                child: Center(
                                  child: Text(
                                    daysList[index],
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight:
                                          isSelected
                                              ? FontWeight.bold
                                              : FontWeight.w600,
                                      color:
                                          isSelected
                                              ? Colors.white
                                              : const Color(0xFF64748B),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),

                        const SizedBox(height: 20),

                        // 4. SECTION HEADING (Today's Classes / Selected Day's Classes & Add Class Button)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time_rounded,
                                        color: Color(0xFF2563EB),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          isSelectedDayToday
                                              ? "Today's Classes"
                                              : "${fullDaysList[selectedDayIndex]}'s Classes",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF0F172A),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    DateFormat(
                                      "EEEE, d MMM yyyy",
                                    ).format(DateTime.now()),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF64748B),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (canModify) ...[
                              const SizedBox(width: 12),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2563EB),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 2,
                                  shadowColor: const Color(
                                    0xFF2563EB,
                                  ).withOpacity(0.3),
                                ),
                                onPressed: () {
                                  context.pushNamed(
                                    RouteConst.addClass,
                                    extra: false,
                                    params: {'routineId': widget.routineId},
                                  );
                                },
                                icon: const Icon(
                                  Icons.add_circle_outline_rounded,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  "Add Class",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),

                        const SizedBox(height: 14),

                        // 5. CLASSES LIST ITEMS WITH TIME STACKED ON LEFT COLUMN
                        if (dayClasses.isEmpty && data.allClass.isEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: const Center(
                              child: Text(
                                "No Class Created",
                                style: TextStyle(
                                  color: Color(0xFF64748B),
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          )
                        else if (dayClasses.isEmpty)
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: data.allClass.length,
                            itemBuilder: (context, index) {
                              final allClass = data.allClass[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: const Color(0xFFE2E8F0),
                                  ),
                                ),
                                child: InkWell(
                                  onLongPress: () {
                                    PeriodAlert.logPressClass(
                                      context,
                                      classId: allClass.id,
                                      routineId: widget.routineId,
                                    );
                                  },
                                  onTap:
                                      () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => SummaryScreen(
                                                classId: allClass.id,
                                                routineID: allClass.routineId,
                                                className: allClass.name,
                                                instructorName:
                                                    allClass.instructorName,
                                                subjectCode:
                                                    allClass.subjectCode,
                                              ),
                                        ),
                                      ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 38,
                                        height: 38,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFEFF6FF),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.class_rounded,
                                          color: Color(0xFF2563EB),
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Wrap(
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              spacing: 6,
                                              runSpacing: 4,
                                              children: [
                                                Text(
                                                  allClass.name,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF0F172A),
                                                  ),
                                                ),
                                                if (allClass
                                                    .subjectCode
                                                    .isNotEmpty)
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 6,
                                                          vertical: 2,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                        0xFFF1F5F9,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6,
                                                          ),
                                                      border: Border.all(
                                                        color: const Color(
                                                          0xFFE2E8F0,
                                                        ),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      allClass.subjectCode,
                                                      style: const TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Color(
                                                          0xFF475569,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            if (allClass
                                                .instructorName
                                                .isNotEmpty) ...[
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons
                                                        .person_outline_rounded,
                                                    size: 14,
                                                    color: Color(0xFF64748B),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Expanded(
                                                    child: Text(
                                                      allClass.instructorName,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Color(
                                                          0xFF475569,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      OutlinedButton.icon(
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 6,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          side: const BorderSide(
                                            color: Color(0xFF2563EB),
                                          ),
                                        ),
                                        onPressed:
                                            () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) => SummaryScreen(
                                                      classId: allClass.id,
                                                      routineID:
                                                          allClass.routineId,
                                                      className: allClass.name,
                                                      instructorName:
                                                          allClass
                                                              .instructorName,
                                                      subjectCode:
                                                          allClass.subjectCode,
                                                    ),
                                              ),
                                            ),
                                        icon: const Icon(
                                          Icons.chat_bubble_outline,
                                          size: 14,
                                          color: Color(0xFF2563EB),
                                        ),
                                        label: const Text(
                                          "Chat",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF2563EB),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        else
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: dayClasses.length,
                            itemBuilder: (context, index) {
                              final dayItem = dayClasses[index];
                              final startStr = DateFormat(
                                "hh:mm a",
                              ).format(dayItem.startTime);
                              final endStr = DateFormat(
                                "hh:mm a",
                              ).format(dayItem.endTime);

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: const Color(0xFFE2E8F0),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.02),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: InkWell(
                                  onLongPress: () {
                                    PeriodAlert.logPressClass(
                                      context,
                                      classId: dayItem.id,
                                      routineId: widget.routineId,
                                    );
                                  },
                                  onTap:
                                      () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => SummaryScreen(
                                                classId: dayItem.id,
                                                routineID: dayItem.routineId,
                                                className: dayItem.name,
                                                instructorName:
                                                    dayItem.instructorName,
                                                subjectCode:
                                                    dayItem.subjectCode,
                                              ),
                                        ),
                                      ),
                                  child: Row(
                                    children: [
                                      // LEFT COLUMN: START TIME & END TIME STACKED (IMAGE 1 & 2)
                                      SizedBox(
                                        width: 72,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              startStr,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF1E293B),
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              endStr,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF64748B),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),

                                      // MIDDLE CLOCK ICON
                                      Container(
                                        width: 38,
                                        height: 38,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFEFF6FF),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.access_time_rounded,
                                          color: Color(0xFF2563EB),
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),

                                      // CLASS DETAILS: NAME, SUBJECT CODE, INSTRUCTOR, ROOM
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Class Title & Subject Code Chip
                                            Wrap(
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              spacing: 6,
                                              runSpacing: 4,
                                              children: [
                                                Text(
                                                  dayItem.name,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF0F172A),
                                                  ),
                                                ),
                                                if (dayItem
                                                    .subjectCode
                                                    .isNotEmpty)
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 6,
                                                          vertical: 2,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                        0xFFF1F5F9,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6,
                                                          ),
                                                      border: Border.all(
                                                        color: const Color(
                                                          0xFFE2E8F0,
                                                        ),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      dayItem.subjectCode,
                                                      style: const TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Color(
                                                          0xFF475569,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),

                                            // Instructor Name
                                            if (dayItem
                                                .instructorName
                                                .isNotEmpty)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 4,
                                                ),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons
                                                          .person_outline_rounded,
                                                      size: 14,
                                                      color: Color(0xFF64748B),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Expanded(
                                                      child: Text(
                                                        dayItem.instructorName,
                                                        maxLines: 1,
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Color(
                                                            0xFF475569,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                            // Room Location Badge
                                            if (dayItem.room.isNotEmpty)
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFFEFF6FF,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Icon(
                                                      Icons
                                                          .location_on_outlined,
                                                      size: 12,
                                                      color: Color(0xFF2563EB),
                                                    ),
                                                    const SizedBox(width: 3),
                                                    Text(
                                                      "Room ${dayItem.room}",
                                                      style: const TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Color(
                                                          0xFF2563EB,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),

                                      // CHAT ACTION BUTTON
                                      OutlinedButton.icon(
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 6,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          side: const BorderSide(
                                            color: Color(0xFF2563EB),
                                          ),
                                        ),
                                        onPressed:
                                            () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) => SummaryScreen(
                                                      classId: dayItem.id,
                                                      routineID:
                                                          dayItem.routineId,
                                                      className: dayItem.name,
                                                      instructorName:
                                                          dayItem
                                                              .instructorName,
                                                      subjectCode:
                                                          dayItem.subjectCode,
                                                    ),
                                              ),
                                            ),
                                        icon: const Icon(
                                          Icons.chat_bubble_outline,
                                          size: 14,
                                          color: Color(0xFF2563EB),
                                        ),
                                        label: const Text(
                                          "Chat",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF2563EB),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                        const SizedBox(height: 16),

                        // ROUTINE FOOTER (About, Discussion, Share & Status Action)
                        RoutineFooter(
                          routineId: widget.routineId,
                          routineName: displayRoutineName,
                          isExam: isExam,
                        ),
                      ],
                      const SizedBox(height: 24),
                    ],
                  );
                },
                error: (error, stackTrace) {
                  Alert.handleError(context, error);
                  return ErrorScreen(error: error.toString());
                },
                loading: () => Loaders.center(),
              ),
            ),
          );
        },
      ),
    );
  }
}
