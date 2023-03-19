// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/controller/members_controllers.dart';
import 'package:table/widgets/AccoundCardRow.dart';
import 'package:table/widgets/Alart.dart';
import 'package:table/widgets/progress_indicator.dart';
import 'package:table/widgets/searchBarCustom.dart';

final serachStringProvidder = StateProvider((ref) => "");

class rutin_member_page extends ConsumerWidget {
  rutin_member_page(
      {super.key, required this.onUsername, required this.rutinId});
  String rutinId;

  final Function(String?) onUsername;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final all_members = ref.watch(all_members_provider(rutinId));

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
            child: all_members.when(
              data: (data) {
                var lenght = data?.Members?.length ?? 0;
                return ListView.builder(
                  itemCount: lenght,
                  itemBuilder: (context, index) {
                    var listOfAccount = data?.Members?[index];

                    return data != null || lenght != null
                        ? AccountCardRow(
                            accountData: listOfAccount!,
                            onUsername: (u) => onUsername(u),
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
