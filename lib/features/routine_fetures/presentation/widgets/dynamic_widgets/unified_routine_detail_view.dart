import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/class_details_model.dart';
import '../../providers/chack_status_controller.dart';
import '../../screens/class_routine/add_class_screen.dart';
import '../../screens/exam_routine/create_exam_screen.dart';
import 'package:classmate/features/notice_fetures/presentation/widgets/static_widgets/custom_share_bottom_sheet.dart';
import 'package:classmate/features/routine_summary_fetures/presentation/screens/summary_screen.dart';
import 'routine_theme.dart';
import 'routine_header_banner.dart';
import 'routine_tab_bar.dart';
import '../../screens/routine/tab_items/export_tab_items.dart';
import 'routine_options_card.dart';
import 'routine_bottom_bar.dart';
import '../../screens/routine/routine_details_screen.dart';

class UnifiedRoutineDetailView extends ConsumerWidget {
  final AllClassesResponse data;
  final String routineId;
  final String routineName;
  final bool isOwnerOrCaptain;

  const UnifiedRoutineDetailView({
    super.key,
    required this.data,
    required this.routineId,
    required this.routineName,
    required this.isOwnerOrCaptain,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExam = data.routineType.toUpperCase() == "EXAM";
    final theme = RoutineTheme.of(isExam);
    final activeTab = ref.watch(mainDetailTabProvider);
    final selectedDayIndex = ref.watch(selectedWeekdayIndexProvider);
    final checkStatus = ref.watch(checkStatusControllerProvider(routineId));
    final statusData = checkStatus.value;

    final String ownerName =
        (data.owner.name != null && data.owner.name!.isNotEmpty)
            ? data.owner.name!
            : (data.owner.username != null && data.owner.username!.isNotEmpty
                ? data.owner.username!
                : "Routine Creator");

    final String displayTitle =
        routineName.isNotEmpty
            ? routineName
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
                      canModify: isOwnerOrCaptain,
                      onAddExamPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => CreateExamScreen(
                                  routineId: routineId,
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
                      canModify: isOwnerOrCaptain,
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
                                    AddClassScreen(routineId: routineId),
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 24),

                  // 4. ADDITIONAL OPTIONS CARD (About, Instructions, Discussion)
                  RoutineOptionsCard(
                    theme: theme,
                    routineDescription: data.routineName,
                    routineId: routineId,
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
                                        : routineId,
                                routineID: routineId,
                                className: displayTitle,
                                subjectCode: "ROUTINE",
                              ),
                        ),
                      );
                    },
                  ),
                ] else if (activeTab == 1) ...[
                  MemberListTabView(routineId: routineId),
                ] else if (activeTab == 2) ...[
                  JoinRequestTabView(routineID: routineId),
                ] else if (activeTab == 3) ...[
                  RoutineSettingsTabView(
                    theme: theme,
                    routineId: routineId,
                    isOwnerOrCaptain: isOwnerOrCaptain,
                  ),
                ],

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),

        // 5. BOTTOM NAVIGATION BAR (Share Routine + Notify Me)
        RoutineBottomBar(
          theme: theme,
          onSharePressed: () {
            CustomShareButton.show(
              context,
              "https://classmaster.top/routine?routineId=$routineId",
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
