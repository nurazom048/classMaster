import 'package:shared_preferences/shared_preferences.dart';

class DepartmentStorageService {
  static const String _key = 'user_department_choice_chips';

  static const List<String> defaultDepartments = [
    "Electrical Engineering",
    "Mechanical Engineering",
    "Civil Engineering",
    "Computer Science (CSE)",
    "Power Engineering",
    "Electronics (EEE)",
    "Architecture",
    "Chemical Engineering",
  ];

  /// Get saved department choices from SharedPreferences combined with defaults
  static Future<List<String>> getSavedDepartments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? saved = prefs.getStringList(_key);

      final Set<String> combined = {...defaultDepartments};
      if (saved != null && saved.isNotEmpty) {
        combined.addAll(saved);
      }
      return combined.toList();
    } catch (e) {
      return defaultDepartments;
    }
  }

  /// Save new department choice name to persistent storage
  static Future<void> saveDepartment(String deptName) async {
    final cleanName = deptName.trim();
    if (cleanName.isEmpty) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> current = prefs.getStringList(_key) ?? [];

      if (!current.any((d) => d.toLowerCase() == cleanName.toLowerCase())) {
        current.add(cleanName);
        await prefs.setStringList(_key, current);
      }
    } catch (e) {
      // Handle error gracefully
    }
  }
}
