// ignore_for_file: camel_case_types, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/core/component/Loaders.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/request/member_request.dart';
import 'package:table/widgets/accound_card_row.dart';

import '../../../../../../core/dialogs/alart_dialogs.dart';
import '../../../../../../../widgets/hedding_row.dart';

final serachStringProvidder = StateProvider((ref) => "");

class SeeAllCaptainsList extends ConsumerWidget {
  const SeeAllCaptainsList({
    Key? key,
    required this.onUsername,
    required this.routineId,
    this.color,
    this.buttonText,
  });

  final String routineId;
  final Color? color;
  final String? buttonText;
  final Function(String?, String?) onUsername;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allCaptains = ref.watch(allCaptenProvider(routineId));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          const HeddingRow(hedding: "All Captains", secondHeading: "see more"),
          Expanded(
            child: allCaptains.when(
              data: (data) {
                final captains = data.captains;
                return captains.isNotEmpty
                    ? ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: captains.length,
                        itemBuilder: (context, index) {
                          final account = captains[index];
                          return AccountCardRow(
                            accountData: account,
                            onUsername: (username, position) =>
                                onUsername(username, position),
                            buttotext: buttonText,
                            color: color,
                          );
                        },
                      )
                    : const Center(child: Text("No Accounts found"));
              },
              error: (error, stackTrace) => Alart.handleError(context, error),
              loading: () => Loaders.center(),
            ),
          ),
        ],
      ),
    );
  }
}
