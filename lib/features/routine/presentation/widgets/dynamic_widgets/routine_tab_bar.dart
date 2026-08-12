import 'package:flutter/material.dart';
import 'routine_theme.dart';

class RoutineTabBar extends StatelessWidget {
  final RoutineTheme theme;
  final int activeTab;
  final int mainItemCount;
  final int memberCount;
  final int requestCount;
  final ValueChanged<int> onTabChanged;

  const RoutineTabBar({
    super.key,
    required this.theme,
    required this.activeTab,
    required this.mainItemCount,
    required this.memberCount,
    required this.requestCount,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
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
          // TAB 0: Class List / Exam List
          _buildTabItem(
            index: 0,
            icon: Icons.assignment_outlined,
            title: theme.isExam ? "Exam List" : "Class List",
            subtitle: "${mainItemCount > 0 ? mainItemCount : 6} ${theme.isExam ? 'Exams' : 'Classes'}",
          ),
          // TAB 1: Members
          _buildTabItem(
            index: 1,
            icon: Icons.people_outline_rounded,
            title: "Members",
            subtitle: "$memberCount Student",
          ),
          // TAB 2: Requests
          _buildTabItem(
            index: 2,
            icon: Icons.person_add_outlined,
            title: "Requests",
            subtitle: "$requestCount Requests",
          ),
          // TAB 3: Settings
          _buildTabItem(
            index: 3,
            icon: Icons.settings_outlined,
            title: "Settings",
            subtitle: "",
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required int index,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final isSelected = activeTab == index;

    return Expanded(
      child: InkWell(
        onTap: () => onTabChanged(index),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                children: [
                  Icon(
                    icon,
                    size: 20,
                    color: isSelected ? theme.primaryColor : const Color(0xFF0F172A),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected ? theme.primaryColor : const Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 1),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? theme.primaryColor : const Color(0xFF64748B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 2),
            // Bottom Indicator Line
            Container(
              height: 2.5,
              width: 36,
              decoration: BoxDecoration(
                color: isSelected ? theme.primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
