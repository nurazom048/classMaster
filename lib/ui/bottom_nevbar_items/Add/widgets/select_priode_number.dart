// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:classmate/core/dialogs/alert_dialogs.dart';
import 'package:classmate/ui/bottom_nevbar_items/Add/widgets/add_squrebuttons.dart';
import 'package:classmate/ui/bottom_nevbar_items/Add/widgets/priode_select_buttons.dart';

import '../../../../core/constant/app_color.dart';

class PeriodNumberSelector extends StatefulWidget {
  final void Function(int)? onStartSelected;
  final void Function(int)? onEndSelected;

  final String hint;
  final String subHint;
  final int length;
  final dynamic onTapToAdd;
  final bool? viewOnly;
  final int? initialStartNumber;
  final int? initialEndNumber;

  const PeriodNumberSelector({
    Key? key,
    this.onStartSelected,
    required this.onEndSelected,
    required this.hint,
    required this.subHint,
    required this.length,
    this.viewOnly,
    this.onTapToAdd,
    this.initialStartNumber,
    this.initialEndNumber,
  }) : super(key: key);

  @override
  _PeriodNumberSelectorState createState() => _PeriodNumberSelectorState();
}

class _PeriodNumberSelectorState extends State<PeriodNumberSelector> {
  int initialStartNumber = 0;
  int initialEndNumber = 0;

  void _handleNumberSelected(int number) {
    if (widget.viewOnly == true) {
      Alert.showSnackBar(context, "You Can't Change here");
    } else if (number != initialStartNumber) {
      setState(() {
        initialStartNumber = number;
      });
    }
    widget.onStartSelected?.call(number + 1);
  }

  void _handleEnd(int number) {
    if (widget.viewOnly == true) {
      Alert.showSnackBar(context, "You Can't Change here");
    } else if (number != initialEndNumber) {
      setState(() {
        initialEndNumber = number;
      });
    }
    widget.onEndSelected?.call(number + 1);
  }

  @override
  void initState() {
    if (widget.initialEndNumber != null && widget.initialEndNumber != null) {
      initialStartNumber = widget.initialEndNumber! - 1;
      initialEndNumber = widget.initialEndNumber! - 1;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
      // width: MediaQuery.of(context).size.width,
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

          SizedBox(
            height: 65,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(right: 100),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: widget.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    PeriodNumberButton(
                      periodNumber: index + 1,
                      isSelected: initialStartNumber == index,
                      onSelected: () => _handleNumberSelected(index),
                    ),
                    //
                    // last of the list show add priode Button
                    //
                    if (widget.length - 1 == index)
                      AddSquareButton(
                        onTap: widget.onTapToAdd,
                        isVisible: widget.onTapToAdd == null ? false : true,
                      ),
                  ],
                );
              },
            ),
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
          SizedBox(
            height: 65,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(right: 100),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: widget.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    PeriodNumberButton(
                      periodNumber: index + 1,
                      isSelected: initialEndNumber == index,
                      onSelected: () => _handleEnd(index),
                    ),
                    //
                    // last of the list show add priode Button
                    //
                    if (widget.length - 1 == index)
                      AddSquareButton(
                        onTap: widget.onTapToAdd,
                        isVisible: widget.onTapToAdd == null ? false : true,
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
