// ignore: file_names
import 'package:flutter/material.dart';
import '../../helper/constant/app_color.dart';

class SelectDayRow extends StatefulWidget {
  final void Function(int) selectedDay;

  const SelectDayRow({super.key, required this.selectedDay});

  @override
  State<SelectDayRow> createState() => _SelectDayRowState();
}

class _SelectDayRowState extends State<SelectDayRow> {
  List dayNAme = [
    "Sun",
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
  ];

  late int selectedDays;

  @override
  void initState() {
    super.initState();
    selectedDays = DateTime.now().weekday;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
          7,
          (index) => SelectDayChip(
                isSelected: index == selectedDays,
                text: dayNAme[index],
                onTap: () {
                  setState(() {
                    selectedDays = index;
                  });

                  widget.selectedDay.call(index);
                },
              )),
    );
  }
}

class SelectDayChip extends StatelessWidget {
  final String text;
  final bool isSelected;
  final dynamic onTap;
  const SelectDayChip({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    // '${DateTime.now().subtract(Duration(days: 6)).day}'),
    return InkWell(
        onTap: onTap,
        child: isSelected == true
            ? Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  text,
                  textScaleFactor: 1.6,
                  style: TextStyle(color: AppColor.nokiaBlue),
                ),
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                child: Text(text, textScaleFactor: 1.1),
              ));
  }
}
