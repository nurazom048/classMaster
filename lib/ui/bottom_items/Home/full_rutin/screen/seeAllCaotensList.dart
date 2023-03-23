// ignore_for_file: camel_case_types, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/request/member_request.dart';
import 'package:table/widgets/AccoundCardRow.dart';
import 'package:table/widgets/Alart.dart';
import 'package:table/widgets/progress_indicator.dart';
import 'package:table/widgets/searchBarCustom.dart';
import '../../../Account/accounu_ui/Account_screen.dart';

final serachStringProvidder = StateProvider((ref) => "");

class seeAllcaptensList extends ConsumerWidget {
  const seeAllcaptensList(
      {super.key,
      required this.onUsername,
      required this.rutinId,
      this.buttotext});

  //
  final String rutinId;
  final String? buttotext;
  final Function(String?, String?) onUsername;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allCapten = ref.watch(allCaptenProvider(rutinId));

    return SafeArea(
      child: Scaffold(
        body: Column(children: [
          Expanded(
            flex: 2,
            child: SearchBarCustom(onChanged: (v) {
              ref.read(serachStringProvidder.notifier).update((state) => v);
            }),
          ),
          Expanded(
            flex: 13,
            child: allCapten.when(
              data: (data) {
                var lenght = data.captains.length;
                return ListView.builder(
                  itemCount: lenght,
                  itemBuilder: (context, index) {
                    var account = data.captains[index];

                    if (data != null || lenght != null) {
                      return InkWell(
                        child: AccountCardRow(
                          accountData: account,

                          //
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AccountScreen(
                                    accountUsername: account.username)),
                          );
                        },
                      );
                    } else {
                      return const Center(child: Text("No Account found"));
                    }
                  },
                );
              },
              error: (error, stackTrace) => Alart.handleError(context, error),
              loading: () => const Center(
                  child: SizedBox(
                      height: 100, width: 100, child: Progressindicator())),
            ),
          )
        ]),
      ),
    );
  }
}
