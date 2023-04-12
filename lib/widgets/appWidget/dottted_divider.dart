import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

class DotedDivider extends StatelessWidget {
  const DotedDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const DottedLine(
      dashColor: Colors.black,
      dashGapLength: 5,
      dashLength: 5,
      lineThickness: 1,
      direction: Axis.horizontal,
    );
  }
}
