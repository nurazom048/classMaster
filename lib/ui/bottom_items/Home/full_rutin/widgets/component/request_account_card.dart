// ignore_for_file: prefer_typing_uninitialized_variables, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/models/Account_models.dart';
import 'package:table/models/seeAllRequestModel.dart';
import 'package:table/widgets/AccoundCardRow.dart';

class requestAccountCard extends ConsumerWidget {
  final RequestModel Request;
  final AccountModels accountData;
  final acceptOnTap;

  const requestAccountCard({
    required this.Request,
    required this.accountData,
    required this.acceptOnTap,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.black12,
      child: Column(
        children: [
          AccountCardRow(accountData: accountData),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(onPressed: acceptOnTap, child: const Text("Reject")),
              TextButton(onPressed: () {}, child: const Text("Accept")),
            ],
          )
        ],
      ),
    );
  }
}
