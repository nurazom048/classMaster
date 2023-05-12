import 'package:flutter/material.dart';

class AddSquareButton extends StatelessWidget {
  final dynamic onTap;
  final bool isVisible;

  const AddSquareButton(
      {Key? key, required this.onTap, required this.isVisible})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Positioned(
        left: 18,
        top: 7,
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: 50,
            height: 46,
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFF0168FF), width: 1),
              borderRadius: BorderRadius.circular(4),
              color: Color(0xFFEEF4FC),
            ),
            child: const Center(
              child: Text(
                '+',
                style: TextStyle(
                  color: Color(0xFF0168FF),
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  fontFamily: 'Open Sans',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
