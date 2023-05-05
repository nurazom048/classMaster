import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../../../../../helper/constant/app_color.dart';

class DashBorderButton extends StatelessWidget {
  const DashBorderButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: const Radius.circular(20),
      padding: const EdgeInsets.all(6),
      color: AppColor.nokiaBlue,
      dashPattern: [6, 6], // set the dash pattern
      strokeWidth: 1,

      child: Center(
        child: SizedBox(
          width: 200,
          height: 40,
          child: Row(
            children: [
              const Text(
                'Send Invitation(s)  ',
                style: TextStyle(
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  height: 1.3,
                  color: Color(0xFF0168FF),
                ),
                textAlign: TextAlign.center,
              ),
              Icon(Icons.send, color: AppColor.nokiaBlue, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
