// ignore_for_file: deprecated_member_use, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:classmate/core/constant/app_color.dart';
import 'package:classmate/core/widgets/appWidget/app_text.dart';
import 'package:classmate/core/widgets/appWidget/dotted_divider.dart';
import 'package:classmate/core/dialogs/alert_dialogs.dart';

import '../../../data/models/class_details_model.dart';
import '../../providers/chack_status_controller.dart';
import '../../providers/routine_details.controller.dart';
import '../../screens/view_more_screen.dart';
import '../../utils/routine_dialog.dart';
import '../static_widgets/routine_box_id_skeleton.dart';
import '../../../../routine_summary_fetures/presentation/screens/summary_screen.dart';

// State Providers for Weekday and Expansion
final selectedExamIndexProvider = StateProvider.family<int, String>((ref, id) => 0);
final examIsExpandedProvider = StateProvider.family<bool, String>((ref, id) => false);
final classIsExpandedProvider = StateProvider.family<bool, String>((ref, id) => false);
final selectedWeekdayIndexProvider = StateProvider.family<int, String>((ref, id) {
  final int weekday = DateTime.now().weekday; // 1 = Mon ... 7 = Sun
  return weekday == 7 ? 0 : weekday; // Map Sunday to 0
});

/// =====================================================================
/// 🎯 POLYMORPHIC ROUTINE FEED CARD
/// Main parent card widget that inspects `routineType` and renders:
/// - Class Routine (Blue Theme + Weekday Strip)
/// - Exam Routine (Orange Theme + Numbered Exam List)
/// =====================================================================
class RoutineFeedCard extends ConsumerWidget {
  final String routineId;
  final String routineName;
  final String routineType; // "CLASS" or "EXAM"
  final VoidCallback onTapMore;
  final EdgeInsetsGeometry? margin;

  const RoutineFeedCard({
    super.key,
    required this.routineId,
    required this.routineName,
    this.routineType = "CLASS",
    required this.onTapMore,
    this.margin,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkStatus = ref.watch(checkStatusControllerProvider(routineId));
    final routineDetails = ref.watch(routineDetailsProvider(routineId));

    return Container(
      constraints: const BoxConstraints(minHeight: 380),
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // -----------------------------------------------------------------
          // 📌 HEADER SECTION
          // -----------------------------------------------------------------
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Routine Title
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewMore(
                                    routineId: routineId,
                                    routineName: routineName,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              routineName,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        // 3-dots popup menu
                        IconButton(
                          icon: const Icon(Icons.more_vert, color: Color(0xFF64748B), size: 20),
                          onPressed: onTapMore,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Routine Type Badge & Bell Icon Row
                    routineDetails.when(
                      data: (data) {
                        final isExam = (data.routineType.toUpperCase() == "EXAM") || (routineType.toUpperCase() == "EXAM");
                        final badgeColor = isExam ? const Color(0xFFFF5722) : const Color(0xFF0052CC);
                        final badgeLabel = isExam ? "Exam Routine" : "Class Routine";

                        return Row(
                          children: [
                            Text(
                              badgeLabel,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: badgeColor,
                              ),
                            ),
                            const SizedBox(width: 6),
                            // Notification bell status
                            checkStatus.when(
                              data: (statusData) {
                                return InkWell(
                                  onTap: () {
                                    RoutineDialog.routineNotificationsSelect(context, routineId);
                                  },
                                  child: Icon(
                                    statusData.notificationOn
                                        ? Icons.notifications_active_outlined
                                        : Icons.notifications_none_outlined,
                                    size: 16,
                                    color: statusData.notificationOn ? badgeColor : Colors.grey.shade500,
                                  ),
                                );
                              },
                              loading: () => const SizedBox.shrink(),
                              error: (_, __) => const SizedBox.shrink(),
                            ),
                          ],
                        );
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),

              // -----------------------------------------------------------------
              // 🔄 POLYMORPHIC FEED BODY
              // -----------------------------------------------------------------
              routineDetails.when(
                data: (data) {
                  final isExam = (data.routineType.toUpperCase() == "EXAM") || (routineType.toUpperCase() == "EXAM");
                  if (isExam) {
                    return ExamRoutineView(routineId: routineId, data: data);
                  } else {
                    return ClassRoutineView(routineId: routineId, data: data);
                  }
                },
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                ),
                error: (error, stack) => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Alert.handleError(context, error),
                ),
              ),
            ],
          ),

          // -----------------------------------------------------------------
          // 🏛️ FOOTER SECTION (Coaching Center / Owner Name + Verified Badge)
          // -----------------------------------------------------------------
          Column(
            children: [
              const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
              routineDetails.when(
                data: (data) {
                  final nameStr = data.owner.name;
                  return RoutineCardFooter(
                    ownerName: (nameStr != null && nameStr.isNotEmpty) ? nameStr : "ECH Coaching Center",
                    isVerified: true, // Show verified badge as in UI design
                    onTapMore: onTapMore,
                  );
                },
                loading: () => const AccountSkeleton(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// =====================================================================
/// 📘 CLASS ROUTINE VIEW (Blue Accent Theme + Weekday Selector Strip)
/// =====================================================================
class ClassRoutineView extends ConsumerWidget {
  final String routineId;
  final AllClassesResponse data;

  const ClassRoutineView({
    super.key,
    required this.routineId,
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDayIndex = ref.watch(selectedWeekdayIndexProvider(routineId));
    final isExpanded = ref.watch(classIsExpandedProvider(routineId));

    final weekdaysList = _getClassesForIndex(data.weekdayClasses, selectedDayIndex);
    final int displayCount = (isExpanded || weekdaysList.length <= 3) ? weekdaysList.length : 3;
    final int hiddenCount = weekdaysList.length - 3;

    return Column(
      children: [
        // 🗓️ Horizontal Weekday Strip
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (index) {
              final days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
              // Generate date numbers for sample strip
              final dateNum = 19 + index; 
              final isSelected = selectedDayIndex == index;

              return InkWell(
                onTap: () {
                  ref.read(selectedWeekdayIndexProvider(routineId).notifier).state = index;
                },
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Column(
                    children: [
                      Text(
                        days[index],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? const Color(0xFF0052CC) : const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? const Color(0xFF0052CC) : Colors.transparent,
                        ),
                        child: Text(
                          "$dateNum",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            color: isSelected ? Colors.white : const Color(0xFF1E293B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),

        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),

        // 🕒 Class Items List
        if (weekdaysList.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Text(
              "No classes scheduled for this day",
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayCount,
            separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF8FAFC)),
            itemBuilder: (context, index) {
              final item = weekdaysList[index];
              final startTimeStr = DateFormat.jm().format(item.startTime);
              final endTimeStr = DateFormat.jm().format(item.endTime);

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SummaryScreen(
                        classId: item.id,
                        className: item.name,
                        instructorName: item.instructorName,
                        routineID: item.routineId,
                        subjectCode: item.subjectCode,
                        startTime: item.startTime,
                        endTime: item.endTime,
                        room: item.room,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      // Clock Icon Badge
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEFF6FF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.access_time, color: Color(0xFF0052CC), size: 18),
                      ),
                      const SizedBox(width: 14),

                      // Class Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$startTimeStr - $endTimeStr",
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Room Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                item.room.isNotEmpty ? item.room : "Room N/A",
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0052CC),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF94A3B8)),
                    ],
                  ),
                ),
              );
            },
          ),

        // 🔽 Expansion Toggle Button (+ X More Classes)
        if (weekdaysList.length > 3)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: InkWell(
              onTap: () {
                ref.read(classIsExpandedProvider(routineId).notifier).state = !isExpanded;
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isExpanded ? "- Hide Classes" : "+ $hiddenCount More Classes",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0052CC),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    size: 16,
                    color: const Color(0xFF0052CC),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  List<Day> _getClassesForIndex(Classes weekdayClasses, int index) {
    switch (index) {
      case 0: return weekdayClasses.sunday;
      case 1: return weekdayClasses.monday;
      case 2: return weekdayClasses.tuesday;
      case 3: return weekdayClasses.wednesday;
      case 4: return weekdayClasses.thursday;
      case 5: return weekdayClasses.friday;
      case 6: return weekdayClasses.saturday;
      default: return [];
    }
  }
}

/// =====================================================================
/// 🟧 EXAM ROUTINE VIEW (Orange Accent Theme + Numbered Exam List)
/// =====================================================================
class ExamRoutineView extends ConsumerWidget {
  final String routineId;
  final AllClassesResponse data;

  const ExamRoutineView({
    super.key,
    required this.routineId,
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(examIsExpandedProvider(routineId));
    final examsList = data.exams;

    final int displayCount = (isExpanded || examsList.length <= 4) ? examsList.length : 4;
    final int hiddenCount = examsList.length - 4;

    if (examsList.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Text(
            "No exams scheduled yet",
            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
          ),
        ),
      );
    }

    return Column(
      children: [
        // 📋 Numbered Exam Items List
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: displayCount,
          separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF8FAFC)),
          itemBuilder: (context, index) {
            final exam = examsList[index];
            final dateStr = DateFormat("d MMM yyyy (E)").format(exam.date);
            final timeStr = "${DateFormat.jm().format(exam.startTime)} - ${DateFormat.jm().format(exam.endTime)}";

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // 1️⃣ Number Badge Container (Soft Orange Box)
                  Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "${index + 1}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF5722),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Exam Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exam.name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "$dateStr\n$timeStr",
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF64748B),
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Room Badge (Soft Orange Pill)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF3E0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            exam.room.isNotEmpty ? exam.room : "Room N/A",
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF5722),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF94A3B8)),
                ],
              ),
            );
          },
        ),

        // 🔽 Expansion Toggle Button (+ X More Exams)
        if (examsList.length > 4)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: InkWell(
              onTap: () {
                ref.read(examIsExpandedProvider(routineId).notifier).state = !isExpanded;
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isExpanded ? "- Hide Exams" : "+ $hiddenCount More Exams",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF5722),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    size: 16,
                    color: const Color(0xFFFF5722),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// =====================================================================
/// 🏛️ ROUTINE CARD FOOTER (Coaching Center Name + Verified Badge)
/// =====================================================================
class RoutineCardFooter extends StatelessWidget {
  final String ownerName;
  final bool isVerified;
  final VoidCallback onTapMore;

  const RoutineCardFooter({
    super.key,
    required this.ownerName,
    this.isVerified = true,
    required this.onTapMore,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.account_balance, size: 18, color: Color(0xFF0052CC)),
              const SizedBox(width: 8),
              Text(
                ownerName,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              if (isVerified) ...[
                const SizedBox(width: 4),
                const Icon(Icons.verified, size: 14, color: Color(0xFF0052CC)),
              ],
            ],
          ),
          InkWell(
            onTap: onTapMore,
            child: const Icon(Icons.more_vert, size: 18, color: Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }
}
