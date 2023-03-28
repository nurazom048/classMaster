// ignore_for_file: sized_box_for_whitespace, non_constant_identifier_names, prefer_typing_uninitialized_variables, avoid_print, unused_local_variable, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/models/Account_models.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/screen/full_rutin_view.dart';
import 'package:table/ui/bottom_items/search/search_request/search_request.dart';
import 'package:table/widgets/AccoundCardRow.dart';
import 'package:table/widgets/custom_rutin_card.dart';
import 'package:table/widgets/progress_indicator.dart';
import 'package:table/widgets/searchBarCustom.dart';
import '../../../../core/dialogs/Alart_dialogs.dart';
import '../../../../models/rutins/search_rutin.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                margin: const EdgeInsets.only(top: 5),
                padding:
                    const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                //color: Colors.black12,
                height: MediaQuery.of(context).size.height - 20,
                width: MediaQuery.of(context).size.width,
                child: TabBarView(controller: tabController, children: [
                  _search_rutines(context),
                  search_acounts(context),
                ]),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _search_rutines(BuildContext context) {
    return Consumer(builder: (context, WidgetRef ref, _) {
      //! Provider.
      final searchText = ref.watch(Serarch_String_Provider);

      final searchRoutine = ref.watch(searchRoutineProvider(searchText));

      return Container(
          height: 300,
          width: MediaQuery.of(context).size.width,
          child: searchRoutine.when(
            data: (data) {
              return data?.rutins == null
                  ? Alart.handleError(context, "error")
                  : data!.rutins.isNotEmpty
                      ? ListView.builder(
                          itemCount: data.rutins.length,
                          itemBuilder: (context, index) {
                            return CustomRutinCard(
                              rutinModel: data.rutins[index],
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullRutineView(
                                    rutinName: data.rutins[index].name,
                                    rutinId: data.rutins[index].id,
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
    });
  }

  Widget search_acounts(BuildContext context) {
    return Consumer(builder: (context, WidgetRef ref, _) {
      //
      final searchText = ref.watch(Serarch_String_Provider);
      final search_Account = ref.watch(search_Account_Provider(searchText));
      return Container(
          height: 500,
          width: MediaQuery.of(context).size.width,
          child: search_Account.when(
              data: (data) {
                print(data.toString());

                return ListView.builder(
                  itemCount: data.accounts?.length,
                  itemBuilder: (context, index) {
                    print(data);
                    return data != null && data.accounts!.isNotEmpty
                        ? AccountCardRow(accountData: data.accounts![index])
                        : const Center(child: Text("No Account found"));
                  },
                );
              },
              error: (error, stackTrace) => Alart.handleError(context, error),
              loading: () => const Progressindicator()));
    });
  }
}

//
//
