import 'package:flutter/cupertino.dart';
import '../../../helper/constant/AppColor.dart';

class CapsuleButton extends StatelessWidget {
  final dynamic onTap;
  final String text;
  final Color? color;
  final IconData? icon;
  const CapsuleButton(
    this.text, {
    super.key,
    required this.onTap,
    this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onTap,
      color: const Color(0xFFE4F0FF),
      borderRadius: BorderRadius.circular(19),
      padding: const EdgeInsets.all(8),
      minSize: 32,
      pressedOpacity: 0.5,
      child: Row(
        children: [
          Text(text,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style:
                  TextStyle(fontSize: 16, color: color ?? AppColor.nokiaBlue)),
          const SizedBox(width: 5),
          if (icon != null)
            Icon(icon, size: 20, color: color ?? AppColor.nokiaBlue),
        ],
      ),
    );
  }
}
