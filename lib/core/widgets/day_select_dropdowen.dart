import 'package:flutter/material.dart';

import '../export_core.dart';

// Define the list of full day names and their abbreviations
final List<String> sevenDaysFull = [
  "Sunday",
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
];

final List<String> sevenDaysAbbr = [
  "sun",
  "mon",
  "tue",
  "wed",
  "thu",
  "fri",
  "sat",
];

class DayDropdown extends StatelessWidget {
  final String labelText;
  final Function(String) onChanged;
  final dynamic onPressed;

  const DayDropdown({
    super.key,
    required this.labelText,
    required this.onChanged,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<int>> dayItems = List.generate(
      sevenDaysAbbr.length,
      (index) => DropdownMenuItem(
        value: index,
        child: Text(sevenDaysAbbr[index], style: const TextStyle(fontSize: 18)),
      ),
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select Day",
            style: TextStyle(
              fontFamily: 'Open Sans',
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
              height: 1.3,
              color: AppColor.nokiaBlue,
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField(
            items: dayItems,
            onChanged: (value) {
              if (value != null) {
                // Use the index to get the abbreviation and pass it back
                onChanged(sevenDaysAbbr[value]);
              }
            },
            decoration: InputDecoration(
              hintText: labelText,
              hintStyle: TextStyle(fontSize: 18, color: AppColor.nokiaBlue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColor.nokiaBlue),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
        ],
      ),
    );
  }
}
