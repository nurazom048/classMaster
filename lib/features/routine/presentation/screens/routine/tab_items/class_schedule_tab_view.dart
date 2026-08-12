import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/class_details_model.dart';
import '../../../widgets/dynamic_widgets/routine_theme.dart';

class ClassScheduleTabView extends StatelessWidget {
  final RoutineTheme theme;
  final Classes weekdayClasses;
  final int selectedDayIndex;
  final ValueChanged<int> onDaySelected;
  final VoidCallback onAddClassPressed;
  final bool canModify;

  const ClassScheduleTabView({
    super.key,
    required this.theme,
    required this.weekdayClasses,
    required this.selectedDayIndex,
    required this.onDaySelected,
    required this.onAddClassPressed,
    required this.canModify,
  });

  List<Day> _getClassesForDay(int dayIndex) {
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

  List<Map<String, String>> _getDemoClasses(int dayIndex) {
    return [
      {
        "name": "Bangla",
        "time": "08:00 AM – 09:00 AM",
        "room": "Room 205",
        "teacher": "Rashedul Islam",
      },
      {
        "name": "English",
        "time": "09:00 AM – 10:00 AM",
        "room": "Room 305",
        "teacher": "Mishu Rahman",
      },
      {
        "name": "Mathematics",
        "time": "10:00 AM – 11:00 AM",
        "room": "Room 110",
        "teacher": "Sadia Akter",
      },
      {
        "name": "Physics",
        "time": "11:00 AM – 12:00 PM",
        "room": "Room 204",
        "teacher": "Tariq Hasan",
      },
      {
        "name": "Chemistry",
        "time": "12:00 PM – 01:00 PM",
        "room": "Room 201",
        "teacher": "Nusrat Jahan",
      },
      {
        "name": "Biology",
        "time": "01:00 PM – 02:00 PM",
        "room": "Room 105",
        "teacher": "Arif Hasan",
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final shortDays = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
    final fullDays = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];

    final dayClasses = _getClassesForDay(selectedDayIndex);
    final demoClasses = _getDemoClasses(selectedDayIndex);
    final isRealDataAvailable = dayClasses.isNotEmpty;
    final totalCount =
        isRealDataAvailable ? dayClasses.length : demoClasses.length;

    final todayIndex = (DateTime.now().weekday + 1) % 7;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. SELECT DAY SECTION
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  size: 20,
                  color: theme.primaryColor,
                ),
                const SizedBox(width: 8),
                const Text(
                  "Select Day",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            // Today Pill Button
            InkWell(
              onTap: () => onDaySelected(todayIndex),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: theme.lightBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Today",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Day Selector Pills Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            final isSelected = selectedDayIndex == index;
            return InkWell(
              onTap: () => onDaySelected(index),
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 44,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected ? theme.primaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        isSelected
                            ? theme.primaryColor
                            : const Color(0xFFE2E8F0),
                  ),
                  boxShadow:
                      isSelected
                          ? [
                            BoxShadow(
                              color: theme.primaryColor.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ]
                          : [],
                ),
                child: Center(
                  child: Text(
                    shortDays[index],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w600,
                      color:
                          isSelected ? Colors.white : const Color(0xFF475569),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 24),

        // 2. DAY SCHEDULE TITLE & COUNT BADGE
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${fullDays[selectedDayIndex]} – Class Schedule",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: theme.lightBgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                "$totalCount Classes",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // 3. CLASS SCHEDULE CARDS CONTAINER
        Container(
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
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: totalCount,
                separatorBuilder:
                    (context, index) => const Divider(
                      height: 1,
                      color: Color(0xFFF1F5F9),
                      indent: 16,
                      endIndent: 16,
                    ),
                itemBuilder: (context, index) {
                  final number = index + 1;
                  final String name =
                      isRealDataAvailable
                          ? dayClasses[index].name
                          : demoClasses[index]["name"]!;
                  final String time =
                      isRealDataAvailable
                          ? "${DateFormat('hh:mm a').format(dayClasses[index].startTime)} – ${DateFormat('hh:mm a').format(dayClasses[index].endTime)}"
                          : demoClasses[index]["time"]!;
                  final String room =
                      isRealDataAvailable
                          ? dayClasses[index].room
                          : demoClasses[index]["room"]!;
                  final String teacher =
                      isRealDataAvailable
                          ? dayClasses[index].instructorName
                          : demoClasses[index]["teacher"]!;

                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Circle Number Badge
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: theme.lightBgColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              "$number",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Class Details Column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time_rounded,
                                    size: 14,
                                    color: theme.primaryColor,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    time,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF475569),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 14,
                                    color: Color(0xFF64748B),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    room,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF475569),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              if (teacher.isNotEmpty) ...[
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.person_outline_rounded,
                                      size: 14,
                                      color: Color(0xFF64748B),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      teacher,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF475569),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),

                        // Right Chevron Arrow
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: Color(0xFF64748B),
                          size: 22,
                        ),
                      ],
                    ),
                  );
                },
              ),

              // Bottom Action Button: + Add Class
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: OutlinedButton.icon(
                    onPressed: onAddClassPressed,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: theme.primaryColor, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: Icon(Icons.add, color: theme.primaryColor, size: 20),
                    label: Text(
                      "Add Class",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
