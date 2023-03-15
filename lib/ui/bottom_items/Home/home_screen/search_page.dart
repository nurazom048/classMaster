// ignore_for_file: sized_box_for_whitespace, non_constant_identifier_names, prefer_typing_uninitialized_variables, avoid_print, unused_local_variable, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/models/Account_models.dart';
import 'package:table/models/rutineOverviewModel.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/full_rutin_ui/full_rutin_view.dart';
import 'package:table/ui/bottom_items/Home/home_screen/search/search_request/search_request.dart';
import 'package:table/widgets/AccoundCardRow.dart';
import 'package:table/widgets/Alart.dart';
import 'package:table/widgets/custom_rutin_card.dart';
import 'package:table/widgets/progress_indicator.dart';
import 'package:table/widgets/searchBarCustom.dart';

final Serarch_String_Provider = StateProvider<String>((ref) => "");

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Consumer(builder: (context, ref, _) {
          final searchText = ref.watch(Serarch_String_Provider);
          //
          final searchRoutine = ref.watch(searchRoutineProvider(searchText));
          final search_Account = ref.watch(search_Account_Provider(searchText));
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //.. search bar
              SearchBarCustom(onChanged: (valu) {
                ref.read(Serarch_String_Provider.notifier).state = valu;
              }),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                width: MediaQuery.of(context).size.width,
                child: TabBar(
                  controller: tabController,
                  tabs: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Rutins ",
                          style: TextStyle(color: Colors.black)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Account ",
                          style: TextStyle(color: Colors.black)),
                    ),
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
                  _search_rutines(context, searchRoutine),
                  search_acounts(context, search_Account),
                ]),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _search_rutines(
      BuildContext context, AsyncValue<dynamic> searchRoutine) {
    return Container(
        height: 300,
        width: MediaQuery.of(context).size.width,
        child: searchRoutine.when(
          data: (data) {
            return data != null
                ? ListView.builder(
                    itemCount: data["rutins"].length,
                    itemBuilder: (context, index) {
                      // print("data[" "]");
                      // print(data["rutins"][0]["name"].toString());
                      var _serchRutin = data["rutins"][index];

                      var listOfrutins = RutinOverviewModel.fromJson(data);
                      // print("listOfrutins" +
                      //     listOfrutins.rutins[0].name.toString());
                      return CustomRutinCard(
                        rutinname: _serchRutin["name"],
                        // profilePicture: seach_result[index]["ownerid"]["image"],
                        name: _serchRutin["name"],
                        username: _serchRutin["_id"],

                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullRutineView(
                              rutinName: _serchRutin["name"],
                              rutinId: _serchRutin["_id"],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const Center(child: Text("No rutin found"));
          },
          error: (error, stackTrace) => Alart.handleError(context, error),
          loading: () => const Progressindicator(),
        ));
  }

  Widget search_acounts(
      BuildContext context, AsyncValue<dynamic> search_Account) {
    return Container(
        height: 500,
        width: MediaQuery.of(context).size.width,
        child: search_Account.when(
            data: (data) {
              print(data.toString());

              return ListView.builder(
                itemCount: data["accounts"].length ?? 0,
                itemBuilder: (context, index) {
                  var ac = AccountModels.fromJson(data["accounts"][index]);

                  print(data);
                  return data != null || data["accounts"].lenght != null
                      ? AccountCardRow(accountData: ac)
                      : const Center(child: Text("No Account found"));
                },
              );
            },
            error: (error, stackTrace) => Alart.handleError(context, error),
            loading: () => const Progressindicator()));
  }
}

//
//
