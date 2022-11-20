// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table/addrutin.dart';
import 'package:table/classdetals.dart';
import 'package:table/main.dart';
import 'package:table/rutinprovider.dart';

class RutinPage extends StatelessWidget {
  const RutinPage({super.key});

  @override
  Widget build(BuildContext context) {
    List sevendays = [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Saturday",
    ];

    Rutinprovider rutinprovider = Provider.of<Rutinprovider>(context);
    PriodeDateProvider priodedataProvider =
        Provider.of<PriodeDateProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              CustomTopBar("Kpi 7/1/ET-C", ontap: () {}),
              SingleChildScrollView(
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
                            endtime: "",
                            iconn: Icons.add,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      fullscreenDialog: true,
                                      builder: (context) =>
                                          AddOrEdditPriode()));
                            },
                          ),
                          ////date
                          Wrap(
                            direction: Axis.vertical,
                            children: List.generate(
                              sevendays.length,
                              (indexofdate) => Container(
                                decoration: BoxDecoration(
                                    color: indexofdate % 2 == 0
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
                                    Text(sevendays[indexofdate]),
                                    InkWell(
                                      onTap: (() {}),
                                      child: IconButton(
                                          onPressed: (() {
                                            Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                    fullscreenDialog: true,
                                                    builder: (context) =>
                                                        AddRutin(
                                                            indexofdate:
                                                                indexofdate)));
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
                            priodedataProvider.priodelist.isEmpty
                                ? 1
                                : priodedataProvider.priodelist.length,
                            //   priode row
                            (index) => InkWell(
                              onLongPress: () => ShowProdeButtomAction(
                                  context, priodedataProvider, index),
                              child: priodedataProvider.priodelist.isEmpty
                                  ? TopContaner(
                                      priode: "Add Priode frist",
                                      startTime: "8:00",
                                      endtime: "8.45")
                                  : TopContaner(
                                      priode: "${index + 1}",
                                      startTime: priodedataProvider
                                          .priodelist[index].startingpriode,
                                      endtime: priodedataProvider
                                          .priodelist[index].endingpriode,
                                    ),
                            ),
                          ),
                        ),
                        //           class data Row

                        Wrap(
                          direction: Axis.vertical,
                          children: List.generate(
                            rutinprovider.classdataprovider.length,
                            ((indexofdate) => Wrap(
                                  direction: Axis.horizontal,
                                  children: List.generate(
                                    rutinprovider.classdataprovider[indexofdate]
                                            .date.isEmpty
                                        ? 1
                                        : rutinprovider
                                            .classdataprovider[indexofdate]
                                            .date
                                            .length,
                                    (index) => rutinprovider
                                            .classdataprovider[indexofdate]
                                            .date
                                            .isEmpty
                                        ? Container(
                                            height: 100,
                                            width: 100,
                                            color: indexofdate.isEven
                                                ? const Color.fromRGBO(
                                                    207, 213, 234, 1)
                                                : Colors.black12,
                                          )
                                        : InkWell(
                                            onLongPress: () =>
                                                ShowClassButtomSheet(
                                                    context,
                                                    indexofdate,
                                                    rutinprovider,
                                                    index),
                                            onTap: () => rutinprovider
                                                        .classdataprovider[
                                                            indexofdate]
                                                        .date[index]
                                                        .subjectcode
                                                        .toString() ==
                                                    "00"
                                                ? null
                                                : Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                        fullscreenDialog: true,
                                                        builder: (context) => Classdetails(
                                                            classdate: rutinprovider
                                                                .classdataprovider[
                                                                    indexofdate]
                                                                .date[index])),
                                                  ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: indexofdate % 2 == 0
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
                                                                  indexofdate]
                                                              .date[index]
                                                              .endingpriode) -
                                                          (rutinprovider
                                                              .classdataprovider[
                                                                  indexofdate]
                                                              .date[index]
                                                              .startingpriode)) >
                                                      0
                                                  ? 100 *
                                                      ((rutinprovider
                                                                  .classdataprovider[
                                                                      indexofdate]
                                                                  .date[index]
                                                                  .endingpriode -
                                                              rutinprovider
                                                                  .classdataprovider[
                                                                      indexofdate]
                                                                  .date[index]
                                                                  .startingpriode) +
                                                          1)
                                                  : 100),
                                              child: rutinprovider
                                                          .classdataprovider[
                                                              indexofdate]
                                                          .date[index]
                                                          .subjectcode
                                                          .toString() ==
                                                      "00"
                                                  ? const Center(
                                                      child: Icon(Icons.clear))
                                                  : Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(rutinprovider
                                                            .classdataprovider[
                                                                indexofdate]
                                                            .date[index]
                                                            .instructorname),
                                                        Text(rutinprovider
                                                            .classdataprovider[
                                                                indexofdate]
                                                            .date[index]
                                                            .subjectcode),
                                                        Text(rutinprovider
                                                            .classdataprovider[
                                                                indexofdate]
                                                            .date[index]
                                                            .roomnum),
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
            ],
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Future<dynamic> ShowClassButtomSheet(BuildContext context, int indexofdate,
      Rutinprovider rutinprovider, int index) {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text(" Do you want to.. ",
            style: TextStyle(fontSize: 22, color: Colors.black87)),
        actions: [
          CupertinoActionSheetAction(
              child: const Text("Eddit"),

              // go to eddit
              onPressed: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => AddRutin(
                            indexofdate: indexofdate,
                            classdata: rutinprovider
                                .classdataprovider[indexofdate].date[index],
                            iseddit: true,
                          )))),
          CupertinoActionSheetAction(
              child: const Text("Remove", style: TextStyle(color: Colors.red)),
              onPressed: () {
                rutinprovider.removeclass(indexofdate, index);
                Navigator.pop(context);
              }),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text("cancel"),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Future<dynamic> ShowProdeButtomAction(
      BuildContext context, PriodeDateProvider priodedataProvider, int index) {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text(" Do you want to.. ",
            style: TextStyle(fontSize: 22, color: Colors.black87)),
        actions: [
          CupertinoActionSheetAction(
            child: const Text("Eddit"), // go to eddit

            onPressed: () => Navigator.push(
                context,
                CupertinoPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => AddOrEdditPriode(
                          isedditing: true,
                          priode: priodedataProvider.priodelist[index],
                        ))),
          ),
          CupertinoActionSheetAction(
            ///// for remove item by index
            child: const Text("Remove", style: TextStyle(color: Colors.red)),
            onPressed: () {
              Provider.of<PriodeDateProvider>(context, listen: false)
                  .remove(index);
              Navigator.pop(context);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text("cancel"),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}

class CustomTopBar extends StatelessWidget {
  String title;

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
