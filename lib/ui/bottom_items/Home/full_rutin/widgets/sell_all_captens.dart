// ignore_for_file: sized_box_for_whitespace, non_constant_identifier_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/controller/members_controllers.dart';
import 'package:table/widgets/accound_card_row.dart';
import 'package:table/widgets/progress_indicator.dart';

import '../../../../../core/dialogs/alart_dialogs.dart';

class SeeeAllCaptens extends ConsumerWidget {
  String rutinId;
  SeeeAllCaptens({super.key, required this.rutinId});

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
                          itemCount: data.members?.length ?? 0,
                          itemBuilder: (context, index) {
                            return AccountCardRow(
                                accountData: data.members![index]);
                          })
                      : Container();
                },
                error: (error, stackTrace) => Alart.handleError(context, error),
                loading: () => Container(
                    height: 200, width: 200, child: const Progressindicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
