import 'package:flutter/material.dart';
import 'package:table/helper/constant/app_color.dart';
import 'package:table/ui/bottom_items/Add/widgets/priode_select_buttons.dart';

class PeriodNumberSelector extends StatefulWidget {
  final void Function(int)? onStartSelacted;
  final void Function(int)? onEndSelacted;

  final String hint;
  final String subhit;
  final int lenghht;

  const PeriodNumberSelector({
    Key? key,
    this.onStartSelacted,
    required this.onEndSelacted,
    required this.hint,
    required this.subhit,
    required this.lenghht,
  }) : super(key: key);

  @override
  _PeriodNumberSelectorState createState() => _PeriodNumberSelectorState();
}

class _PeriodNumberSelectorState extends State<PeriodNumberSelector> {
  int IntialselectedNumber = 0;
  int intalEnd = 0;

  void _handleNumberSelected(int number) {
    if (number != IntialselectedNumber) {
      setState(() {
        IntialselectedNumber = number;
      });
    }
    widget.onStartSelacted?.call(number + 1);
  }

  void _enthandeler(int number) {
    if (number != intalEnd) {
      setState(() {
        intalEnd = number;
      });
    }
    widget.onEndSelacted?.call(number + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      height: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.hint,
            style: TextStyle(
                fontFamily: 'Open Sans',
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
                height: 1.3,
                color: AppColor.nokiaBlue),
          ),
          Row(
            children: List.generate(
              widget.lenghht,
              (index) => PeriodNumberButton(
                periodNumber: index + 1,
                isSelected: IntialselectedNumber == index,
                onSelected: () => _handleNumberSelected(index),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            widget.subhit,
            style: TextStyle(
                fontFamily: 'Open Sans',
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
                height: 1.3,
                color: AppColor.nokiaBlue),
          ),
          Row(
            children: List.generate(
              widget.lenghht,
              (index) => PeriodNumberButton(
                periodNumber: index + 1,
                isSelected: intalEnd == index,
                onSelected: () => _enthandeler(index),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
