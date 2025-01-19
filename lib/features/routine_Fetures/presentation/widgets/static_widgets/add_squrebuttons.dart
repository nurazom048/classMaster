import 'package:flutter/material.dart';

import '../../../../../core/widgets/appWidget/app_text.dart';

class AddSquareButton extends StatelessWidget {
  final dynamic onTap;
  final bool isVisible;

  const AddSquareButton(
      {Key? key, required this.onTap, required this.isVisible})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Visibility(
        visible: isVisible,
        child: Container(
          width: 50,
          height: 46,
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(width: 1, color: const Color(0xFF0168FF)),
          ),
          child: Center(
            child: Text('+', style: TS.opensensBlue(fontSize: 25)),
          ),
        ),
      ),
    );
  }
}
