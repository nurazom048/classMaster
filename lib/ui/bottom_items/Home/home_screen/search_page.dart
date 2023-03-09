// ignore_for_file: sized_box_for_whitespace, non_constant_identifier_names, prefer_typing_uninitialized_variables, avoid_print

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table/ui/bottom_items/Home/class/full_rutin_view.dart';
import 'package:table/widgets/custom_rutin_card.dart';
import 'package:table/widgets/days_container.dart';
import 'package:http/http.dart' as http;
import 'package:table/widgets/text%20and%20buttons/empty.dart';

class SearchPAge extends StatefulWidget {
  const SearchPAge({super.key});

  @override
  State<SearchPAge> createState() => _SearchPAgeState();
}

class _SearchPAgeState extends State<SearchPAge> {
  var _searchController;
  var seach_result = [];
  //

  Future<void> searchRoutine(String valu) async {
    print(valu);
    try {
      final response = await http
          .post(Uri.parse('http://192.168.0.125:3000/rutin/search/$valu'));

      //
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        setState(() {
          seach_result = json.decode(response.body)["rutins"];
        });

        //  print(seach_result);
      }
      print(seach_result[0]);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //.. search
            CupertinoNavigationBar(
              middle: CupertinoTextField(
                //.. on chang
                onChanged: (valu) => searchRoutine(valu),
                controller: _searchController,
                placeholder: 'Search',
                clearButtonMode: OverlayVisibilityMode.editing,
                style: const TextStyle(fontSize: 16),
                cursorColor: CupertinoColors.activeBlue,
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  border: Border.all(
                    color: CupertinoColors.inactiveGray,
                    width: 0.5,
                  ),
                ),
                prefix: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Icon(CupertinoIcons.search, size: 18.0),
                ),
                suffix: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Icon(Icons.clear_all_rounded, size: 18.0),
                ),
              ),
            ),

            // items
            Container(
              height: MediaQuery.of(context).size.height - 100,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                itemCount: seach_result.length,
                itemBuilder: (context, index) => CustomRutinCard(
                  rutinname: seach_result[index]["name"],
                  // profilePicture: seach_result[index]["ownerid"]["image"],
                  name: seach_result[index]["ownerid"]["name"],
                  username: seach_result[index]["ownerid"]["username"],
                  last_update:
                      seach_result[index]["last_summary"]["text"] ?? "",
                  //..
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullRutineView(
                        rutinName: seach_result[index]["name"],
                        rutinId: seach_result[index]["_id"],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
//

class SeacrhRutinCard extends StatelessWidget {
  String rutinname;
  String? name, username, profilePicture;
  dynamic onTap, onLongPress;

  SeacrhRutinCard({
    super.key,
    required this.rutinname,
    this.name,
    this.username,
    this.profilePicture,
    this.onTap,
    this.onLongPress,
  });

  List<Map<String, dynamic>> mypriodelist = [
    {
      "start_time": DateTime(2022, 09, 03, 8, 59),
      "end_time": DateTime(2022, 09, 03, 9, 30),
    },
    {
      "start_time": DateTime(2022, 09, 03, 9, 30),
      "end_time": DateTime(2022, 09, 03, 10, 15),
    },
    {
      "start_time": DateTime(2022, 09, 03, 10, 15),
      "end_time": DateTime(2022, 09, 03, 11, 00),
    },
    {
      "start_time": DateTime(2022, 09, 03, 8, 40),
      "end_time": DateTime(2022, 09, 03, 9, 30),
    },
    {
      "start_time": DateTime(2022, 09, 03, 9, 30),
      "end_time": DateTime(2022, 09, 03, 10, 15),
    },
    {
      "start_time": DateTime(2022, 09, 03, 10, 15),
      "end_time": DateTime(2022, 09, 03, 11, 00),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: 280,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Rutn(),
          //
          Container(
            height: 250,
            width: MediaQuery.of(context).size.width * 0.25,
            // child: IconButton(
            //   icon: const Icon(Icons.save),
            //   onPressed: () {},
            // ),
          )
        ],
      ),
    );
  }

  Container Rutn() {
    return Container(
      margin: const EdgeInsets.only(top: 20, right: 10),
      height: 250,
      width: 220,
      color: Colors.black12,
      child: SingleChildScrollView(
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Column(
            children: [
              Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                          scrollDirection: Axis.horizontal, child: Priode()),
                      Wrap(
                          direction: Axis.vertical,
                          children: List.generate(
                            3,
                            (index) => DaysContaner(
                              indexofdate: index,
                              ismini: true,
                            ),
                          )),
                    ],
                  ),

                  //
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: 50,
                      width: 240,
                      // padding: const EdgeInsets.all(5.0),
                      decoration: const BoxDecoration(color: Colors.black12),
                      child: Center(
                        child: Text(rutinname,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 20)),
                      ),
                    ),
                  ),
                ],
              ),
              MiniAccountCard(
                name: name ?? "",
                username: username ?? "             ",
                profilePicture: profilePicture ?? "",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Wrap Priode() {
    return Wrap(
      direction: Axis.horizontal,
      children: List.generate(
        5,
        (index) => index == 0
            ? const Empty(corner: true, mini: true)
            : Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(68, 114, 196, 40),
                    border: Border(
                        right: BorderSide(color: Colors.black45, width: 1))),
                child: Column(
                  children: [
                    Text(index.toString(),
                        style: const TextStyle(fontSize: 10)),
                    const Divider(
                        color: Colors.black87, height: 1, thickness: .5),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            formatTime(
                              mypriodelist[index]["start_time"],
                            ),
                            style: const TextStyle(fontSize: 10)),
                        Text(formatTime(mypriodelist[index]["end_time"]),
                            style: const TextStyle(fontSize: 10)),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  String formatTime(DateTime time) {
    return DateFormat.jm().format(time);
  }
}

class MiniAccountCard extends StatelessWidget {
  String name, username, profilePicture;
  MiniAccountCard({
    required this.name,
    required this.username,
    required this.profilePicture,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 248,
      color: Colors.black12,
      child: Row(
        children: [
          const SizedBox(width: 4),
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.amber,
            backgroundImage: NetworkImage(profilePicture),
          ),
          const SizedBox(width: 6),
          RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                  text: name,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                TextSpan(
                  text: '\n$username',
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
