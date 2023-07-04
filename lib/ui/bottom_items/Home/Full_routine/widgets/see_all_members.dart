// ignore_for_file: sized_box_for_whitespace, non_constant_identifier_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/Full_routine/controller/members_controllers.dart';
import 'package:table/widgets/accound_card_row.dart';

import '../../../../../core/component/Loaders.dart';
import '../../../../../core/dialogs/alert_dialogs.dart';
import '../../../Collection Fetures/models/account_models.dart';

class SeeAllMembers extends ConsumerWidget {
  String rutinId;
  SeeAllMembers({super.key, required this.rutinId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final all_members = ref.watch(all_members_provider(rutinId));
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              height: 10,
              child: CloseButton(onPressed: () => Navigator.pop(context)),
            ),
            const SizedBox(height: 30),
            Container(
              height: 700,
              child: all_members.when(
                data: (data) {
                  return data != null
                      ? ListView.builder(
                          itemCount: data.members.length,
                          itemBuilder: (context, index) {
                            return AccountCardRow(
                              accountData: AccountModels().copyWith(
                                sId: data.members[index].id,
                                image: data.members[index].image,
                                name: data.members[index].name,
                                username: data.members[index].username,
                              ),
                            );
                          })
                      : Container();
                },
                error: (error, stackTrace) => Alert.handleError(context, error),
                loading: () => Loaders.center(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}