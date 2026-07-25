import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../../core/export_core.dart';
import '../../../data/models/class_details_model.dart';
import '../../../../routine_summary_fetures/presentation/screens/summary_screen.dart';
import '../../../../notice_fetures/presentation/widgets/static_widgets/custom_share_bottom_sheet.dart';
import 'create_exam_screen.dart';
import '../class_routine/class_list.dart';
import '../routine/member_list.dart';
import '../../providers/chack_status_controller.dart';
import '../../widgets/dynamic_widgets/routine_footer.dart';

class ExamRoutineDetailView extends ConsumerStatefulWidget {
  final AllClassesResponse data;
  final String routineId;
  final String routineName;
  final bool isOwnerOrCaptain;

  const ExamRoutineDetailView({
    super.key,
    required this.data,
    required this.routineId,
    required this.routineName,
    required this.isOwnerOrCaptain,
  });

  @override
  ConsumerState<ExamRoutineDetailView> createState() =>
      _ExamRoutineDetailViewState();
}

class _ExamRoutineDetailViewState extends ConsumerState<ExamRoutineDetailView> {
  bool _isExpanded = false;

  // Fallback demo exams if database exams array is empty
  List<ExamModel> _getExamsList() {
    if (widget.data.exams.isNotEmpty) {
      return widget.data.exams;
    }

    final now = DateTime.now();
    return [
      ExamModel(
        id: "demo_1",
        model_no: 1,
        name: "Bangla",
        subjectCode: "BAN-101",
        date: DateTime(now.year, now.month, now.day + 1),
        startTime: DateTime(now.year, now.month, now.day + 1, 8, 0),
        endTime: DateTime(now.year, now.month, now.day + 1, 9, 0),
        room: "Room 205",
        routineId: widget.routineId,
      ),
      ExamModel(
        id: "demo_2",
        model_no: 2,
        name: "English",
        subjectCode: "ENG-102",
        date: DateTime(now.year, now.month, now.day + 3),
        startTime: DateTime(now.year, now.month, now.day + 3, 10, 0),
        endTime: DateTime(now.year, now.month, now.day + 3, 11, 0),
        room: "Room 306",
        routineId: widget.routineId,
      ),
      ExamModel(
        id: "demo_3",
        model_no: 3,
        name: "Mathematics",
        subjectCode: "MATH-201",
        date: DateTime(now.year, now.month, now.day + 5),
        startTime: DateTime(now.year, now.month, now.day + 5, 13, 0),
        endTime: DateTime(now.year, now.month, now.day + 5, 14, 0),
        room: "Room 101",
        routineId: widget.routineId,
      ),
      ExamModel(
        id: "demo_4",
        model_no: 4,
        name: "Physics",
        subjectCode: "PHY-301",
        date: DateTime(now.year, now.month, now.day + 7),
        startTime: DateTime(now.year, now.month, now.day + 7, 15, 0),
        endTime: DateTime(now.year, now.month, now.day + 7, 16, 0),
        room: "Room 210",
        routineId: widget.routineId,
      ),
      ExamModel(
        id: "demo_5",
        model_no: 5,
        name: "Chemistry",
        subjectCode: "CHEM-202",
        date: DateTime(now.year, now.month, now.day + 9),
        startTime: DateTime(now.year, now.month, now.day + 9, 9, 0),
        endTime: DateTime(now.year, now.month, now.day + 9, 11, 0),
        room: "Lab 2",
        routineId: widget.routineId,
      ),
      ExamModel(
        id: "demo_6",
        model_no: 6,
        name: "Biology",
        subjectCode: "BIO-101",
        date: DateTime(now.year, now.month, now.day + 11),
        startTime: DateTime(now.year, now.month, now.day + 11, 11, 30),
        endTime: DateTime(now.year, now.month, now.day + 11, 13, 0),
        room: "Room 105",
        routineId: widget.routineId,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final checkStatus = ref.watch(
      checkStatusControllerProvider(widget.routineId),
    );
    final statusData = checkStatus.value;
    final activeTab = ref.watch(mainDetailTabProvider);

    final exams = _getExamsList();
    final displayedExams = exams;

    final dateFormat = DateFormat('dd MMM yyyy (E)');
    final timeFormat = DateFormat('hh:mm a');

    final String ownerName =
        (widget.data.owner.name != null && widget.data.owner.name!.isNotEmpty)
            ? widget.data.owner.name!
            : (widget.data.owner.username ?? "Unknown");

    final String displayRoutineName = widget.routineName.isNotEmpty
        ? widget.routineName
        : ((widget.data.routineName != null && widget.data.routineName!.isNotEmpty)
            ? widget.data.routineName!
            : "Exam Routine");

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. MAIN EXAM HEADER BANNER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF3E8FF), Color(0xFFFAF5FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFEDE9FE)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Shield Icon
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C3AED),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7C3AED).withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Badge: Exam Routine
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEDE9FE),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "Exam Routine",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF7C3AED),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Title
                          Text(
                            displayRoutineName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E1B4B),
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "Even Semester",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4C1D95),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // 🎯 Share Button
                    IconButton(
                      onPressed:
                          () => CustomShareButton.show(
                            context,
                            "https://classmaster.top/routine/${widget.routineId}",
                          ),
                      icon: const Icon(
                        Icons.share_rounded,
                        color: Color(0xFF7C3AED),
                      ),
                      tooltip: "Share Routine",
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(10),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Owner Info
                Row(
                  children: [
                    Text(
                      ownerName,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.verified,
                      size: 16,
                      color: Color(0xFF2563EB),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "This is the final examination routine for $displayRoutineName.",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 2. METADATA OVERVIEW ROW (4 STAT CARDS)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF1F5F9)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                _buildStatItem(
                  icon: Icons.assignment_outlined,
                  label: "Exam Type",
                  value: "Final Exam",
                ),
                _buildDivider(),
                _buildStatItem(
                  icon: Icons.people_outline_rounded,
                  label: "Semester",
                  value: "Even Sem 2026",
                ),
                _buildDivider(),
                _buildStatItem(
                  icon: Icons.calendar_today_rounded,
                  label: "Effective From",
                  value:
                      exams.isNotEmpty
                          ? DateFormat('dd MMM yyyy').format(exams.first.date)
                          : "21 Jul 2026",
                ),
                _buildDivider(),
                _buildStatItem(
                  icon: Icons.format_list_bulleted_rounded,
                  label: "Total Exams",
                  value: "${exams.length} Exams",
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 3. YOUR ADMIT CARD PROGRESS BOX
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF5FF),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF3E8FF)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Your Admit Card Progress",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1B4B),
                  ),
                ),
                const SizedBox(height: 12),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final itemWidth = (constraints.maxWidth - 24) / 4;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildProgressCard(
                          width: itemWidth,
                          icon: Icons.assignment_turned_in_outlined,
                          label: "Purchased",
                          count: "2",
                          iconBg: const Color(0xFFDCFCE7),
                          iconColor: const Color(0xFF166534),
                        ),
                        _buildProgressCard(
                          width: itemWidth,
                          icon: Icons.pending_actions_rounded,
                          label: "Pending",
                          count: "1",
                          iconBg: const Color(0xFFFFEDD5),
                          iconColor: const Color(0xFFC2410C),
                        ),
                        _buildProgressCard(
                          width: itemWidth,
                          icon: Icons.download_for_offline_outlined,
                          label: "Downloaded",
                          count: "1",
                          iconBg: const Color(0xFFDBEAFE),
                          iconColor: const Color(0xFF1D4ED8),
                        ),
                        _buildProgressCard(
                          width: itemWidth,
                          icon: Icons.dashboard_outlined,
                          label: "Remaining",
                          count: "${exams.length > 4 ? exams.length - 2 : 2}",
                          iconBg: const Color(0xFFF1F5F9),
                          iconColor: const Color(0xFF475569),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 4. NOTICE BANNER (LIGHT YELLOW)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFFEF3C7)),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFDE68A),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.security_rounded,
                    color: Color(0xFFB45309),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    "You can purchase each exam admit card separately.\nEach admit card price: ৳50",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF92400E),
                      height: 1.3,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: const BorderSide(color: Color(0xFFF59E0B)),
                    backgroundColor: Colors.white,
                  ),
                  icon: const Icon(
                    Icons.info_outline_rounded,
                    size: 14,
                    color: Color(0xFFD97706),
                  ),
                  label: const Text(
                    "How it works?",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD97706),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 4.5. CLASS ROUTINE / SUBJECTS CARD (If available)
          if (widget.data.allClass.isNotEmpty) ...[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFF1F5F9)),
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
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.menu_book_rounded,
                                color: Color(0xFF2563EB),
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Routine Classes & Subjects",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                Text(
                                  "${widget.data.allClass.length} Registered Subjects",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFF8FAFC)),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.data.allClass.length,
                    separatorBuilder:
                        (context, index) =>
                            const Divider(height: 1, color: Color(0xFFF8FAFC)),
                    itemBuilder: (context, index) {
                      final item = widget.data.allClass[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF8FAFC),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  "${index + 1}",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF334155),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  if (item.instructorName.isNotEmpty) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      "Teacher: ${item.instructorName}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            if (item.subjectCode.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  item.subjectCode,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF475569),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // 4.6 3-TAB SELECTOR CARD (Class List | Members | Join Req)
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                // TAB 0: Class List / Exam List
                Expanded(
                  child: InkWell(
                    onTap:
                        () =>
                            ref.read(mainDetailTabProvider.notifier).state = 0,
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color:
                            activeTab == 0 ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow:
                            activeTab == 0
                                ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                                : [],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.class_outlined,
                                size: 16,
                                color:
                                    activeTab == 0
                                        ? const Color(0xFF2563EB)
                                        : const Color(0xFF64748B),
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
                                          ? const Color(0xFF2563EB)
                                          : const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.data.allClass.isNotEmpty
                                ? "${widget.data.allClass.length} Classes"
                                : "${exams.length} Exams",
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
                            ref.read(mainDetailTabProvider.notifier).state = 1,
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color:
                            activeTab == 1 ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow:
                            activeTab == 1
                                ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                                : [],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.people_outline,
                                size: 16,
                                color:
                                    activeTab == 1
                                        ? const Color(0xFF2563EB)
                                        : const Color(0xFF64748B),
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
                                          ? const Color(0xFF2563EB)
                                          : const Color(0xFF64748B),
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
                            ref.read(mainDetailTabProvider.notifier).state = 2,
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color:
                            activeTab == 2 ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow:
                            activeTab == 2
                                ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                                : [],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person_add_alt_1_outlined,
                                size: 16,
                                color:
                                    activeTab == 2
                                        ? const Color(0xFF2563EB)
                                        : const Color(0xFF64748B),
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
                                          ? const Color(0xFF2563EB)
                                          : const Color(0xFF64748B),
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
          ),
          const SizedBox(height: 16),

          if (activeTab == 1) ...[
            MemberList(routineId: widget.routineId),
          ] else if (activeTab == 2) ...[
            JoinRequestPart(routineID: widget.routineId),
          ] else ...[
          // 5. EXAM LIST CARD
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFF1F5F9)),
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
                // Section Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Exam List",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      if (widget.isOwnerOrCaptain)
                        TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => CreateExamScreen(
                                      routineId: widget.routineId,
                                      serialNumber: widget.data.exams.length + 1,
                                    ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.add_circle_outline_rounded,
                            size: 16,
                            color: Color(0xFF7C3AED),
                          ),
                          label: const Text(
                            "Add Exam",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF7C3AED),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const Divider(height: 1, color: Color(0xFFF1F5F9)),

                // Exam Items
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayedExams.length,
                  separatorBuilder:
                      (context, index) =>
                          const Divider(height: 1, color: Color(0xFFF8FAFC)),
                  itemBuilder: (context, index) {
                    final exam = displayedExams[index];
                    final idxNum = index + 1;
                    final modelNum = exam.model_no ?? idxNum;

                    // Mock status & actions
                    String statusText = "Buy Now";
                    Color statusBg = const Color(0xFFEFF6FF);
                    Color statusColor = const Color(0xFF2563EB);
                    Widget actionBtn;

                    if (idxNum == 1) {
                      statusText = "Purchased";
                      statusBg = const Color(0xFFDCFCE7);
                      statusColor = const Color(0xFF15803D);
                      actionBtn = OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: const BorderSide(color: Color(0xFF7C3AED)),
                        ),
                        onPressed: () {},
                        icon: const Icon(
                          Icons.download_rounded,
                          size: 14,
                          color: Color(0xFF7C3AED),
                        ),
                        label: const Text(
                          "Download",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7C3AED),
                          ),
                        ),
                      );
                    } else if (idxNum == 2) {
                      statusText = "Pending";
                      statusBg = const Color(0xFFFFEDD5);
                      statusColor = const Color(0xFFC2410C);
                      actionBtn = OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: const BorderSide(color: Color(0xFF7C3AED)),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "View",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7C3AED),
                          ),
                        ),
                      );
                    } else {
                      actionBtn = ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          backgroundColor: const Color(0xFFFAF5FF),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: Color(0xFFDDD6FE)),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "৳50",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7C3AED),
                          ),
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          // Index Circle
                          Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF8FAFC),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                "$modelNum",
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF334155),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Exam details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  exam.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  dateFormat.format(exam.date),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "${timeFormat.format(exam.startTime)} - ${timeFormat.format(exam.endTime)}",
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF94A3B8),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Room tag
                          if (exam.room.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text(
                                exam.room,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ),

                          // Status Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: statusBg,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              statusText,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),

                          // Action Button
                          actionBtn,
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          ],

          const SizedBox(height: 16),

          // ROUTINE FOOTER (About, Discussion, Share & Dynamic Status/Join)
          RoutineFooter(
            routineId: widget.routineId,
            routineName: widget.routineName,
            isExam: true,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: const Color(0xFF7C3AED)),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 28, width: 1, color: const Color(0xFFE2E8F0));
  }

  Widget _buildProgressCard({
    required double width,
    required IconData icon,
    required String label,
    required String count,
    required Color iconBg,
    required Color iconColor,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  count,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
