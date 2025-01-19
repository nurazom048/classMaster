//
import 'package:flutter/material.dart';

import '../core/constant/app_color.dart';
import 'appWidget/app_text.dart';

class CustomTabBar extends StatelessWidget {
  final List<String> tabItems;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final EdgeInsetsGeometry? margin;

  const CustomTabBar({
    super.key,
    required this.tabItems,
    required this.selectedIndex,
    required this.onTabSelected,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: List.generate(tabItems.length, (index) {
          final isSelected = index == selectedIndex;

          final TextStyle textStyle = isSelected
              ? TS.opensensBlue(fontWeight: FontWeight.w400)
              : TS.opensensBlue(
                  fontWeight: FontWeight.w400, color: Colors.black);
          return Expanded(
            child: InkWell(
              onTap: () => onTabSelected(index),
              child: Stack(
                children: [
                  if (isSelected)
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Container(height: 4, color: AppColor.nokiaBlue),
                    ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(" ${tabItems[index]}", style: textStyle),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
