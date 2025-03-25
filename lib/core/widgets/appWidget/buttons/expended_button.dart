// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';

import '../../../export_core.dart';

class ExpendedButton extends StatelessWidget {
  final dynamic onTap;
  final String? text;
  final IconData? icon;
  final bool isExpanded;
  const ExpendedButton({
    super.key,
    this.text,
    this.onTap,
    this.icon,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: onTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(isExpanded == true ? 'Close' : text ?? "Expand",
                  textScaleFactor: 1.2,
                  style: TextStyle(
                    color: AppColor.nokiaBlue,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    height: 1.2,
                  )),

              //

              Icon(
                icon ??
                    (isExpanded == false
                        ? Icons.expand_more
                        : Icons.expand_less),
                size: 20,
                color: AppColor.nokiaBlue,
              )
            ],
          ),
        ),
      ],
    );
  }
}
