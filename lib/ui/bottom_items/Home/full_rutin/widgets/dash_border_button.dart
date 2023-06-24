import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../../../../../constant/app_color.dart';

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
      dashPattern: const [6, 6], // set the dash pattern
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

class DashBorderButtonMoni extends StatelessWidget {
  final String text;
  final IconData icon;
  final dynamic onTap;

  const DashBorderButtonMoni(
      {super.key, required this.text, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 34,
      child: InkWell(
        onTap: onTap,
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.circular(20),
          padding: const EdgeInsets.all(6),
          color: AppColor.nokiaBlue,
          dashPattern: const [6, 6], // set the dash pattern
          strokeWidth: 1,

          child: Center(
            child: SizedBox(
              // width: 80,
              // height: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$text  ',
                    style: const TextStyle(
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      height: 1.3,
                      color: Color(0xFF0168FF),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Icon(icon, color: AppColor.nokiaBlue, size: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
