import 'package:flutter/material.dart';

class DayDropdown extends StatefulWidget {
  final String labelText;
  final Function(int?) onChanged;
  final int? initialDay;

  const DayDropdown({
    Key? key,
    required this.labelText,
    required this.onChanged,
    this.initialDay,
  }) : super(key: key);

  @override
  _DayDropdownState createState() => _DayDropdownState();
}

class _DayDropdownState extends State<DayDropdown> {
  int? _selectedDay;

  // Define the list of days
  List<String> sevendays = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  ];

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.initialDay ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    // Define the list of dropdown menu items using sevendays list
    final List<DropdownMenuItem<int>> _dayItems = List.generate(
      sevendays.length,
      (index) => DropdownMenuItem(
        child: Text(sevendays[index]),
        value: index + 1,
      ),
    );

    return DropdownButtonFormField(
      value: _selectedDay,
      items: _dayItems,
      onChanged: (value) {
        setState(() => _selectedDay = value);
        widget.onChanged(value);
      },
      decoration: InputDecoration(
        hintText: widget.labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(color: Colors.black12),
        ),
      ),
    );
  }
}
