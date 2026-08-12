import 'package:flutter/material.dart';

class RoutineTheme {
  final bool isExam;
  final Color primaryColor;
  final Color lightBgColor;
  final Color borderTileColor;
  final List<Color> gradientColors;
  final IconData typeIcon;
  final String typeBadgeText;

  const RoutineTheme({
    required this.isExam,
    required this.primaryColor,
    required this.lightBgColor,
    required this.borderTileColor,
    required this.gradientColors,
    required this.typeIcon,
    required this.typeBadgeText,
  });

  factory RoutineTheme.of(bool isExam) {
    if (isExam) {
      return const RoutineTheme(
        isExam: true,
        primaryColor: Color(0xFF7C3AED),
        lightBgColor: Color(0xFFF3E8FF),
        borderTileColor: Color(0xFFEDE9FE),
        gradientColors: [
          Color(0xFF6D28D9),
          Color(0xFF7C3AED),
          Color(0xFF8B5CF6),
        ],
        typeIcon: Icons.shield_outlined,
        typeBadgeText: "Exam Routine",
      );
    } else {
      return const RoutineTheme(
        isExam: false,
        primaryColor: Color(0xFF2563EB),
        lightBgColor: Color(0xFFEFF6FF),
        borderTileColor: Color(0xFFDBEAFE),
        gradientColors: [
          Color(0xFF1E40AF),
          Color(0xFF2563EB),
          Color(0xFF3B82F6),
        ],
        typeIcon: Icons.school_rounded,
        typeBadgeText: "Class Routine",
      );
    }
  }
}
