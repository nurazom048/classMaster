import 'package:flutter/material.dart';
import '../helper/constant/AppColor.dart';

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
    final List<DropdownMenuItem<int>> _dayItems = List.generate(
      sevendays.length,
      (index) => DropdownMenuItem(
        value: index,
        child: Text(sevendays[index]),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "Select Day ",
              style: TextStyle(
                  fontFamily: 'Open Sans',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                  height: 1.3,
                  color: AppColor.nokiaBlue),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColor.nokiaBlue),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                    items: _dayItems,
                    onChanged: (value) => onChanged(value ?? 0),
                    decoration: InputDecoration(
                      hintText: labelText,
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onPressed,
                  icon: Icon(Icons.calendar_today),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
