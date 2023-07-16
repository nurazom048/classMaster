import 'package:flutter/material.dart';
import 'package:classmate/constant/app_color.dart';

class DayDropdown extends StatelessWidget {
  final String labelText;
  final Function(int) onChanged;

  final dynamic onPressed;

  const DayDropdown({
    Key? key,
    required this.labelText,
    required this.onChanged,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define the list of days
    final List<String> sevendays = [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday"
    ];

    // Define the list of dropdown menu items using sevendays list
    final List<DropdownMenuItem<int>> dayItems = List.generate(
      sevendays.length,
      (index) => DropdownMenuItem(
        value: index,
        child: Text(sevendays[index], style: const TextStyle(fontSize: 18)),
      ),
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select Day ",
            style: TextStyle(
                fontFamily: 'Open Sans',
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
                height: 1.3,
                color: AppColor.nokiaBlue),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField(
            items: dayItems,
            onChanged: (value) => onChanged(value ?? 0),
            decoration: InputDecoration(
              hintText: labelText,
              hintStyle: TextStyle(fontSize: 18, color: AppColor.nokiaBlue),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColor.nokiaBlue)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
        ],
      ),
    );
  }
}
