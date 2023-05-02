// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table/core/dialogs/Alart_dialogs.dart';
import 'package:table/models/ClsassDetailsModel.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/sunnary/summary_request/summary_request.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/sunnary/summat_screens/add_summary.dart';
import 'package:table/widgets/appWidget/dottted_divider.dart';
import 'package:table/widgets/heder/hederTitle.dart';

import '../../widgets/rutin_box/rutin_card_row.dart';
import '../widgets/add_summary_button.dart';
import '../widgets/summary_header.dart';

class SummaryScreen extends StatefulWidget {
  final String classId;
  final Day? day;

  SummaryScreen({
    super.key,
    required this.classId,
    this.day,
  });

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final scrollController = ScrollController();

  final List<Map<String, dynamic>> chats = [
    {
      'name': 'John Doe',
      'messaage': 'Hello, how are you?',
      'imageLinks': [
        'https://images.unsplash.com/photo-1682687220247-9f786e34d472?ixlib=rb-4.0.3&ixid=MnwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=465&q=80',
        'https://images.unsplash.com/photo-1682687220247-9f786e34d472?ixlib=rb-4.0.3&ixid=MnwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=465&q=80'
      ]
    },
    {
      'name': 'Jane Smith',
      'messaage': 'I am fine, thanks. How about you?',
      'imageLinks': [
        'https://images.unsplash.com/photo-1682687220247-9f786e34d472?ixlib=rb-4.0.3&ixid=MnwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=465&q=80'
      ]
    },
    {
      'name': 'Bob Johnson',
      'messaage': 'I am doing great. Thanks for asking!',
      'imageLinks': []
    },
    // Add more dummy data as needed
  ];

  @override
  Widget build(BuildContext context) {
    print("ClassId : ${widget.classId}");

    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            const SliverToBoxAdapter(child: SummaryHeader()),
          ],
          body: Container(
            color: Colors.black12,
            height: MediaQuery.of(context).size.height,
            child: Consumer(builder: (context, ref, _) {
              final allSummary =
                  ref.watch(getSumarisProvider("644f8bc80f3ee6456717f61e"));
              return Column(
                children: [
                  Expanded(
                    flex: 10,
                    child: allSummary.when(
                        data: (data) {
                          return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            //reverse: true,
                            itemCount: data.summaryItems.length,
                            itemBuilder: (context, index) {
                              return ChatsDribles(
                                name: data.summaryItems[index].text,
                                messaage: data.summaryItems[index].text,
                                imageLinks: data.summaryItems[index].imageLinks,
                              );
                            },
                          );
                        },
                        error: (error, stackTrace) =>
                            Alart.handleError(context, error),
                        loading: () => Text("data")),
                  ),
                ],
              );
            }),
          ),

          ///
        ),

        //... Add summary icon.....//
        floatingActionButton: AddSummaryButton(
          onTap: () {
            print("onTAp");
            // Map<String, dynamic> newMessage = {
            //   'name': 'John Doe new',
            //   'messaage': 'Hello, how are you?',
            //   'imageLinks': [
            //     'https://images.unsplash.com/photo-1682687220247-9f786e34d472?ixlib=rb-4.0.3&ixid=MnwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=465&q=80',
            //     'https://images.unsplash.com/photo-1682687220247-9f786e34d472?ixlib=rb-4.0.3&ixid=MnwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=465&q=80'
            //   ]
            // };
            // setState(() {
            //   chats.add(newMessage);
            // });

            return Navigator.push(
              context,
              CupertinoPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => AddSummaryScreen()),
            );
          },
        ),
      ),
    );
  }
}

class ChatsDribles extends StatelessWidget {
  final String name;
  final String messaage;
  final List<String> imageLinks;

  const ChatsDribles({
    Key? key,
    required this.name,
    required this.messaage,
    required this.imageLinks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.blueAccent,
      constraints: BoxConstraints(
          minHeight: 350, minWidth: double.infinity, maxHeight: 400),
      child: Container(
        width: 310,
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 30)
            .copyWith(bottom: 70),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFE4F0FF),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFD9D9D9)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      textScaleFactor: 1.4,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                    const Text(
                      '07/04/23, Wednesday',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Color(0xFF0168FF),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                        height: 8, width: 150, child: const DotedDivider()),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 80,
                      child: Text(
                        messaage,
                        textScaleFactor: 1.3,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          height: 1.43,
                          color: Colors.black,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          'state',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xFF4F4F4F),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            ///
            ///
            ///
            Spacer(),

            Container(
              // color: Colors.blueAccent,
              constraints: BoxConstraints(minHeight: 0, maxHeight: 100),

              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: imageLinks.length,
                itemBuilder: (context, index) => Container(
                    alignment: Alignment.centerLeft,
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: const BoxDecoration(
                      color: Colors.black12,
                      shape: BoxShape.rectangle,
                    ),
                    child: Image(image: NetworkImage(imageLinks[index]))),
              ),
            ),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
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
    } else if (flutteDate.day == now.subtract(const Duration(days: 1)).day &&
        flutteDate.month == now.subtract(const Duration(days: 1)).month) {
      displayDate = "Yesterday";
    } else {
      displayDate = "${flutteDate.day} $month";
    }

    return displayDate;
  }
}


// NestedScrollView(
//           headerSliverBuilder: (context, innerBoxIsScrolled) =>[

//           ],
//           body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             // AppBar...
//             HeaderTitle(day?.room ?? '', context),

//             // Class information
//             ClasInfoBox(
//               instructorname: day?.instuctorName ?? "",
//               roomnumber: day?.room ?? '',
//               sunjectcode: day?.subjectcode ?? '',
//             ),
//             const Divider(height: 5),
//             Container(
//               padding: const EdgeInsets.all(20),
//               height: MediaQuery.of(context).size.height - 210,
//               width: double.infinity,
//               color: Colors.black12,
//               child: Consumer(builder: (context, ref, _) {
//                 ////
//                 final lstSummary = ref.watch(sunnaryControllerProvider(classId));

//                 List<Summary> summary = [];

//                 return Stack(
//                   children: [
//                     lstSummary.when(
//                       data: (data) {
//                         summary.addAll(data.summaries);

//                         newScroll();

//                         return ListView.builder(
//                           padding: const EdgeInsets.only(bottom: 100),
//                           shrinkWrap: true,
//                           reverse: false,
//                           controller: scrollController,
//                           itemCount: summary.length,
//                           itemBuilder: (context, index) => SummaryContaner(
//                             text: summary[index].text,
//                             date: summary[index].time.toString(),
//                             is_last: 0 == index,
//                           ),
//                         );
//                       },
//                       error: (error, stackTrace) =>
//                           Alart.handleError(context, error),
//                       loading: () =>
//                       const Center(child: CircularProgressIndicator()),
//                     ),
//                   ],
//                 );
//               }),
//             )
//           ]),
//         ),
