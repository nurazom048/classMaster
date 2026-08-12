import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../../core/export_core.dart';
import '../../../data/datasources/routine_req.dart';
import '../../../data/services/department_storage_service.dart';
import '../../providers/routine_details.controller.dart';
import '../../widgets/exam_routine_widgets/add_department_widgets.dart';

class CreateExamScreen extends ConsumerStatefulWidget {
  final String routineId;
  final int? serialNumber;

  const CreateExamScreen({
    super.key,
    required this.routineId,
    this.serialNumber,
  });

  @override
  ConsumerState<CreateExamScreen> createState() => _CreateExamScreenState();
}

class DeptSyllabusEntry {
  final String deptName;
  final TextEditingController controller;

  DeptSyllabusEntry({required this.deptName, TextEditingController? controller})
    : controller = controller ?? TextEditingController();
}

class _CreateExamScreenState extends ConsumerState<CreateExamScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _roomController = TextEditingController();

  // Price configuration
  bool _isFree = true;
  final _priceController = TextEditingController(text: "50");

  // 2-Part Syllabus configuration
  final _commonSyllabusController = TextEditingController();

  // Dynamic Department Syllabus Entries
  final List<DeptSyllabusEntry> _deptEntries = [];

  // Preset suggested department choices for quick addition (loaded from persistent storage)
  List<String> _suggestedDepartments =
      DepartmentStorageService.defaultDepartments;

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 12, minute: 0);

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.serialNumber != null) {
      _nameController.text = "Exam ${widget.serialNumber}";
    }

    _loadSavedDepartments();

    // Default pre-loaded department entries for faster user workflow
    _deptEntries.addAll([
      DeptSyllabusEntry(deptName: "Electrical Engineering"),
      DeptSyllabusEntry(deptName: "Mechanical Engineering"),
      DeptSyllabusEntry(deptName: "Civil Engineering"),
      DeptSyllabusEntry(deptName: "Computer Science (CSE)"),
    ]);
  }

  Future<void> _loadSavedDepartments() async {
    final savedDepts = await DepartmentStorageService.getSavedDepartments();
    final Set<String> allDepts = {...savedDepts};

    // Extract departments previously added by users in this routine
    try {
      final routineState = ref.read(routineDetailsProvider(widget.routineId));
      routineState.whenData((routineData) {
        for (final exam in routineData.exams) {
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
                  allDepts.add(deptName);
                }
              }
            }
            for (final key in syllabusMap.keys) {
              final kStr = key.toString().trim();
              if (kStr.toLowerCase() != 'common' &&
                  kStr.toLowerCase() != 'common-syllabus' &&
                  kStr.toLowerCase() != 'departments' &&
                  kStr.isNotEmpty) {
                allDepts.add(kStr);
              }
            }
          }
        }
      });
    } catch (_) {}

    if (mounted) {
      setState(() {
        _suggestedDepartments = allDepts.toList();
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roomController.dispose();
    _priceController.dispose();
    _commonSyllabusController.dispose();
    for (final entry in _deptEntries) {
      entry.controller.dispose();
    }
    super.dispose();
  }

  void _addDepartmentEntry(String deptName) async {
    final cleanName = deptName.trim();
    if (cleanName.isEmpty) return;

    final exists = _deptEntries.any(
      (e) => e.deptName.toLowerCase() == cleanName.toLowerCase(),
    );

    if (exists) {
      Alert.showSnackBar(context, "$cleanName is already added.");
      return;
    }

    setState(() {
      _deptEntries.add(DeptSyllabusEntry(deptName: cleanName));
    });

    // Save to persistent storage so it appears in choice chips next time
    await DepartmentStorageService.saveDepartment(cleanName);
    _loadSavedDepartments();
  }

  void _showAddDepartmentModal() {
    AddDepartmentWidget.show(
      context,
      suggestedDepartments: _suggestedDepartments,
      existingDepartmentNames: _deptEntries.map((e) => e.deptName).toList(),
      onDepartmentSelected: (deptName) {
        _addDepartmentEntry(deptName);
      },
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF7C3AED)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime({required bool isStart}) async {
    final initial = isStart ? _startTime : _endTime;
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF7C3AED)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Map<String, dynamic>? _buildSyllabusJson() {
    final commonText = _commonSyllabusController.text.trim();
    final Map<String, String> depts = {};

    for (final entry in _deptEntries) {
      final text = entry.controller.text.trim();
      if (text.isNotEmpty) {
        depts[entry.deptName] = text;
      }
    }

    if (commonText.isEmpty && depts.isEmpty) return null;

    return {
      if (commonText.isNotEmpty) 'common': commonText,
      if (depts.isNotEmpty) 'departments': depts,
    };
  }

  double _getExamPrice() {
    if (_isFree) return 0.0;
    final parsed = double.tryParse(_priceController.text.trim());
    return parsed ?? 0.0;
  }

  Future<void> _submitExam() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final startDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _startTime.hour,
        _startTime.minute,
      );

      final endDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _endTime.hour,
        _endTime.minute,
      );

      await RoutineRequestImpl().createExam(
        routineID: widget.routineId,
        name: _nameController.text.trim(),
        subjectCode: "",
        price: _getExamPrice(),
        syllabus: _buildSyllabusJson(),
        date: _selectedDate,
        startTime: startDateTime,
        endTime: endDateTime,
        room:
            _roomController.text.trim().isEmpty
                ? "TBA"
                : _roomController.text.trim(),
      );

      if (mounted) {
        ref.invalidate(routineDetailsProvider(widget.routineId));
        Navigator.pop(context);
        Alert.showSnackBar(context, "Exam added successfully!");
      }
    } catch (e) {
      if (mounted) {
        Alert.showSnackBar(context, e.toString());
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEE, dd MMM yyyy');

    return DesktopLayoutWrapper(
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF0F172A),
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "Add New Exam",
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F3FF),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFDDD6FE)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFF7C3AED),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.note_add_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "Exam Details",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF5B21B6),
                                    ),
                                  ),
                                  if (widget.serialNumber != null) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF7C3AED),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        "Serial #${widget.serialNumber}",
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                "Fill in the exam parameters below to add to routine.",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF6D28D9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Exam Title Input
                  const Text(
                    "Exam / Subject Name *",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    validator:
                        (v) =>
                            v == null || v.trim().isEmpty
                                ? "Enter exam title"
                                : null,
                    decoration: InputDecoration(
                      hintText: "e.g. Higher Mathematics",
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(
                        Icons.book_outlined,
                        color: Color(0xFF7C3AED),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF7C3AED),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Date Picker Card
                  const Text(
                    "Exam Date *",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _pickDate,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_month_rounded,
                            color: Color(0xFF7C3AED),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            dateFormat.format(_selectedDate),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Color(0xFF64748B),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Time Pickers Row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Start Time *",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF334155),
                              ),
                            ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () => _pickTime(isStart: true),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFE2E8F0),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time_rounded,
                                      color: Color(0xFF7C3AED),
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _startTime.format(context),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF0F172A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "End Time *",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF334155),
                              ),
                            ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () => _pickTime(isStart: false),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFE2E8F0),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time_filled_rounded,
                                      color: Color(0xFF7C3AED),
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _endTime.format(context),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF0F172A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Room Location Input
                  const Text(
                    "Room / Venue (Optional)",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _roomController,
                    decoration: InputDecoration(
                      hintText: "e.g. Room 205 (Main Building)",
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(
                        Icons.location_on_outlined,
                        color: Color(0xFF7C3AED),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF7C3AED),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ================= EXAM PRICING SECTION =================
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.payments_outlined,
                              color: Color(0xFF7C3AED),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "Exam Pricing",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            ChoiceChip(
                              label: const Text("Free Exam"),
                              selected: _isFree,
                              selectedColor: const Color(0xFF7C3AED),
                              labelStyle: TextStyle(
                                color:
                                    _isFree
                                        ? Colors.white
                                        : const Color(0xFF475569),
                                fontWeight: FontWeight.bold,
                              ),
                              onSelected: (selected) {
                                if (selected) setState(() => _isFree = true);
                              },
                            ),
                            const SizedBox(width: 12),
                            ChoiceChip(
                              label: const Text("Paid Exam"),
                              selected: !_isFree,
                              selectedColor: const Color(0xFF7C3AED),
                              labelStyle: TextStyle(
                                color:
                                    !_isFree
                                        ? Colors.white
                                        : const Color(0xFF475569),
                                fontWeight: FontWeight.bold,
                              ),
                              onSelected: (selected) {
                                if (selected) setState(() => _isFree = false);
                              },
                            ),
                          ],
                        ),
                        if (!_isFree) ...[
                          const SizedBox(height: 14),
                          const Text(
                            "Price (৳ / Currency) *",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF334155),
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            validator: (v) {
                              if (!_isFree) {
                                if (v == null || v.trim().isEmpty)
                                  return "Enter price";
                                if (double.tryParse(v.trim()) == null)
                                  return "Enter valid number";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "e.g. 50",
                              prefixText: "৳ ",
                              prefixStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF7C3AED),
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF8FAFC),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE2E8F0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ================= 2-PART SYLLABUS SECTION =================
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.menu_book_rounded,
                              color: Color(0xFF7C3AED),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "Exam Syllabus (2 Parts)",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Configure common and department-specific syllabus text.",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Part 1: Common Syllabus
                        const Text(
                          "Part 1: Common Syllabus (All Departments)",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5B21B6),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Text added here applies to all departments (Electrical, Mechanical, etc.)",
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _commonSyllabusController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText:
                                "e.g. Math 20 marks, General Knowledge 10 marks, English 10 marks...",
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFE2E8F0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Part 2: Department-Specific Syllabus Header & Actions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Part 2: Department-Specific Syllabus",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF5B21B6),
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    "Only shown when user selects that department in the routine view.",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: _showAddDepartmentModal,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F3FF),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: const Color(0xFFDDD6FE),
                                  ),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      size: 14,
                                      color: Color(0xFF7C3AED),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "Add Department",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF7C3AED),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Dynamic Department Cards List
                        if (_deptEntries.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                "No departments added yet. Click '+ Add Department' above.",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ),
                          )
                        else
                          ...List.generate(_deptEntries.length, (index) {
                            final entry = _deptEntries[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFE2E8F0),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.school_outlined,
                                            size: 16,
                                            color: Color(0xFF7C3AED),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            "${entry.deptName} Syllabus:",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF0F172A),
                                            ),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _deptEntries.removeAt(index);
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.close_rounded,
                                          size: 18,
                                          color: Color(0xFFEF4444),
                                        ),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        tooltip: "Remove Department",
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  TextFormField(
                                    controller: entry.controller,
                                    maxLines: 2,
                                    decoration: InputDecoration(
                                      hintText:
                                          "e.g. Specific topics for ${entry.deptName}...",
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFCBD5E1),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFCBD5E1),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),

                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _showAddDepartmentModal,
                            icon: const Icon(
                              Icons.add_circle_outline,
                              size: 18,
                              color: Color(0xFF7C3AED),
                            ),
                            label: const Text(
                              "+ Add Department Choice Chip",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF7C3AED),
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Color(0xFFDDD6FE),
                                width: 1.5,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitExam,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7C3AED),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 2,
                      ),
                      child:
                          _isLoading
                              ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                              : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle_outline_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Add Exam to Routine",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
