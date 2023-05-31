// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/core/component/Loaders.dart';
import 'package:table/ui/bottom_items/search/search%20controller/search_account_controller.dart';
import 'package:table/widgets/accound_card_row.dart';
import 'package:table/ui/bottom_items/search/widgets/search_bar_custom.dart';
import 'package:flutter/material.dart' as ma;

import '../../../../../core/dialogs/alart_dialogs.dart';

final serachStringProvidder = StateProvider((ref) => "");

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
    final search_Account = ref.watch(searchAccountController(searchString));

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
              if (data == null) {}
              return ListView.builder(
                itemCount: data.accounts?.length,
                itemBuilder: (context, index) {
                  return data.accounts!.isNotEmpty
                      ? AccountCardRow(
                          accountData: data.accounts![index],
                          addCaptem: addCapten,
                          onUsername: (username, position) =>
                              onUsername(username, position),
                          buttotext: buttotext,
                          color: color,
                        )
                      : const Center(child: ma.Text("No Account found"));
                },
              );
            },
            error: (error, stackTrace) => Alart.handleError(context, error),
            loading: () => Loaders.center(),
          ),
        ),
      ]),
    ));
  }
}
