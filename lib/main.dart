import 'package:flutter/material.dart';
import 'package:table/dataTable.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Tabile3(),
      // home: DataTAble(),
    );
  }
}

class Tabile3 extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  Tabile3({super.key});

  @override
  Widget build(BuildContext context) {
    List<Priodemodel> priode = [
      Priodemodel(classinfo: [
        Classmodel(
            instructorname: "Msdnasdf",
            subjectcode: "12sasds3",
            mainpic: "dfssa",
            classsumary: "clasdssafssumary",
            roomnum: ''),
        Classmodel(
            instructorname: "fs",
            subjectcode: "123",
            mainpic: "dsf",
            classsumary: "classsumary",
            roomnum: ''),
        Classmodel(
            instructorname: "UfKsdR",
            subjectcode: "6671sd1",
            mainpic: "",
            classsumary: "classdssumary",
            roomnum: ''),
        Classmodel(
            instructorname: "TMADSsJ",
            subjectcode: "3",
            mainpic: "",
            classsumary: "classsrsumary",
            roomnum: ''),
        Classmodel(
            instructorname: "Mnewee",
            subjectcode: "12ee3",
            mainpic: "",
            classsumary: "clasdwessumary",
            roomnum: ''),
      ]),

      ///
      Priodemodel(classinfo: [
        Classmodel(
            instructorname: "Mnsse",
            subjectcode: "123",
            mainpic: "",
            classsumary: "classsumarysf",
            roomnum: ''),
        Classmodel(
            instructorname: "Mdsn",
            subjectcode: "123",
            mainpic: "",
            classsumary: "classsssumary",
            roomnum: ''),
        Classmodel(
            instructorname: "UKsRs",
            subjectcode: "66711",
            mainpic: "",
            classsumary: "classsusmary",
            roomnum: ''),
        Classmodel(
            instructorname: "TMsJs",
            subjectcode: "3",
            mainpic: "",
            classsumary: "classsumary",
            roomnum: ''),
        Classmodel(
            instructorname: "Msn",
            subjectcode: "123",
            mainpic: "",
            classsumary: "classssusmary",
            roomnum: ''),
      ]),

      Priodemodel(
        classinfo: [
          Classmodel(
              instructorname: "Mnsse",
              subjectcode: "123",
              mainpic: "",
              classsumary: "classsumarysf",
              roomnum: ''),
          Classmodel(
              instructorname: "Mnd",
              subjectcode: "123",
              mainpic: "",
              classsumary: "classsumafry",
              roomnum: ''),
          Classmodel(
              instructorname: "UfRd",
              subjectcode: "66711",
              mainpic: "",
              classsumary: "classdsfumary",
              roomnum: ''),
          Classmodel(
              instructorname: "TMsdsJ",
              subjectcode: "3",
              mainpic: "",
              classsumary: "classszsumary",
              roomnum: ''),
          Classmodel(
              instructorname: "Mn",
              subjectcode: "123",
              mainpic: "",
              classsumary: "classsssumary",
              roomnum: ''),
        ],
      ),

      ///
      Priodemodel(classinfo: [
        Classmodel(
            instructorname: "Mssn",
            subjectcode: "123",
            mainpic: "",
            classsumary: "classssumasry",
            roomnum: ''),
        Classmodel(
            instructorname: "Msn",
            subjectcode: "123",
            mainpic: "",
            classsumary: "classsssumary",
            roomnum: ''),
        Classmodel(
            instructorname: "UKsR",
            subjectcode: "66711",
            mainpic: "",
            classsumary: "classsusmary",
            roomnum: ''),
        Classmodel(
            instructorname: "TMJs",
            subjectcode: "3",
            mainpic: "",
            classsumary: "classsumary",
            roomnum: ''),
        Classmodel(
            instructorname: "Mn",
            subjectcode: "123",
            mainpic: "",
            classsumary: "classssusmary",
            roomnum: ''),
      ]),
      Priodemodel(classinfo: [
        Classmodel(
            instructorname: "Mn",
            subjectcode: "123",
            mainpic: "",
            classsumary: "classsumary",
            roomnum: ''),
        Classmodel(
            instructorname: "f",
            subjectcode: "123",
            mainpic: "",
            classsumary: "classsumary",
            roomnum: ''),
        Classmodel(
            instructorname: "UfKR",
            subjectcode: "66711",
            mainpic: "",
            classsumary: "classsumary",
            roomnum: ''),
        Classmodel(
            instructorname: "TMJ",
            subjectcode: "3",
            mainpic: "",
            classsumary: "classsrumary",
            roomnum: ''),
        Classmodel(
            instructorname: "Mne",
            subjectcode: "123",
            mainpic: "",
            classsumary: "clasdssumary",
            roomnum: ''),
      ]),

      Priodemodel(
        classinfo: [
          Classmodel(
              instructorname: "Mne",
              subjectcode: "123",
              mainpic: "",
              classsumary: "classsumarysf",
              roomnum: ''),
          Classmodel(
              instructorname: "Mnd",
              subjectcode: "123",
              mainpic: "",
              classsumary: "classsumafry",
              roomnum: ''),
          Classmodel(
              instructorname: "UfRd",
              subjectcode: "66711",
              mainpic: "",
              classsumary: "classdsfumary",
              roomnum: ''),
          Classmodel(
              instructorname: "TMsdsJ",
              subjectcode: "3",
              mainpic: "",
              classsumary: "classszsumary",
              roomnum: ''),
          Classmodel(
              instructorname: "Mn",
              subjectcode: "123",
              mainpic: "",
              classsumary: "classsssumary",
              roomnum: ''),
        ],
      ),

      ///
      Priodemodel(classinfo: [
        Classmodel(
            instructorname: "Mssn",
            subjectcode: "123",
            mainpic: "",
            classsumary: "classssumasry",
            roomnum: ''),
        Classmodel(
            instructorname: "Msn",
            subjectcode: "123",
            mainpic: "",
            classsumary: "classsssumary",
            roomnum: ''),
        Classmodel(
            instructorname: "UKsR",
            subjectcode: "66711",
            mainpic: "",
            classsumary: "classsusmary",
            roomnum: ''),
        Classmodel(
            instructorname: "TMJs",
            subjectcode: "3",
            mainpic: "",
            classsumary: "classsumary",
            roomnum: ''),
        Classmodel(
            instructorname: "Mn",
            subjectcode: "123",
            mainpic: "",
            classsumary: "classssusmary",
            roomnum: ''),
      ]),

      ///
      Priodemodel(classinfo: [
        Classmodel(
            instructorname: "Mssn",
            subjectcode: "123",
            mainpic: "",
            classsumary: "classssumasry",
            roomnum: ''),
        Classmodel(
            instructorname: "Msn",
            subjectcode: "123",
            mainpic: "",
            classsumary: "classsssumary",
            roomnum: ''),
        Classmodel(
            instructorname: "UKsR",
            subjectcode: "66711",
            mainpic: "",
            classsumary: "classsusmary",
            roomnum: ''),
        Classmodel(
            instructorname: "TMJs",
            subjectcode: "3",
            mainpic: "",
            classsumary: "classsumary",
            roomnum: ''),
        Classmodel(
            instructorname: "Mn",
            subjectcode: "123",
            mainpic: "",
            classsumary: "classssusmary",
            roomnum: ''),
      ]),
      Priodemodel(classinfo: [
        Classmodel(
            instructorname: "Ms45y6sn",
            subjectcode: "1wr23",
            mainpic: "",
            classsumary: "classswetsumasry",
            roomnum: ''),
        Classmodel(
            instructorname: "wrMsn",
            subjectcode: "123",
            mainpic: "",
            classsumary: "classwrsssumary",
            roomnum: ''),
        Classmodel(
            instructorname: "UwqerKsR",
            subjectcode: "66711",
            mainpic: "",
            classsumary: "classsusmary",
            roomnum: ''),
        Classmodel(
            instructorname: "TMqrJs",
            subjectcode: "3",
            mainpic: "",
            classsumary: "classsumaqwery",
            roomnum: ''),
        Classmodel(
          instructorname: "Mqwen",
          subjectcode: "123",
          mainpic: "",
          classsumary: "classssuqesmary",
          roomnum: '',
        )
      ])
    ];

    List fack = [
      Classmodel(
          instructorname: "Ms45y6sn",
          subjectcode: "1wr23",
          mainpic: "",
          classsumary: "classswetsumasry",
          roomnum: ''),
      Classmodel(
          instructorname: "wrMsn",
          subjectcode: "123",
          mainpic: "",
          classsumary: "classwrsssumary",
          roomnum: ''),
      Classmodel(
          instructorname: "UwqerKsR",
          subjectcode: "66711",
          mainpic: "",
          classsumary: "classsusmary",
          roomnum: ''),
      Classmodel(
          instructorname: "TMqrJs",
          subjectcode: "3",
          mainpic: "",
          classsumary: "classsumaqwery",
          roomnum: ''),
      Classmodel(
          instructorname: "Mqwen",
          subjectcode: "123",
          mainpic: "",
          classsumary: "classssuqesmary",
          roomnum: '')
    ];
    List sevendays = [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "classinfourday"
    ];
    //List set = ["Set", "mn", "mn", "usr", "4"];

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TopContaner(
                    priode: 'Priode', startTime: "sevendays", endtime: "Time"),
                Wrap(
                  //direction: Axis.horizontal,
                  children: List.generate(
                    sevendays.length,
                    (index) => TopContaner(
                      priode: "${index + 1}",
                      startTime: "8:00",
                      endtime: "8:45",
                    ),
                  ),
                ),
//////// 2nd
              ],
            ),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ///************ 7 days******************** */
              SevenDays(),

              ///************ Priode In Column******************** */
              Wrap(
                children: List.generate(
                    7,
                    (index) => pridodeincolumn(
                        classinfo: priode[index].classinfo,
                        comperpriodmodel:
                            priode[index + 1 > index ? 0 : index + 1]
                                .classinfo)),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

class SevenDays extends StatelessWidget {
  const SevenDays({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List sevendays = [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
    ];
    return Wrap(
      direction: Axis.vertical,
      children: List.generate(
        sevendays.length,
        (index) => Container(
            decoration: BoxDecoration(
                color: index % 2 == 0
                    ? const Color.fromRGBO(68, 114, 196, 161)
                    : const Color.fromRGBO(191, 191, 191, 161),
                border: const Border(
                    right: BorderSide(color: Colors.black45, width: 1))),
            height: 100,
            width: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(sevendays[index]),
              ],
            )),
      ),
    );
  }
}

// ignore: camel_case_types, must_be_immutable
class pridodeincolumn extends StatelessWidget {
  List<Classmodel> classinfo;
  List<Classmodel> comperpriodmodel;

  // ignore: prefer_const_constructors_in_immutables
  pridodeincolumn({
    Key? key,
    required this.classinfo,
    required this.comperpriodmodel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
        direction: Axis.vertical,
        children: List.generate(
          classinfo.length,
          (index) => ClassContaner(
            teachername: comperpriodmodel[index].instructorname ==
                    classinfo[index].instructorname
                ? "same"
                : classinfo[index].instructorname,
            subjectcode: 666,
            roomnum: 11,
            onTap: () {},
            color: index % 2 == 0
                ? const Color.fromRGBO(68, 114, 196, 161)
                : const Color.fromRGBO(191, 191, 191, 161),
            comperpriodmodel: comperpriodmodel,
          ),
        ));
  }
}

// ignore: must_be_immutable
class ClassContaner extends StatelessWidget {
  Color? color;
  String teachername;
  int subjectcode, roomnum;
  // ignore: prefer_typing_uninitialized_variables
  var onTap, bordercolor;
  List<Classmodel> comperpriodmodel;

  ClassContaner({
    Key? key,
    required this.color,
    required this.comperpriodmodel,
    required this.teachername,
    required this.roomnum,
    required this.subjectcode,
    required this.onTap,
    this.bordercolor = Colors.black45,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
              color: color,
              border: Border(right: BorderSide(color: bordercolor, width: 1))),
          height: 100,
          width: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(teachername),
              Text(subjectcode.toString()),
              Text(roomnum.toString()),
            ],
          )),
    );
  }
}

// ignore: must_be_immutable
class TopContaner extends StatelessWidget {
  String priode, startTime, endtime;
  TopContaner({
    Key? key,
    required this.priode,
    required this.startTime,
    required this.endtime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 100,
      // ignore: prefer_const_constructors
      decoration: BoxDecoration(
          color: const Color.fromRGBO(68, 114, 196, 30),
          border:
              const Border(right: BorderSide(color: Colors.black45, width: 1))),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(priode),
          const Divider(color: Colors.black87, height: 18, thickness: .5),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text("$startTime \n$endtime"),
          ),
        ],
      ),
    );
  }
}

class Classmodel {
  String instructorname, subjectcode, roomnum, mainpic, classsumary;

  Classmodel({
    required this.instructorname,
    required this.subjectcode,
    required this.mainpic,
    required this.classsumary,
    required this.roomnum,
  });
}

class Priodemodel {
  List<Classmodel> classinfo;

  Priodemodel({
    required this.classinfo,
  });
}
