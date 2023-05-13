// ignore_for_file: camel_case_types, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/core/component/Loaders.dart';
import 'package:table/ui/auth_Section/utils/login_validation.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/request/member_request.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/widgets/dash_border_button.dart';
import 'package:table/widgets/accound_card_row.dart';
import 'package:table/widgets/appWidget/TextFromFild.dart';
import 'package:table/widgets/progress_indicator.dart';
import 'package:flutter/material.dart' as ma;

import '../../../../../../core/dialogs/alart_dialogs.dart';
import '../../../../../../../widgets/hedding_row.dart';

final serachStringProvidder = StateProvider((ref) => "");

class seeAllcaptensList extends ConsumerWidget {
  seeAllcaptensList(
      {super.key,
      required this.onUsername,
      required this.rutinId,
      this.color,
      this.buttotext});

  //
  final String rutinId;
  final color;
  final String? buttotext;
  final Function(String?, String?) onUsername;

  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allCapten = ref.watch(allCaptenProvider(rutinId));

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(children: [
          const HeddingRow(hedding: "All Captens", second_Hedding: "see more"),
          allCapten.when(
            data: (data) {
              var lenght = data.captains.length;
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: lenght,
                itemBuilder: (context, index) {
                  var account = data.captains[index];

                  if (data != null || lenght != null) {
                    return AccountCardRow(
                      accountData: account,
                      onUsername: (username, position) =>
                          onUsername(username, position),
                      buttotext: buttotext,
                      color: color,

                      //
                    );
                  } else {
                    return const Center(child: ma.Text("No Account found"));
                  }
                },
              );
            },
            error: (error, stackTrace) => Alart.handleError(context, error),
            loading: () => Loaders.center(),
          )
        ]),
      ),
    );
  }
}
