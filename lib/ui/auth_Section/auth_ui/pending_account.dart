import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table/widgets/appWidget/app_text.dart';

import '../../bottom_items/Collection Fetures/Ui/aboutus_screen.dart';

class PendingScreen extends StatelessWidget {
  const PendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(
            'Your Academy request is stil pending ',
            style: TS.heading(),
          ),
          TextButton(
            onPressed: () => Get.to(() => const AboutusScreen()),
            child: const Text('ContractUs'),
          ),
        ],
      ),
    );
  }
}
