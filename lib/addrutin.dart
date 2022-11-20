// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table/moidels.dart';
import 'package:table/rutinprovider.dart';

class AddRutin extends StatefulWidget {
  Classmodel? classdata;
  dynamic indexofdate;
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
  FocusNode noteFocus = FocusNode();

  /// addNew Rutin

  void addNewClass() {
    Classmodel addclasses = Classmodel(
      instructorname: instructorname.text,
      subjectcode: sujectcode.text,
      roomnum: roomnum.text,
      startingpriode: double.parse(start.text),
      endingpriode: double.parse(end.text),
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
    widget.classdata!.startingpriode = double.parse(start.text);
    widget.classdata!.endingpriode = double.parse(start.text);

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
        title:
            Text(widget.iseddit == true ? " Eddit Class " : " Add New Class"),
        centerTitle: true,
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
                    noteFocus.requestFocus();
                  }
                },
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                    hintText: "InstructorName", border: InputBorder.none),
              ),
              TextField(
                controller: sujectcode,
                // focusNode: noteFocus,
                maxLines: 1,
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                    hintText: "Subject Code", border: InputBorder.none),
              ),
              TextField(
                controller: roomnum,
                //focusNode: noteFocus,
                maxLines: 1,
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                    hintText: "Room Number", border: InputBorder.none),
              ),
              TextField(
                controller: start,
                //focusNode: noteFocus,
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

  @override
  State<AddOrEdditPriode> createState() => _AddOrEdditPriodeState();
}

class _AddOrEdditPriodeState extends State<AddOrEdditPriode> {
  TextEditingController starttimeController = TextEditingController();
  TextEditingController endtimeController = TextEditingController();
  // TextEditingController roomnum = TextEditingController();
  // TextEditingController start = TextEditingController();
  // TextEditingController end = TextEditingController();

  void addNewPriode() {
    Addpriode addNewPriode = Addpriode(
        startingpriode: starttimeController.text.toString(),
        endingpriode: endtimeController.text.toString());

    Provider.of<PriodeDateProvider>(context, listen: false)
        .adpriode(addNewPriode);

    Navigator.pop(context);
  }

  void eddit() {
    widget.priode!.startingpriode = starttimeController.text;
    widget.priode!.endingpriode = endtimeController.text;
    // widget.classdata!.roomnum = roomnum.text;
    //  widget.classdata!.startingpriode = double.parse(start.text);
    //   widget.classdata!.endingpriode = double.parse(start.text);

    Provider.of<PriodeDateProvider>(context, listen: false)
        .eddit(widget.priode!);

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    if (widget.isedditing == true) {
      starttimeController.text = widget.priode!.startingpriode;

      endtimeController.text = widget.priode!.endingpriode;
      // roomnum.text = widget.classdata!.roomnum;
      // start.text = widget.classdata!.startingpriode.toString();
      // end.text = widget.classdata!.endingpriode.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    PriodeDateProvider priodedata = Provider.of<PriodeDateProvider>(context);
    return Scaffold(
      appBar:
          AppBar(title: const Text("Add Priode"), centerTitle: true, actions: [
        IconButton(
          icon: const Icon(Icons.check),
          onPressed: () {
            if (widget.isedditing == true) {
              eddit();
            } else {
              addNewPriode();
            }
            print("aded");
          },
        )
      ]),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
/////   hare 3 TextFild
            ///
            children: [
              TextField(
                controller: starttimeController,
                keyboardType: TextInputType.number,
                maxLines: 1,
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                    hintText: "Star time", border: InputBorder.none),
              ),
              TextField(
                controller: endtimeController,
                //focusNode: noteFocus,
                keyboardType: TextInputType.number,
                maxLines: 1,
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                    hintText: "End Time", border: InputBorder.none),
              ),
              // TextField(
              //   //controller: start,
              //   //focusNode: noteFocus,
              //   maxLines: 1,
              //   style: const TextStyle(fontSize: 20),
              //   decoration: const InputDecoration(
              //       hintText: "Strting priode", border: InputBorder.none),
              // ),
              // TextField(
              //   controller: end,
              //   // focusNode: noteFocus,
              //   maxLines: 1,
              //   keyboardType: TextInputType.number,
              //   style: const TextStyle(fontSize: 20),
              //   decoration: const InputDecoration(
              //       hintText: "Ending priode", border: InputBorder.none),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
