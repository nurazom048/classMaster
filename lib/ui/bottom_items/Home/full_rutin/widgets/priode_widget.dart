import 'package:flutter/material.dart';

import '../../../../../../helper/constant/AppColor.dart';
import '../../../../../../widgets/appWidget/appText.dart';

class PriodeWidget extends StatelessWidget {
  const PriodeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Text(
    //                     formatTime(
    //                       mypriodelist[index]["start_time"],
    //                     ),
    //                     style: const TextStyle(fontSize: 10)),
    //                 Text(formatTime(mypriodelist[index]["end_time"]),
    //                     style: const TextStyle(fontSize: 10)),
    return Container(
      margin: const EdgeInsets.only(right: 10, bottom: 10),
      height: 130,
      width: 130,
      child: Stack(
        children: [
          Positioned(
            top: 15,
            right: 45,
            child: CircleAvatar(
              radius: 24,
              backgroundColor: AppColor.nokiaBlue,
              child: AppText("1st", color: Colors.white).heding(),
            ),
          ),
          Positioned(
            bottom: 0,
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
                    AppText("8:45").heding(),
                    AppText("8:45").heding(),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
