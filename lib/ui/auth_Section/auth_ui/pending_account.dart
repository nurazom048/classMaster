import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table/widgets/appWidget/app_text.dart';

import '../../bottom_items/Collection Fetures/Ui/aboutus_screen.dart';

class PendingScreen extends StatelessWidget {
  const PendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child: Column(
            children: [
              Text(
                'Your Academy request is still pending...',
                style: TS.heading(),
              ),
              const SizedBox(height: 200),
              TextButton(
                onPressed: () => Get.to(() => const AboutScreen()),
                child: Text(
                  'ContractUs',
                  style: TS.opensensBlue(fontSize: 25),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
