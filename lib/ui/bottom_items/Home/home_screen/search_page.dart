// ignore_for_file: sized_box_for_whitespace, non_constant_identifier_names, prefer_typing_uninitialized_variables, avoid_print, unused_local_variable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table/ui/bottom_items/Home/class/full_rutin_view.dart';
import 'package:table/ui/bottom_items/Home/home_screen/search/search_request/search_request.dart';
import 'package:table/widgets/Alart.dart';
import 'package:table/widgets/custom_rutin_card.dart';
import 'package:table/widgets/days_container.dart';
import 'package:table/widgets/progress_indicator.dart';
import 'package:table/widgets/text%20and%20buttons/empty.dart';

final Serarch_String_Provider = StateProvider<String>((ref) => "");

class SearchPAge extends StatefulWidget {
  const SearchPAge({super.key});

  @override
  State<SearchPAge> createState() => _SearchPAgeState();
}

class _SearchPAgeState extends State<SearchPAge> with TickerProviderStateMixin {
  var _searchController;
  var seach_result = [];
  //
  late TabController tabController;

  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Consumer(builder: (context, ref, _) {
          //
          final searchRoutine = ref
              .watch(searchRoutineProvider(ref.watch(Serarch_String_Provider)));
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //.. search
              CupertinoNavigationBar(
                middle: CupertinoTextField(
                  //.. on chang
                  onChanged: (valu) {
                    ref.read(Serarch_String_Provider.notifier).state = valu;
                  },
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
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                width: MediaQuery.of(context).size.width,
                child: TabBar(
                  controller: tabController,
                  tabs: const [
                    Text("Rutins ", style: TextStyle(color: Colors.black)),
                    Text("Account ", style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                color: Colors.black12,
                height: MediaQuery.of(context).size.height - 200,
                width: MediaQuery.of(context).size.width,
                child: TabBarView(controller: tabController, children: [
                  Container(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      child: searchRoutine.when(
                        data: (data) {
                          return data != null
                              ? ListView.builder(
                                  itemCount: data["rutins"].length,
                                  itemBuilder: (context, index) {
                                    print("data[" "]");
                                    print(data["rutins"][0]["name"].toString());
                                    var _serchRutin = data["rutins"][index];
                                    return CustomRutinCard(
                                      rutinname: _serchRutin["name"],
                                      // profilePicture: seach_result[index]["ownerid"]["image"],
                                      name: _serchRutin["name"],
                                      username: _serchRutin["_id"],
                                      // last_update: _serchRutin["last_summary"]
                                      //         ["text"] ??
                                      //     "",
                                      //..
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FullRutineView(
                                            rutinName: seach_result[index]
                                                ["name"],
                                            rutinId: seach_result[index]["_id"],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : const Center(child: Text("No rutin found"));
                        },
                        error: (error, stackTrace) =>
                            Alart.handleError(context, error),
                        loading: () => const Progressindicator(),
                      )),
                  Text("hell3333o"),

                  // rutin_tab_View(context),
                  // rutin_tab_View(context),
                ]),
              ),
              // items
            ],
          );
        }),
      ),
    );
  }

  Container rutin_tab_View(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 100,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        itemCount: seach_result.length,
        itemBuilder: (context, index) => CustomRutinCard(
          rutinname: seach_result[index]["name"],
          // profilePicture: seach_result[index]["ownerid"]["image"],
          name: seach_result[index]["ownerid"]["name"],
          username: seach_result[index]["ownerid"]["username"],
          last_update: seach_result[index]["last_summary"]["text"] ?? "",
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
