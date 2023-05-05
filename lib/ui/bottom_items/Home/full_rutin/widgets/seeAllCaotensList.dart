// ignore_for_file: camel_case_types, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/auth_Section/utils/Login_validation.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/request/member_request.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/widgets/dash_border_button.dart';
import 'package:table/widgets/AccoundCardRow.dart';
import 'package:table/widgets/appWidget/TextFromFild.dart';
import 'package:table/widgets/progress_indicator.dart';
import 'package:table/ui/bottom_items/search/widgets/searchBarCustom.dart';
import 'package:flutter/material.dart' as ma;

import '../../../../../../core/dialogs/Alart_dialogs.dart';
import '../../../../../../widgets/hedding_row.dart';

final serachStringProvidder = StateProvider((ref) => "");

class seeAllcaptensList extends ConsumerWidget {
  seeAllcaptensList(
      {super.key,
      required this.onUsername,
      required this.rutinId,
      this.Color,
      this.buttotext});

  //
  final String rutinId;
  final Color;
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
          Container(
            height: 170,
            child: Column(
              children: [
                // SearchBarCustom(onChanged: (v) {
                //   ref.read(serachStringProvidder.notifier).update((state) => v);
                // }),
                AppTextFromField(
                  margin: EdgeInsets.zero,
                  controller: _emailController,
                  hint: "Invite Captens",
                  labelText: "Enter email address or username ",
                  validator: (value) => LoginValidation.validateEmail(value),
                ),
                const SizedBox(height: 20),
                const DashBorderButton(),
              ],
            ),
          ),
          const HeddingRow(hedding: "All Captens", second_Hedding: "see more"),
          Expanded(
            child: allCapten.when(
              data: (data) {
                var lenght = data.captains.length;
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: lenght,
                  itemBuilder: (context, index) {
                    var account = data.captains[index];

                    if (data != null || lenght != null) {
                      return AccountCardRow(
                        accountData: account,
                        onUsername: (username, position) =>
                            onUsername(username, position),
                        buttotext: buttotext,
                        color: Color,

                        //
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
