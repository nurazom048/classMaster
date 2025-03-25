import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart' as fa;

import '../../constant/app_color.dart';
import '../appWidget/app_text.dart';

class BottomBarItemCustom extends StatelessWidget {
  final VoidCallback onTap;
  final bool isSelected;
  final IconData icon;
  final String label;

  const BottomBarItemCustom({
    required this.onTap,
    required this.isSelected,
    required this.icon,
    required this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColor.nokiaBlue : const Color(0xFFA7CBFF);

    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          fa.FaIcon(icon, color: color),
          const SizedBox(width: 5),
          Text(label, style: TS.opensensBlue(color: color, fontSize: 14)),
        ],
      ),
    );
  }
}
