import 'package:flutter/material.dart';

/// A custom reusable bottom sheet widget for selecting or adding a department.
///
/// Returns a callback `onDepartmentSelected(String deptName)` when a department is selected or added.
class AddDepartmentWidget extends StatefulWidget {
  final List<String> suggestedDepartments;
  final List<String> existingDepartmentNames;
  final ValueChanged<String> onDepartmentSelected;

  const AddDepartmentWidget({
    super.key,
    required this.suggestedDepartments,
    required this.existingDepartmentNames,
    required this.onDepartmentSelected,
  });

  /// Helper static method to conveniently present the bottom sheet from any screen.
  static Future<void> show(
    BuildContext context, {
    required List<String> suggestedDepartments,
    required List<String> existingDepartmentNames,
    required ValueChanged<String> onDepartmentSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AddDepartmentWidget(
          suggestedDepartments: suggestedDepartments,
          existingDepartmentNames: existingDepartmentNames,
          onDepartmentSelected: onDepartmentSelected,
        );
      },
    );
  }

  @override
  State<AddDepartmentWidget> createState() => _AddDepartmentWidgetState();
}

class _AddDepartmentWidgetState extends State<AddDepartmentWidget> {
  final TextEditingController _customDeptController = TextEditingController();

  @override
  void dispose() {
    _customDeptController.dispose();
    super.dispose();
  }

  bool _isAlreadyAdded(String dept) {
    return widget.existingDepartmentNames.any(
      (e) => e.toLowerCase() == dept.toLowerCase(),
    );
  }

  void _handleSelectDepartment(String deptName) {
    widget.onDepartmentSelected(deptName);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle Bar
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

            Row(
              children: [
                const Icon(
                  Icons.school_outlined,
                  color: Color(0xFF7C3AED),
                  size: 22,
                ),
                const SizedBox(width: 8),
                const Text(
                  "Add Department Choice Chip",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              "Select from saved department choices to save time, or enter a new one.",
              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 18),

            const Text(
              "Preset Department Choice Chips:",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 10),

            // Choice Chips Grid
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  widget.suggestedDepartments.map((dept) {
                    final isAdded = _isAlreadyAdded(dept);

                    return ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isAdded) ...[
                            const Icon(
                              Icons.check_circle,
                              size: 14,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                          ],
                          Text(dept),
                        ],
                      ),
                      selected: isAdded,
                      selectedColor: const Color(0xFF7C3AED),
                      backgroundColor: const Color(0xFFF1F5F9),
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color:
                            isAdded
                                ? Colors.white
                                : const Color(0xFF334155),
                      ),
                      onSelected: (selected) {
                        if (!isAdded) {
                          _handleSelectDepartment(dept);
                        }
                      },
                    );
                  }).toList(),
            ),
            const SizedBox(height: 20),

            // Custom Department Entry Field
            const Text(
              "Or Add Custom Department:",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _customDeptController,
                    decoration: InputDecoration(
                      hintText: "e.g. Aeronautical Engineering",
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
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    final text = _customDeptController.text.trim();
                    if (text.isNotEmpty) {
                      _handleSelectDepartment(text);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Add",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
