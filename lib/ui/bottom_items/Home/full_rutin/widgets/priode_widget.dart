import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../widgets/appWidget/appText.dart';
import '../../../../../helper/constant/app_color.dart';

class PriodeWidget extends StatelessWidget {
  const PriodeWidget({
    required this.startTime,
    required this.endTime,
    required this.priodeNumber,
    required this.onLongpress,
    super.key,
  });

  final DateTime startTime, endTime;
  final num priodeNumber;
  final dynamic onLongpress;
  @override
  Widget build(BuildContext context) {
    String formatTime(DateTime dateTime) {
      return DateFormat('h:mm a').format(dateTime);
    }

    return Container(
      //margin: const EdgeInsets.only(right: 10, bottom: 10),
      height: 110,
      width: 130,
      child: Stack(
        children: [
          Positioned(
            top: 15,
            right: 45,
            child: CircleAvatar(
              radius: 24,
              backgroundColor: AppColor.nokiaBlue,
              child: AppText("${priodeNumber}st", color: Colors.white).heding(),
            ),
          ),
          Positioned(
            top: 40,
            child: InkWell(
              onLongPress: onLongpress,
              child: Container(
                  height: 90,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: 130,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black12)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(height: 10),
                      AppText(formatTime(startTime)).heding(),
                      AppText(formatTime(endTime)).heding(),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
