// ignore_for_file: camel_case_types, unnecessary_null_comparison, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/request/member_request.dart';
import 'package:table/widgets/AccoundCardRow.dart';
import 'package:table/widgets/progress_indicator.dart';
import 'package:table/ui/bottom_items/search/widgets/searchBarCustom.dart';
import '../../../../../../core/dialogs/Alart_dialogs.dart';
import 'package:flutter/material.dart' as ma;

final serachStringProvidder = StateProvider((ref) => "");

class seeAllMembers extends ConsumerWidget {
  const seeAllMembers(
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
    final allMembers = ref.watch(allMembersProvider(rutinId));

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
            child: allMembers.when(
              data: (data) {
                var lenght = data.members?.length ?? 0;
                return ListView.builder(
                  itemCount: lenght,
                  itemBuilder: (context, index) {
                    if (data != null && data.members!.isNotEmpty) {
                      return AccountCardRow(
                        accountData: data.members![index],
                        onUsername: (username, position) =>
                            onUsername(username, position),
                        buttotext: buttotext,
                        color: Colors.red,
                      );
                    } else {
                      return const Center(child: ma.Text("No Account found"));
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
