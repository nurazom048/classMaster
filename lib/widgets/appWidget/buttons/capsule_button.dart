import 'package:flutter/cupertino.dart';

import '../../../helper/constant/AppColor.dart';

class CapsuleButton extends StatelessWidget {
  final dynamic onTap;
  final String text;
  const CapsuleButton(
    this.text, {
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onTap,
      color: const Color(0xFFE4F0FF),
      borderRadius: BorderRadius.circular(19),
      padding: const EdgeInsets.all(10),
      minSize: 32,
      pressedOpacity: 0.5,
      child: Text(text, style: TextStyle(color: AppColor.nokiaBlue)),
    );
  }
}
