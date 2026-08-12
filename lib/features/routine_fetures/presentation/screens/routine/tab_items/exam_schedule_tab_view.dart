import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/class_details_model.dart';
import '../../../../data/services/department_storage_service.dart';
import '../../../widgets/dynamic_widgets/routine_theme.dart';

class ExamScheduleTabView extends StatefulWidget {
  final RoutineTheme theme;
  final List<ExamModel> exams;
  final VoidCallback onAddExamPressed;
  final bool canModify;

  const ExamScheduleTabView({
    super.key,
    required this.theme,
    required this.exams,
    required this.onAddExamPressed,
    required this.canModify,
  });

  @override
  State<ExamScheduleTabView> createState() => _ExamScheduleTabViewState();
}

class _ExamScheduleTabViewState extends State<ExamScheduleTabView> {
  String _selectedDepartment = "All Departments";

  final List<String> _departments = [];

  @override
  void initState() {
    super.initState();
    _syncDepartmentsFromExams();
  }

  @override
  void didUpdateWidget(covariant ExamScheduleTabView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exams != widget.exams) {
      _syncDepartmentsFromExams();
    }
  }

  void _syncDepartmentsFromExams() {
    final Set<String> activeDepts = {};

    for (final exam in widget.exams) {
      dynamic sys = exam.syllabus;
      if (sys is String && sys.trim().startsWith('{')) {
        try {
          sys = jsonDecode(sys);
        } catch (_) {}
      }
      if (sys is Map) {
        final syllabusMap = sys;
        if (syllabusMap['departments'] is Map) {
          final deptsMap = syllabusMap['departments'] as Map;
          for (final key in deptsMap.keys) {
            final deptName = key.toString().trim();
            if (deptName.isNotEmpty) {
              activeDepts.add(deptName);
            }
          }
        }
        for (final key in syllabusMap.keys) {
          final kStr = key.toString().trim();
          if (kStr.toLowerCase() != 'common' &&
              kStr.toLowerCase() != 'common-syllabus' &&
              kStr.toLowerCase() != 'departments' &&
              kStr.isNotEmpty) {
            activeDepts.add(kStr);
          }
        }
      }
    }

    _departments.clear();
    if (activeDepts.isNotEmpty) {
      _departments.addAll(activeDepts);
      if (!_departments.contains(_selectedDepartment)) {
        _selectedDepartment = _departments.first;
      }
    } else {
      _selectedDepartment = "No Department Added";
    }
  }

  void _showSyllabusBottomSheet(
    BuildContext context, {
    required String title,
    required String? commonSyllabus,
    required String? departmentSyllabus,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Row(
                children: [
                  Icon(
                    Icons.menu_book_rounded,
                    color: widget.theme.primaryColor,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "$title – Syllabus",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // Department Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: widget.theme.lightBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Selected Dept: $_selectedDepartment",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: widget.theme.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Part 1: Common Syllabus Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.stars_rounded,
                          color: Color(0xFF7C3AED),
                          size: 18,
                        ),
                        SizedBox(width: 6),
                        Text(
                          "Part 1: Common Syllabus (All Departments)",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5B21B6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      (commonSyllabus != null && commonSyllabus.isNotEmpty)
                          ? commonSyllabus
                          : "No common syllabus specified.",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF334155),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Part 2: Department-Specific Syllabus Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F3FF),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFDDD6FE)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.engineering_rounded,
                          color: Color(0xFF6D28D9),
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            "Part 2: $_selectedDepartment Only",
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5B21B6),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      (departmentSyllabus != null &&
                              departmentSyllabus.isNotEmpty)
                          ? departmentSyllabus
                          : "No specific syllabus added for $_selectedDepartment.",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF334155),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Close Button
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Close",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. SELECT DEPARTMENT SECTION
        Row(
          children: [
            Icon(
              Icons.account_balance_outlined,
              size: 20,
              color: widget.theme.primaryColor,
            ),
            const SizedBox(width: 8),
            const Text(
              "Select Department",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Department Selector Dropdown Card
        PopupMenuButton<String>(
          onSelected: (val) {
            setState(() => _selectedDepartment = val);
          },
          itemBuilder: (context) {
            if (_departments.isEmpty) {
              return [
                const PopupMenuItem<String>(
                  enabled: false,
                  value: "No Department Added",
                  child: Text(
                    "No Department Added",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ),
              ];
            }
            return _departments.map((dept) {
              return PopupMenuItem<String>(
                value: dept,
                child: Text(
                  dept,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              );
            }).toList();
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDepartment,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF64748B),
                  size: 24,
                ),
              ],
            ),
          ),
        ),

        // Notice for Creator when showing dummy initial preset departments
        if (widget.canModify && widget.exams.isEmpty) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFFDE68A)),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: Color(0xFFD97706),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Note: These preset departments are temporary preview items for creators. Once you add your first exam with departments, preview items will automatically disappear.",
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFFB45309),
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 24),

        // 2. MODEL LIST SECTION HEADER
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Model List",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            // + Add Model Pill Button
            InkWell(
              onTap: widget.onAddExamPressed,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: widget.theme.lightBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.add, size: 14, color: widget.theme.primaryColor),
                    const SizedBox(width: 4),
                    Text(
                      "Add Model",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: widget.theme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // 3. MODEL TEST CARDS LIST OR EMPTY STATE
        if (widget.exams.isEmpty) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.assignment_outlined,
                  size: 50,
                  color: widget.theme.primaryColor.withOpacity(0.5),
                ),
                const SizedBox(height: 12),
                const Text(
                  "No Exam Models Added Yet",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Tap '+ Add Model' to create your first exam schedule.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                ),
                if (widget.canModify) ...[
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: widget.onAddExamPressed,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text("Add First Model"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.theme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ] else ...[
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.exams.length,
            itemBuilder: (context, index) {
              final exam = widget.exams[index];

              final modelNo = exam.model_no ?? (index + 1);
              final subjectName = exam.name;
              final dateStr = DateFormat('dd MMM yyyy (E)').format(exam.date);
              final timeStr =
                  "${DateFormat('hh:mm a').format(exam.startTime)} – ${DateFormat('hh:mm a').format(exam.endTime)}";
              final roomStr = exam.room;
              final statusStr = exam.isFree ? "Free" : "Not Purchased";

              final double examPrice = exam.price ?? 0.0;
              final String? commonSyllabusText = exam.commonSyllabus;
              final String? deptSyllabusText = exam.getDepartmentSyllabus(
                _selectedDepartment,
              );

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
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
                    // Top Row: Number + Model Title & Status Badge + Action Button
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Circle Number Badge
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: widget.theme.lightBgColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              "$modelNo",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: widget.theme.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Model Test Title & Subject Name
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Model Test $modelNo",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              Text(
                                subjectName,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF334155),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Status Pill & Action Button Column
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _buildStatusPill(statusStr, price: examPrice),
                            const SizedBox(height: 6),
                            _buildActionButton(
                              context,
                              statusStr,
                              price: examPrice,
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Date, Time, Room Info Rows
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 14,
                          color: Color(0xFF64748B),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          dateStr,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF475569),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 14,
                          color: widget.theme.primaryColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          timeStr,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF475569),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: Color(0xFF64748B),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          roomStr,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF475569),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // View Syllabus Outlined Pill Button
                    InkWell(
                      onTap: () {
                        _showSyllabusBottomSheet(
                          context,
                          title: "Model Test $modelNo ($subjectName)",
                          commonSyllabus: commonSyllabusText,
                          departmentSyllabus: deptSyllabusText,
                        );
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: widget.theme.primaryColor,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.remove_red_eye_outlined,
                              size: 14,
                              color: widget.theme.primaryColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "View Syllabus",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: widget.theme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ],
    );
  }

  Widget _buildStatusPill(String status, {double price = 0}) {
    Color bg;
    Color text;

    if (price == 0 || status == "Free") {
      bg = const Color(0xFFDCFCE7);
      text = const Color(0xFF166534);
      status = "Free";
    } else {
      switch (status) {
        case "Approved":
          bg = const Color(0xFFDCFCE7);
          text = const Color(0xFF166534);
          break;
        case "Payment Pending":
          bg = const Color(0xFFFFEDD5);
          text = const Color(0xFFC2410C);
          break;
        case "Not Purchased":
        default:
          bg = widget.theme.lightBgColor;
          text = widget.theme.primaryColor;
          break;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: text,
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String status, {
    double price = 0,
  }) {
    if (price == 0 || status == "Free" || status == "Approved") {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF86EFAC)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.download_rounded, size: 14, color: Color(0xFF166534)),
            SizedBox(width: 4),
            Text(
              "Download Admit Card",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF166534),
              ),
            ),
          ],
        ),
      );
    } else if (status == "Payment Pending") {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBEB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFDE68A)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.access_time_rounded, size: 14, color: Color(0xFFD97706)),
            SizedBox(width: 4),
            Text(
              "View Status",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFFD97706),
              ),
            ),
          ],
        ),
      );
    } else {
      // Paid -> Buy Admit Card ৳{price}
      final priceInt = price.toInt();
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: widget.theme.lightBgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: widget.theme.borderTileColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 14,
              color: widget.theme.primaryColor,
            ),
            const SizedBox(width: 4),
            Text(
              "Buy Admit Card ৳$priceInt",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: widget.theme.primaryColor,
              ),
            ),
          ],
        ),
      );
    }
  }
}
