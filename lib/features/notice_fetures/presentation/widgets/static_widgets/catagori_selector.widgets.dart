import 'package:flutter/material.dart';

class CategorySelector extends StatefulWidget {
  final String initialCategory;
  final ValueChanged<String> onCategorySelected;

  const CategorySelector({
    super.key,
    this.initialCategory = 'notice',
    required this.onCategorySelected,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  late String selectedCategory;

  // Categories list moved inside the custom widget
  final List<Map<String, String>> categories = [
    {'key': 'job_circular', 'label': 'Job Circular'},
    {'key': 'notice', 'label': 'Notice'},
    {'key': 'result', 'label': 'Result'},
    {'key': 'other', 'label': 'Other'},
  ];

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initialCategory;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Category",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children:
              categories.map((cat) {
                final isSelected = selectedCategory == cat['key'];
                return ChoiceChip(
                  label: Text(
                    cat['label']!,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: const Color(0xFF0052CC), // ClassMaster Blue
                  backgroundColor: Colors.grey.shade200,
                  checkmarkColor: Colors.white,
                  onSelected: (bool selected) {
                    if (selected) {
                      setState(() {
                        selectedCategory = cat['key']!;
                      });
                      // Pass the updated value back to the parent widget
                      widget.onCategorySelected(selectedCategory);
                    }
                  },
                );
              }).toList(),
        ),
      ],
    );
  }
}
