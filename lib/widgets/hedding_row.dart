// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:table/widgets/text%20and%20buttons/mytext.dart';

class HeddingRow extends StatelessWidget {
  final String hedding;
  final String? second_Hedding;
  final dynamic onTap;

  const HeddingRow({
    required this.hedding,
    this.second_Hedding = "",
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyText(hedding, padding: const EdgeInsets.all(0)),
          TextButton(
              onPressed: onTap,
              child: Text(second_Hedding ?? '',
                  style: const TextStyle(color: Colors.blue)))
        ],
      ),
    );
  }
}
