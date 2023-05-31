// ignore_for_file: camel_case_types, unnecessary_null_comparison, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/request/member_request.dart';
import 'package:table/widgets/accound_card_row.dart';
import 'package:table/widgets/progress_indicator.dart';
import 'package:table/ui/bottom_items/search/widgets/search_bar_custom.dart';
import '../../../../../core/dialogs/alart_dialogs.dart';
import 'package:flutter/material.dart' as ma;

import '../../../Account/models/account_models.dart';

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
                var lenght = data.members.length;
                return ListView.builder(
                  itemCount: lenght,
                  itemBuilder: (context, index) {
                    if (data != null && data.members.isNotEmpty) {
                      return AccountCardRow(
                        accountData: AccountModels().copyWith(
                          sId: data.members[index].id,
                          image: data.members[index].image,
                          name: data.members[index].name,
                          username: data.members[index].username,
                        ),
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
