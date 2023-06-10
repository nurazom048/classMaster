// ignore_for_file: sized_box_for_whitespace, non_constant_identifier_names, prefer_typing_uninitialized_variables, avoid_print, unused_local_variable, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/search/search_screen/account_search_screen.dart';
import 'package:table/ui/bottom_items/search/search_screen/search_rutine_screen.dart';
import 'package:table/ui/bottom_items/search/widgets/search_bar_custom.dart';
import 'package:flutter/material.dart' as ma;

import '../../../../core/component/responsive.dart';
import '../../Home/widgets/custom_title_bar.dart';
import '../../Home/widgets/mydrawer.dart';

//! search String provider
final Serarch_String_Provider = StateProvider<String>((ref) => "x");

class SearchPAge extends StatefulWidget {
  const SearchPAge({super.key});

  @override
  State<SearchPAge> createState() => _SearchPAgeState();
}

class _SearchPAgeState extends State<SearchPAge> with TickerProviderStateMixin {
  //
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
  }

  final _appBar = const ChustomTitleBar("title");

  @override
  Widget build(BuildContext context) {
    return Responsive(
      // Mobile

      mobile: Scaffold(body: _mobile()),

      // Desktop
      desktop: Scaffold(
          body: Column(
        children: [
          _appBar,
          Expanded(
            child: Row(
              children: [
                const Expanded(flex: 1, child: MyDawer()),
                Expanded(
                  flex: 4,
                  child: Container(
                    color: Colors.yellow,
                    child: _mobile(),
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }

  SingleChildScrollView _mobile() {
    return SingleChildScrollView(
      child: Consumer(builder: (context, ref, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //.. search bar
            Container(
              height: 70,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SearchBarCustom(onChanged: (valu) {
                  ref.read(Serarch_String_Provider.notifier).state = valu;
                }),
              ),
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              child: TabBar(
                controller: tabController,
                tabs: const [
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ma.Text("Rutins ",
                          style: TextStyle(color: Colors.black))),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ma.Text("Account ",
                          style: TextStyle(color: Colors.black))),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
              //color: Colors.black12,
              height: MediaQuery.of(context).size.height - 20,
              width: MediaQuery.of(context).size.width,
              child: TabBarView(controller: tabController, children: const [
                SearchRutineScreen(),
                AccountSearchScreen(),
              ]),
            ),
          ],
        );
      }),
    );
  }
}
//
