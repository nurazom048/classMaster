import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../core/constant/app_color.dart';

class ClassScheduleItem {
  String? id;
  String day; // e.g. "Sunday", "Monday", ...
  DateTime startTime;
  DateTime endTime;
  String roomNumber;

  ClassScheduleItem({
    this.id,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.roomNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'day': day.toUpperCase(),
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'roomNumber': roomNumber,
    };
  }

  factory ClassScheduleItem.fromJson(Map<String, dynamic> json) {
    return ClassScheduleItem(
      id: json['id']?.toString(),
      day: json['day']?.toString() ?? 'SUNDAY',
      startTime: DateTime.tryParse(json['startTime']?.toString() ?? '') ?? DateTime.now(),
      endTime: DateTime.tryParse(json['endTime']?.toString() ?? '') ?? DateTime.now().add(const Duration(minutes: 60)),
      roomNumber: json['roomNumber']?.toString() ?? json['room']?.toString() ?? '',
    );
  }
}

class SetScheduleSection extends StatefulWidget {
  final List<ClassScheduleItem> initialSchedules;
  final ValueChanged<List<ClassScheduleItem>> onSchedulesChanged;

  const SetScheduleSection({
    super.key,
    this.initialSchedules = const [],
    required this.onSchedulesChanged,
  });

  @override
  State<SetScheduleSection> createState() => _SetScheduleSectionState();
}

class _SetScheduleSectionState extends State<SetScheduleSection> {
  final List<String> _allDays = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  final Set<String> _selectedDays = {};
  final Map<String, List<ClassScheduleItem>> _daySchedules = {};

  @override
  void initState() {
    super.initState();
    _populateInitialData();
  }

  void _populateInitialData() {
    for (var item in widget.initialSchedules) {
      String formattedDay = _allDays.firstWhere(
        (d) => d.toLowerCase() == item.day.toLowerCase(),
        orElse: () => item.day,
      );
      _selectedDays.add(formattedDay);
      _daySchedules.putIfAbsent(formattedDay, () => []).add(item);
    }
  }

  void _notifyChanges() {
    List<ClassScheduleItem> all = [];
    for (var day in _selectedDays) {
      if (_daySchedules.containsKey(day)) {
        all.addAll(_daySchedules[day]!);
      }
    }
    widget.onSchedulesChanged(all);
  }

  void _toggleDay(String day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
        _daySchedules.remove(day);
      } else {
        _selectedDays.add(day);
        // Default first shift
        final now = DateTime.now();
        final start = DateTime(now.year, now.month, now.day, 9, 0);
        final end = DateTime(now.year, now.month, now.day, 10, 0);
        _daySchedules[day] = [
          ClassScheduleItem(
            day: day,
            startTime: start,
            endTime: end,
            roomNumber: '',
          )
        ];
      }
    });
    _notifyChanges();
  }

  void _addSecondShift(String day) {
    if ((_daySchedules[day]?.length ?? 0) >= 2) return;
    setState(() {
      final now = DateTime.now();
      final start = DateTime(now.year, now.month, now.day, 14, 0);
      final end = DateTime(now.year, now.month, now.day, 15, 0);
      _daySchedules[day]?.add(
        ClassScheduleItem(
          day: day,
          startTime: start,
          endTime: end,
          roomNumber: '',
        ),
      );
    });
    _notifyChanges();
  }

  void _removeShift(String day, int index) {
    setState(() {
      _daySchedules[day]?.removeAt(index);
      if (_daySchedules[day]?.isEmpty ?? true) {
        _daySchedules.remove(day);
        _selectedDays.remove(day);
      }
    });
    _notifyChanges();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Row(
                children: [
                  Icon(Icons.calendar_today_rounded, size: 20, color: Color(0xFF0168FF)),
                  SizedBox(width: 8),
                  Text(
                    "Set Schedule",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                "Add class time for each day",
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Days Selection Chips Carousel / Grid
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: _allDays.map((day) {
              final isSelected = _selectedDays.contains(day);
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: InkWell(
                  onTap: () => _toggleDay(day),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 90,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF0168FF) : const Color(0xFFE2E8F0),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          day,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? const Color(0xFF0168FF) : const Color(0xFF475569),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Icon(
                          isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                          size: 16,
                          color: isSelected ? const Color(0xFF0168FF) : const Color(0xFF94A3B8),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),

        // Cards for Selected Days
        ..._allDays.where((d) => _selectedDays.contains(d)).map((day) {
          final schedules = _daySchedules[day] ?? [];
          return _buildDayCard(day, schedules);
        }),
      ],
    );
  }

  Widget _buildDayCard(String day, List<ClassScheduleItem> schedules) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Day Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_month, color: Color(0xFF0168FF), size: 20),
                    const SizedBox(width: 8),
                    Text(
                      day,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${schedules.length} shift(s) added",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                  onPressed: () => _toggleDay(day),
                ),
              ],
            ),
            const Divider(height: 20, color: Color(0xFFF1F5F9)),

            // Schedule shifts list
            ...List.generate(schedules.length, (index) {
              final sched = schedules[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Shift ${index + 1}",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0168FF),
                          ),
                        ),
                        InkWell(
                          onTap: () => _removeShift(day, index),
                          child: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        bool isMobile = constraints.maxWidth < 600;
                        if (isMobile) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(child: _buildTimePicker(context, "Start Time", sched.startTime, (t) {
                                    setState(() => sched.startTime = t);
                                    _notifyChanges();
                                  })),
                                  const SizedBox(width: 10),
                                  Expanded(child: _buildTimePicker(context, "End Time", sched.endTime, (t) {
                                    setState(() => sched.endTime = t);
                                    _notifyChanges();
                                  })),
                                ],
                              ),
                              const SizedBox(height: 10),
                              _buildRoomField(sched),
                            ],
                          );
                        } else {
                          return Row(
                            children: [
                              Expanded(child: _buildTimePicker(context, "Start Time", sched.startTime, (t) {
                                setState(() => sched.startTime = t);
                                _notifyChanges();
                              })),
                              const SizedBox(width: 10),
                              Expanded(child: _buildTimePicker(context, "End Time", sched.endTime, (t) {
                                setState(() => sched.endTime = t);
                                _notifyChanges();
                              })),
                              const SizedBox(width: 10),
                              Expanded(child: _buildRoomField(sched)),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            }),

            // Add 2nd Shift Button (Max 2)
            if (schedules.length < 2)
              Align(
                alignment: Alignment.center,
                child: TextButton.icon(
                  onPressed: () => _addSecondShift(day),
                  icon: const Icon(Icons.add, size: 18, color: Color(0xFF0168FF)),
                  label: Text(
                    schedules.isEmpty ? "+ Add 1st Shift" : "+ Add 2nd Shift",
                    style: const TextStyle(
                      color: Color(0xFF0168FF),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker(BuildContext context, String label, DateTime time, ValueChanged<DateTime> onPicked) {
    final formattedStr = DateFormat('hh:mm a').format(time);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF0168FF)),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: () async {
            final tod = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(time),
            );
            if (tod != null) {
              onPicked(DateTime(time.year, time.month, time.day, tod.hour, tod.minute));
            }
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFCBD5E1)),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Color(0xFF64748B)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    formattedStr,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoomField(ClassScheduleItem sched) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Classroom Number",
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF0168FF)),
        ),
        const SizedBox(height: 4),
        Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: Row(
            children: [
              const Icon(Icons.meeting_room_outlined, size: 16, color: Color(0xFF64748B)),
              const SizedBox(width: 6),
              Expanded(
                child: TextFormField(
                  initialValue: sched.roomNumber,
                  onChanged: (val) {
                    sched.roomNumber = val;
                    _notifyChanges();
                  },
                  decoration: const InputDecoration(
                    hintText: "e.g. 501",
                    hintStyle: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
