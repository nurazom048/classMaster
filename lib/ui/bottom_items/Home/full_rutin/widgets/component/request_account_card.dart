// ignore_for_file: prefer_typing_uninitialized_variables, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/widgets/AccoundCardRow.dart';

import '../../../../../../models/Account_models.dart';

class requestAccountCard extends ConsumerWidget {
  final AccountModels accountData;

  final onRejectUsername;
  final acceptUsername;

  const requestAccountCard({
    required this.accountData,
    required this.onRejectUsername,
    required this.acceptUsername,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.black12,
      child: Column(
        children: [
          AccountCardRow(accountData: accountData),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: onRejectUsername,
                    child: const Text("Reject",
                        style: TextStyle(color: Colors.redAccent))),
                const Vdivider(),
                TextButton(
                    onPressed: acceptUsername, child: const Text("Accept")),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Vdivider extends StatelessWidget {
  const Vdivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
        height: 24, child: VerticalDivider(color: Colors.grey, thickness: 1));
  }
}
