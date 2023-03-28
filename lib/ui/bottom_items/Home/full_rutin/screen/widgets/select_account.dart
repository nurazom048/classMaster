// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/models/Account_models.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/screen/widgets/seeAllCaotensList.dart';
import 'package:table/ui/bottom_items/search/search_request/search_request.dart';
import 'package:table/widgets/AccoundCardRow.dart';
import 'package:table/widgets/Alart.dart';
import 'package:table/widgets/progress_indicator.dart';
import 'package:table/widgets/searchBarCustom.dart';

import '../../../../../../core/dialogs/Alart_dialogs.dart';

class SeelectAccount extends ConsumerWidget {
  const SeelectAccount(
      {super.key,
      required this.onUsername,
      this.buttotext,
      this.color,
      this.addCapten});
  final String? buttotext;
  final Color? color;
  final bool? addCapten;
  final Function(String?, String?) onUsername;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchString = ref.watch(serachStringProvidder);
    final search_Account = ref.watch(search_Account_Provider(searchString));

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
            child: search_Account.when(
              data: (data) {
                var lenght = data["accounts"].length ?? 0;
                return ListView.builder(
                  itemCount: lenght,
                  itemBuilder: (context, index) {
                    var ac = AccountModels.fromJson(data["accounts"][index]);
                    return data != null || lenght != null
                        ? AccountCardRow(
                            accountData: ac,
                            addCaptem: addCapten,
                            onUsername: (username, position) =>
                                onUsername(username, position),
                            buttotext: buttotext,
                            color: color,
                          )
                        : const Center(child: Text("No Account found"));
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
