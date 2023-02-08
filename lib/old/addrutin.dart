// ignore_for_file: must_be_immutable, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table/old/moidels.dart';
import 'package:table/old/rutinprovider.dart';

class AddRutin extends StatefulWidget {
  Classmodel? classdata;
  dynamic indexofdate;
  // ignore: unnecessary_question_mark
  dynamic? classindex;
  bool? iseddit;
  AddRutin(
      {super.key,
      required this.indexofdate,
      this.classdata,
      this.classindex,
      this.iseddit});

  @override
  State<AddRutin> createState() => _AddRutinState();
}

class _AddRutinState extends State<AddRutin> {
  TextEditingController instructorname = TextEditingController();
  TextEditingController sujectcode = TextEditingController();
  TextEditingController roomnum = TextEditingController();
  TextEditingController start = TextEditingController();
  TextEditingController end = TextEditingController();

  FocusNode subjectCodeNameFocus = FocusNode();
  FocusNode roomnumNameFocus = FocusNode();
  FocusNode startingFocus = FocusNode();
  FocusNode endingFocus = FocusNode();

  /// addNew Rutin

  void addNewClass() {
    Classmodel addclasses = Classmodel(
      instructorname: instructorname.text,
      subjectcode: sujectcode.text,
      roomnum: roomnum.text,
      startingpriode: int.parse(start.text),
      endingpriode: int.parse(end.text),
    );

    Provider.of<Rutinprovider>(context, listen: false)
        .addclass(widget.indexofdate, addclasses);
    Navigator.pop(context);
  }

  /// Edditing class

  void edditclass() {
    widget.classdata!.instructorname = instructorname.text;
    widget.classdata!.subjectcode = sujectcode.text;
    widget.classdata!.roomnum = roomnum.text;
    widget.classdata!.startingpriode = int.parse(start.text);
    widget.classdata!.endingpriode = int.parse(end.text);

    Provider.of<Rutinprovider>(context, listen: false)
        .eddit(widget.indexofdate, widget.classdata!);

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    if (widget.iseddit == true) {
      instructorname.text = widget.classdata!.instructorname;

      sujectcode.text = widget.classdata!.subjectcode;
      roomnum.text = widget.classdata!.roomnum;
      start.text = widget.classdata!.startingpriode.toString();
      end.text = widget.classdata!.endingpriode.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
// Appbar()

      appBar: AppBar(
        centerTitle: true,
        title:
            Text(widget.iseddit == true ? " Eddit Class " : " Add New Class"),
        actions: [
          IconButton(
            onPressed: () {
              if (widget.iseddit == true) {
                edditclass();
                Navigator.pop(context);
              } else {
                addNewClass();
              }
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),

      // Body
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
/////   hare 3 TextFild
            ///
            children: [
              TextField(
                controller: instructorname,
                autofocus: (widget.iseddit == true) ? false : true,
                onSubmitted: (val) {
                  if (val != "") {
                    subjectCodeNameFocus.requestFocus();
                  }
                },
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                    hintText: "InstructorName", border: InputBorder.none),
              ),
              TextField(
                controller: sujectcode,
                focusNode: roomnumNameFocus,
                maxLines: 1,
                onSubmitted: (val) {
                  if (val != "") {
                    startingFocus.requestFocus();
                  }
                },
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                    hintText: "Subject Code", border: InputBorder.none),
              ),
              TextField(
                controller: roomnum,
                // focusNode: noteFocus,
                maxLines: 1,
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                    hintText: "Room Number", border: InputBorder.none),
              ),
              TextField(
                controller: start,
                // focusNode: noteFocus,
                maxLines: 1,
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                    hintText: "Strting priode", border: InputBorder.none),
              ),
              TextField(
                controller: end,
                // focusNode: noteFocus,
                maxLines: 1,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                    hintText: "Ending priode", border: InputBorder.none),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///
class AddOrEdditPriode extends StatefulWidget {
  AddOrEdditPriode({super.key, this.priode, this.isedditing});
  Addpriode? priode;
  bool? isedditing;
  bool? isEdit;

  @override
  State<AddOrEdditPriode> createState() => _AddOrEdditPriodeState();
}

class _AddOrEdditPriodeState extends State<AddOrEdditPriode> {
  TextEditingController starttimeController = TextEditingController();
  TextEditingController endtimeController = TextEditingController();

  void addNewPriode() {
    Addpriode addNewPriode =
        Addpriode(startingpriode: _starttime!, endingpriode: _endtime!);

    Provider.of<PriodeDateProvider>(context, listen: false)
        .adpriode(addNewPriode);

    Navigator.pop(context);
  }

  void eddit() {
    widget.priode!.startingpriode = _starttime!;
    widget.priode!.endingpriode = _endtime!;

    Provider.of<PriodeDateProvider>(context, listen: false)
        .eddit(widget.priode!);

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    if (widget.isEdit == true) {
      _starttime = widget.priode!.startingpriode;

      _endtime = widget.priode!.endingpriode;
    }
  }

  TimeOfDay? _starttime = const TimeOfDay(hour: 12, minute: 12);

  TimeOfDay? _endtime = const TimeOfDay(hour: 19, minute: 12);
  DateTime datetime = DateTime.now();
  bool ischange = false;
  @override
  Widget build(BuildContext context) {
    var priodedata = Provider.of<PriodeDateProvider>(context).priodelist;
    // print(_starttime!.minute.toInt().toString());
    // print(_endtime!.hour.toInt().toString());
    //print(datetime.hour);
    //  print(datetime.minute);

    return Scaffold(
      appBar: AppBar(
          title:
              Text(widget.isedditing == true ? "Eddit priode" : "Add Priode "),
          centerTitle: true,
          actions: [
            IconButton(
                icon: const Icon(Icons.check),

                // chack is eddit or add
                onPressed: () =>
                    widget.isedditing == true ? eddit() : addNewPriode())
          ]),

      // body
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ////
              const Text("Add Start Time"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(ischange
                      ? _starttime!.format(context).toString()
                      : priodedata.length != null
                          ? priodedata[priodedata.length - 1]
                              .endingpriode
                              .format(context)
                              .toString()
                          : _starttime!.format(context).toString()),
                  IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        showTimePicker(
                                context: context,
                                initialTime: priodedata.length == null
                                    ? _endtime!
                                    : priodedata[priodedata.length - 1]
                                        .endingpriode)
                            .then((value) {
                          if (value != null) {
                            setState(() {
                              _starttime = value;
                              ischange = true;
                            });
                          }
                        });
                      }),
                ],
              ),

              ////
              const Text("Add End Time"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_endtime!.format(context).toString()),
                  IconButton(
                      icon: const Icon(Icons.timer),
                      onPressed: () {
                        showTimePicker(
                                context: context, initialTime: TimeOfDay.now())
                            .then((value) => value != null
                                ? setState(() {
                                    _endtime = value;
                                  })
                                : null);
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
