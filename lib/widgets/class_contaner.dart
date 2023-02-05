// ignore_for_file: must_be_immutable, camel_case_types

import 'package:flutter/material.dart';

class myClassContainer extends StatelessWidget {
  String instractorname, roomnum, subCode;
  String? has_class;
  num start, end;
  DateTime startTime, endTime;
  dynamic onTap, onLongPress;
  dynamic weakdayIndex;

  myClassContainer({
    Key? key,
    required this.instractorname,
    required this.roomnum,
    required this.subCode,
    required this.start,
    required this.end,
    required this.startTime,
    required this.endTime,
    this.has_class,

    //
    this.onTap,
    this.onLongPress,
    required this.weakdayIndex,
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
          onLongPress: onLongPress,
          onTap: has_class == "no_class" ? onTap ?? () {} : () {},
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: getColor(weakdayIndex)),
            height: 100,
            width: contanerwith,
            child: has_class == "no_class"
                ? const Center(
                    child: Icon(Icons.clear_rounded),
                  )
                : Column(
                    children: [
                      _running(),
                      const Spacer(),
                      /////
                      Column(
                        children: [
                          Text(instractorname),
                          Text(roomnum),
                          Text(subCode),
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

  ///.... for changling color....//
  Color getColor(int indexofdate) {
    return indexofdate % 2 == 0
        ? const Color.fromRGBO(207, 213, 234, 1)
        : Colors.black12;
  }
}
