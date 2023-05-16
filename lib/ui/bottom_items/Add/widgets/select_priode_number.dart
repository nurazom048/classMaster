import 'package:flutter/material.dart';
import 'package:table/ui/bottom_items/Add/widgets/priode_select_buttons.dart';

import '../../../../constant/app_color.dart';
import '../widgets/add_squrebuttons.dart';

class PeriodNumberSelector extends StatefulWidget {
  final void Function(int)? onStartSelacted;
  final void Function(int)? onEndSelacted;

  final String hint;
  final String subhit;
  final int lenghht;
  final dynamic ontapToadd;

  const PeriodNumberSelector({
    Key? key,
    this.onStartSelacted,
    required this.onEndSelacted,
    required this.hint,
    required this.subhit,
    required this.lenghht,
    this.ontapToadd,
  }) : super(key: key);

  @override
  _PeriodNumberSelectorState createState() => _PeriodNumberSelectorState();
}

class _PeriodNumberSelectorState extends State<PeriodNumberSelector> {
  int intialselectedNumber = 0;
  int intalEnd = 0;

  void _handleNumberSelected(int number) {
    if (number != intialselectedNumber) {
      setState(() {
        intialselectedNumber = number;
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
            children: [
              Row(
                children: List.generate(
                  widget.lenghht,
                  (index) => PeriodNumberButton(
                    periodNumber: index + 1,
                    isSelected: intialselectedNumber == index,
                    onSelected: () => _handleNumberSelected(index),
                  ),
                ),
              ),
              newMethod()
            ],
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
            children: [
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
              newMethod(),
            ],
          ),
        ],
      ),
    );
  }

  AddSquareButton newMethod() {
    return AddSquareButton(
      onTap: widget.ontapToadd,
      isVisible: widget.ontapToadd == null ? false : true,
    );
  }
}
