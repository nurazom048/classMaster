import 'package:flutter/material.dart';
import 'package:table/helper/constant/AppColor.dart';

class PeriodNumberButton extends StatelessWidget {
  final int periodNumber;
  final bool? isSelected;
  final dynamic onSelected;

  const PeriodNumberButton({
    Key? key,
    required this.periodNumber,
    this.isSelected,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 46,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      decoration: BoxDecoration(
        color: isSelected == true
            ? AppColor.nokiaBlue
            : Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 1, color: const Color(0xFF0168FF)),
      ),
      child: IconButton(
        onPressed: onSelected,
        icon: Text(
          getPeriodText(periodNumber),
          style: TextStyle(
              color: isSelected == true
                  ? Colors.white.withOpacity(0.5)
                  : Colors.black,
              fontWeight:
                  isSelected == true ? FontWeight.w700 : FontWeight.w400),
        ),
      ),
    );
  }

  String getPeriodText(int periodNumber) {
    final suffix = getSuffix(periodNumber);
    return '$periodNumber$suffix';
  }

  String getSuffix(int n) {
    if (n >= 11 && n <= 13) {
      return 'th';
    }
    switch (n % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}

class PeriodSelectionScreen extends StatefulWidget {
  @override
  _PeriodSelectionScreenState createState() => _PeriodSelectionScreenState();
}

class _PeriodSelectionScreenState extends State<PeriodSelectionScreen> {
  int selectedPeriod = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Period'),
      ),
      body: Center(
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(
            6,
            (index) => PeriodNumberButton(
              periodNumber: index + 1,
              isSelected: true,
              onSelected: () {},
            ),
          ),
        ),
      ),
    );
  }
}