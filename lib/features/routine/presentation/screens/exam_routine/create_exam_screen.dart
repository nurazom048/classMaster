import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../../core/export_core.dart';
import '../../../data/datasources/routine_req.dart';
import '../../providers/routine_details.controller.dart';

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

class _CreateExamScreenState extends ConsumerState<CreateExamScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _roomController = TextEditingController();

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
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roomController.dispose();
    super.dispose();
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
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF7C3AED),
            ),
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
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF7C3AED),
            ),
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
        date: _selectedDate,
        startTime: startDateTime,
        endTime: endDateTime,
        room: _roomController.text.trim(),
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
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A), size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "Add New Exam",
            style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 18),
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
                          child: const Icon(Icons.note_add_rounded, color: Colors.white, size: 24),
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
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF5B21B6)),
                                  ),
                                  if (widget.serialNumber != null) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF7C3AED),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        "Serial #${widget.serialNumber}",
                                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                "Fill in the exam parameters below to add to routine.",
                                style: TextStyle(fontSize: 12, color: Color(0xFF6D28D9)),
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
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    validator: (v) => v == null || v.trim().isEmpty ? "Enter exam title" : null,
                    decoration: InputDecoration(
                      hintText: "e.g. Higher Mathematics",
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.book_outlined, color: Color(0xFF7C3AED)),
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
                        borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Date Picker Card
                  const Text(
                    "Exam Date *",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _pickDate,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_month_rounded, color: Color(0xFF7C3AED)),
                          const SizedBox(width: 12),
                          Text(
                            dateFormat.format(_selectedDate),
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                          ),
                          const Spacer(),
                          const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B)),
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
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                            ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () => _pickTime(isStart: true),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.access_time_rounded, color: Color(0xFF7C3AED), size: 18),
                                    const SizedBox(width: 8),
                                    Text(
                                      _startTime.format(context),
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
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
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                            ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () => _pickTime(isStart: false),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.access_time_filled_rounded, color: Color(0xFF7C3AED), size: 18),
                                    const SizedBox(width: 8),
                                    Text(
                                      _endTime.format(context),
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
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
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _roomController,
                    decoration: InputDecoration(
                      hintText: "e.g. Room 205 (Main Building)",
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.location_on_outlined, color: Color(0xFF7C3AED)),
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
                        borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 1.5),
                      ),
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 2,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle_outline_rounded, color: Colors.white, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  "Add Exam to Routine",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
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
