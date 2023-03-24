// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/sunnary/summat_screens/add_summary.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/sunnary/sunnary%20Controller/summary_controller.dart';
import 'package:table/widgets/Alart.dart';
import 'package:table/widgets/TopBar.dart';
import '../../../../../../models/summaryModels.dart';

class SummaryScreen extends StatelessWidget {
  final String classId;
  final String? image;
  final String? istractorName;
  final String? subjectCode;
  final String? roomNumber;

  SummaryScreen({
    super.key,
    required this.classId,
    this.image,
    this.istractorName = "",
    this.subjectCode = "",
    this.roomNumber = ",",
  });
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(children: [
          // AppBar...
          const CustomTopBar("Class Summary"),
          // Class information
          ClasInfoBox(
            instructorname: istractorName ?? "",
            roomnumber: roomNumber ?? '',
            sunjectcode: subjectCode ?? '',
          ),
          const Divider(height: 5),
          Container(
            padding: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height - 210,
            width: double.infinity,
            color: Colors.black12,
            child: Consumer(builder: (context, ref, _) {
              ////
              final lstSummary = ref.watch(sunnaryControllerProvider(classId));

              List<Summary> summary = [];

              return Stack(
                children: [
                  lstSummary.when(
                    data: (data) {
                      summary.addAll(data.summaries);

                      newScroll();

                      return ListView.builder(
                        padding: const EdgeInsets.only(bottom: 100),
                        shrinkWrap: true,
                        reverse: false,
                        controller: scrollController,
                        itemCount: summary.length,
                        itemBuilder: (context, index) => SummaryContaner(
                          text: summary[index].text,
                          date: summary[index].time.toString(),
                          is_last: 0 == index,
                        ),
                      );
                    },
                    error: (error, stackTrace) =>
                        Alart.handleError(context, error),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                  ),
                ],
              );
            }),
          )
        ]),

        //... Add summary icon.....//
        floatingActionButton: AddSummary(
          onTap: () => Navigator.push(
            context,
            CupertinoPageRoute(
                fullscreenDialog: true,
                builder: (context) => AddSummaryScreen(classId: classId)),
          ),
        ),
      ),
    );
  }

  void newScroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }
}

class SummaryContaner extends StatelessWidget {
  final String text;
  final String date;
  final bool is_last;
  const SummaryContaner({
    Key? key,
    required this.text,
    required this.date,
    required this.is_last,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime flutteDate = DateTime.parse(date);
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent, width: 1.0),
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(5.0)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      margin: EdgeInsets.only(
          top: 20, bottom: is_last == true ? 90 : 20, left: 20, right: 20),
      width: 400,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              text,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: Text(_formatDate(flutteDate))),
        ],
      ),
    );
  }

  String _formatDate(DateTime flutteDate) {
    var now = DateTime.now();
    var formatter = DateFormat('MMM');
    var month = formatter.format(flutteDate);
    var displayDate;

    if (flutteDate.day == now.day && flutteDate.month == now.month) {
      displayDate = "Today";
    } else if (flutteDate.day == now.subtract(Duration(days: 1)).day &&
        flutteDate.month == now.subtract(Duration(days: 1)).month) {
      displayDate = "Yesterday";
    } else {
      displayDate = "${flutteDate.day} $month";
    }

    return displayDate;
  }
}

class AddSummary extends StatelessWidget {
  final dynamic onTap;
  const AddSummary({
    Key? key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white70,
          border: Border.all(
            color: Colors.white,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              ' Add Summary',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(Icons.add),
          ],
        ),
      ),
    );
  }
}

class ClasInfoBox extends StatelessWidget {
  const ClasInfoBox({
    Key? key,
    required this.instructorname,
    required this.roomnumber,
    required this.sunjectcode,
  }) : super(key: key);

  final String instructorname;
  final String roomnumber;
  final String sunjectcode;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      width: double.infinity,
      color: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          children: [
            const SizedBox(height: 30),
            const CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://ak.picdn.net/shutterstock/videos/4893908/thumb/1.jpg"),
                radius: 50),
            const SizedBox(width: 30),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Text("InstractorName   :  "
                    "$instructorname"),
                Text("  subject Code     :"
                    "     $roomnumber"),
                Text("Room Name    :   "
                    "$sunjectcode "),
                // Text(DateFormat('EEEE').format(yourDate).toString()),
              ],
            )
          ],
        ),
      ),
    );
  }
}
