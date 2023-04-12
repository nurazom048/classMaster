import 'package:flutter/material.dart';
import '../../../helper/constant/AppColor.dart';

class ExpendedButton extends StatelessWidget {
  final dynamic onTap;
  const ExpendedButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
            onTap: onTap,
            child:
                Text("Expand ", style: TextStyle(color: AppColor.nokiaBlue))),
        Icon(Icons.arrow_drop_down, color: AppColor.nokiaBlue)
      ],
    );
  }
}
