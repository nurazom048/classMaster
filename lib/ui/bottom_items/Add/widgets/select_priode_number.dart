// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:classmate/core/dialogs/alert_dialogs.dart';
import 'package:classmate/ui/bottom_items/Add/widgets/add_squrebuttons.dart';
import 'package:classmate/ui/bottom_items/Add/widgets/priode_select_buttons.dart';

import '../../../../constant/app_color.dart';

class PeriodNumberSelector extends StatefulWidget {
  final void Function(int)? onStartSelected;
  final void Function(int)? onEndSelected;

  final String hint;
  final String subHint;
  final int length;
  final dynamic onTapToAdd;
  final bool? viewOnly;

  const PeriodNumberSelector({
    Key? key,
    this.onStartSelected,
    required this.onEndSelected,
    required this.hint,
    required this.subHint,
    required this.length,
    this.viewOnly,
    this.onTapToAdd,
  }) : super(key: key);

  @override
  _PeriodNumberSelectorState createState() => _PeriodNumberSelectorState();
}

class _PeriodNumberSelectorState extends State<PeriodNumberSelector> {
  int initialSelectedNumber = 0;
  int initialEnd = 0;

  void _handleNumberSelected(int number) {
    if (widget.viewOnly == true) {
      Alert.showSnackBar(context, "You Can't Change here");
    } else if (number != initialSelectedNumber) {
      setState(() {
        initialSelectedNumber = number;
      });
    }
    widget.onStartSelected?.call(number + 1);
  }

  void _handleEnd(int number) {
    if (widget.viewOnly == true) {
      Alert.showSnackBar(context, "You Can't Change here");
    } else if (number != initialEnd) {
      setState(() {
        initialEnd = number;
      });
    }
    widget.onEndSelected?.call(number + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Select Start Period
          Text(widget.hint,
              style: TextStyle(
                  fontFamily: 'Open Sans',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                  height: 1.3,
                  color: AppColor.nokiaBlue)),
          const SizedBox(height: 5),

          Row(
            children: [
              ...List.generate(
                widget.length,
                (index) {
                  return PeriodNumberButton(
                    periodNumber: index + 1,
                    isSelected: initialSelectedNumber == index,
                    onSelected: () => _handleNumberSelected(index),
                  );
                },
              ),
              AddSquareButton(
                onTap: widget.onTapToAdd,
                isVisible: widget.onTapToAdd == null ? false : true,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Select End Period
          Text(widget.subHint,
              style: TextStyle(
                  fontFamily: 'Open Sans',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                  height: 1.3,
                  color: AppColor.nokiaBlue)),
          const SizedBox(height: 5),

          Row(
            children: [
              ...List.generate(
                widget.length,
                (index) {
                  return PeriodNumberButton(
                    periodNumber: index + 1,
                    isSelected: initialEnd == index,
                    onSelected: () => _handleEnd(index),
                  );
                },
              ),
              AddSquareButton(
                onTap: widget.onTapToAdd,
                isVisible: widget.onTapToAdd == null ? false : true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
