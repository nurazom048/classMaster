// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table/addrutin.dart';
import 'package:table/classdetals.dart';
import 'package:table/main.dart';
import 'package:table/moidels.dart';
import 'package:table/rutinprovider.dart';

class MyWidget extends StatelessWidget {
  //ignore: prefer_const_constructors_in_immutables
  MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Rutinprovider rutinprovider = Provider.of<Rutinprovider>(context);

    List sevendays = [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Saturday",
    ];

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            CustomTopBar("Kpi 7/1/ET-C", ontap: () {}),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TopContaner(
                              priode: 'Priode',
                              startTime: "sevendays",
                              endtime: "Time"),
                          ////date
                          Wrap(
                            direction: Axis.vertical,
                            children: List.generate(
                              sevendays.length,
                              (index) => Container(
                                decoration: BoxDecoration(
                                    color: index % 2 == 0
                                        ? const Color.fromRGBO(207, 213, 234, 1)
                                        : Colors.black12,
                                    border: const Border(
                                        right: BorderSide(
                                            color: Colors.black, width: 1))),
                                height: 100,
                                width: 100,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(sevendays[index]),
                                    InkWell(
                                      onTap: (() {}),
                                      child: IconButton(
                                          onPressed: (() {
                                            Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                    fullscreenDialog: true,
                                                    builder: (context) =>
                                                        addrutinpage(
                                                          indexxx: index,
                                                        )));
                                          }),
                                          icon: const Icon(Icons.add)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Wrap(
                          direction: Axis.horizontal,
                          children: List.generate(
                            7,
                            (index) => TopContaner(
                              priode: "${index + 1}",
                              startTime: "8:00",
                              endtime: "8:45",
                            ),
                          ),
                        ),

                        ////////////////////////////// class data

                        Wrap(
                          direction: Axis.vertical,
                          children: List.generate(
                            rutinprovider.classdataprovider.length,
                            ((classindex) => Wrap(
                                  direction: Axis.horizontal,
                                  children: List.generate(
                                    rutinprovider.classdataprovider[classindex]
                                        .date.length,
                                    (index) => InkWell(
                                      onTap: rutinprovider
                                                  .classdataprovider[classindex]
                                                  .date[index]
                                                  .subjectcode
                                                  .toString() ==
                                              "00"
                                          ? null
                                          : () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => Classdetails(
                                                        classdate: rutinprovider
                                                            .classdataprovider[
                                                                classindex]
                                                            .date[index])),
                                              ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: classindex % 2 == 0
                                                ? const Color.fromRGBO(
                                                    207, 213, 234, 1)
                                                : Colors.black12,
                                            border: const Border(
                                                right: BorderSide(
                                                    color: Colors.black,
                                                    width: 1))),
                                        height: 100,
                                        width: (((rutinprovider
                                                        .classdataprovider[
                                                            classindex]
                                                        .date[index]
                                                        .endingpriode) -
                                                    (rutinprovider
                                                        .classdataprovider[
                                                            classindex]
                                                        .date[index]
                                                        .startingpriode)) >
                                                0
                                            ? 100 *
                                                ((rutinprovider
                                                            .classdataprovider[
                                                                classindex]
                                                            .date[index]
                                                            .endingpriode -
                                                        rutinprovider
                                                            .classdataprovider[
                                                                classindex]
                                                            .date[index]
                                                            .startingpriode) +
                                                    1)
                                            : 100),
                                        child: rutinprovider
                                                    .classdataprovider[
                                                        classindex]
                                                    .date[index]
                                                    .subjectcode
                                                    .toString() ==
                                                "00"
                                            ? const Center(
                                                child: Icon(Icons.clear))
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(rutinprovider
                                                      .classdataprovider[
                                                          classindex]
                                                      .date[index]
                                                      .instructorname),
                                                  Text(rutinprovider
                                                      .classdataprovider[
                                                          classindex]
                                                      .date[index]
                                                      .subjectcode),
                                                  Text(rutinprovider
                                                      .classdataprovider[
                                                          classindex]
                                                      .date[index]
                                                      .roomnum),
                                                  // Text((((rutinprovider.classdataprovider[classindex]
                                                  //                 .date[index]
                                                  //                 .endingpriode) -
                                                  //             (rutinprovider.classdataprovider[classindex]
                                                  //                 .date[index]
                                                  //                 .startingpriode)) +
                                                  //         1)
                                                  //     .toString()),
                                                ],
                                              ),
                                      ),
                                    ),
                                  ),
                                )),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTopBar extends StatelessWidget {
  String title;

  // ignore: prefer_typing_uninitialized_variables
  var ontap;
  CustomTopBar(
    this.title, {
    required this.ontap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(9.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.pop(context)),
            Text(title),
            IconButton(icon: const Icon(Icons.edit), onPressed: ontap),
          ],
        ));
  }
}
