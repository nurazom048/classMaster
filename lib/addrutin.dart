// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:table/moidels.dart';
import 'package:table/rutinprovider.dart';

class addrutinpage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  var indexxx;
  addrutinpage({
    Key? key,
    required this.indexxx,
  }) : super(key: key);

  @override
  State<addrutinpage> createState() => _addrutinpageState();
}

class _addrutinpageState extends State<addrutinpage> {
  TextEditingController instructorname = TextEditingController();

  TextEditingController sujectcode = TextEditingController();

  TextEditingController roomnum = TextEditingController();

  TextEditingController start = TextEditingController();

  TextEditingController end = TextEditingController();

  FocusNode noteFocus = FocusNode();

  void addNewRutin() {
    Classmodel addclasses = Classmodel(
      instructorname: instructorname.text,
      subjectcode: sujectcode.text,
      roomnum: roomnum.text,
      startingpriode: double.parse(start.text),
      endingpriode: double.parse(end.text),
    );

    Provider.of<Rutinprovider>(context, listen: false)
        .addclass(widget.indexxx, addclasses);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    print("start");
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              addNewRutin();
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              TextField(
                controller: instructorname,
                // autofocus: (widget.isUpdate == true) ? false : true,
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
                maxLines: null,
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                    hintText: "Subject Code", border: InputBorder.none),
              ),
              TextField(
                controller: roomnum,
                //focusNode: noteFocus,
                maxLines: null,
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                    hintText: "Room Number", border: InputBorder.none),
              ),
              TextField(
                controller: start,
                //focusNode: noteFocus,
                maxLines: null,
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                    hintText: "Strting priode", border: InputBorder.none),
              ),
              TextField(
                controller: end,
                // focusNode: noteFocus,
                maxLines: null,
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
