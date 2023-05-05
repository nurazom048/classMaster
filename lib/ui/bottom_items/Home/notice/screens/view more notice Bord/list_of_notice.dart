import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart' as ma;

////////////////////////////////////
class ListOfNoticeScreen extends ConsumerWidget {
  const ListOfNoticeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 200,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return const ma.Text("data");
              },
            ),
          )
        ],
      ),
    );
  }
}
