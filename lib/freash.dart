import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> teachername = ["sat", "A", "b", "b", "b", "b"];
    List<String> teachername2 = ["sat", "A", "b", "b", "c"];
    List<String> fackteachername = [
      "sat",
    ];

    return Scaffold(
        body: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
                direction: Axis.horizontal,
                children: List.generate(
                    teachername.length,
                    (index) => Container(
                        decoration: BoxDecoration(
                            color: teachername[index] ==
                                    teachername[
                                        index + 1 > teachername.length - 1
                                            ? 0
                                            : index + 1]
                                ? Colors.amber
                                : Colors.black12,
                            border: Border(
                                right: BorderSide(
                                    color: Colors.black,
                                    width: teachername[index] ==
                                            teachername[index + 1 >
                                                    teachername.length - 1
                                                ? 0
                                                : index + 1]
                                        ? 0
                                        : 1))),
                        height: 100,
                        width: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              //index + 1 > teachername.length - 1
                              index + 1 > teachername.length - 1
                                  ? fackteachername[0]
                                  : teachername[index + 1] == teachername[index]
                                      ? "Same\n  ${teachername[index]}"
                                      : teachername[index],
                            ),
                            Text("subjectcode".toString()),
                            Text("roomnum".toString()),
                          ],
                        ))))));
  }
}
