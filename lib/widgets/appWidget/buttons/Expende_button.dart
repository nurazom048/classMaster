import 'package:flutter/material.dart';
import '../../../helper/constant/AppColor.dart';

class ExpendedButton extends StatelessWidget {
  final dynamic onTap;
  final String? text;
  final IconData? icon;
  const ExpendedButton({
    super.key,
    this.text,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: onTap,
          child: Text(text ?? "Expand",
              textScaleFactor: 1.2,
              style: TextStyle(
                color: AppColor.nokiaBlue,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w400,
                fontSize: 12,
                height: 1.33,
              )),
        ),
        icon == null
            ? ExpandIcon(onPressed: (click) {})
            : Icon(
                icon,
                color: AppColor.nokiaBlue,
                size: 16,
              )
      ],
    );
  }
}
