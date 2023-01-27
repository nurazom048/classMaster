import 'package:flutter/material.dart';

class myClassContainer extends StatelessWidget {
  String instractorname, roomnum, subCode;
  double start, end;
  DateTime startTime, endTime;
  dynamic onTap;

  myClassContainer({
    Key? key,
    required this.instractorname,
    required this.roomnum,
    required this.subCode,
    required this.start,
    required this.end,
    required this.startTime,
    required this.endTime,
    //
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double contanerwith = 100;
//... foe Contaner with...//
    if (end - start > 1 && end - start != 0 && end - start > 0) {
      contanerwith = (end - start) * 100;
    }
    return Row(
      children: [
        InkWell(
          onTap: onTap ?? () {},
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3), color: Colors.blueGrey),
            height: 100,
            width: contanerwith,
            child: Column(
              children: [
                _running(),
                const Spacer(),
                /////
                Column(
                  children: [
                    Text(instractorname),
                    Text(roomnum),
                    Text(subCode),

                    //  Text(startTime.hour.toString()),
                    // Text(endTime.minute.toString()),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Row _running() {
    return Row(
      children: const [
        SizedBox(width: 10),
        CircleAvatar(
          backgroundColor: Colors.red,
          radius: 4,
        ),
        Text("   Running"),
        Spacer(flex: 7),
      ],
    );
  }
}
