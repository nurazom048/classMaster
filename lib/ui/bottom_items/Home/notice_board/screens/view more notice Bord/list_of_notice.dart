import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/simple_notice_card.dart';

////////////////////////////////////
class ListOfNoticeScreen extends ConsumerWidget {
  const ListOfNoticeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 200,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return SimpleNoticeCard(
                  id: "id",
                  noticeName: "noticeName",
                  ontap: () {},
                  onLongPress: () {},
                  dateTime: DateTime.now(),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
