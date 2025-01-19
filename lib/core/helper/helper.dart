// ignore_for_file: avoid_print

import 'package:classmate/ui/auth_Section/auth_ui/wellcome_screen.dart';
import 'package:get/get.dart';
import 'package:classmate/core/local%20data/local_data.dart';
import '../../ui/bottom_nevbar_items/bottom_navbar.dart';

Future<void> navigateBaseOnToken() async {
  final String? token = await LocalData.getAuthToken();
  final String? refreshToken = await LocalData.getRefreshToken();

  Future.delayed(const Duration(seconds: 1)).then((value) {
    print("Token: $token");
    if (token != null && refreshToken != null) {
      // ignore: use_build_context_synchronously

      Get.to(() => BottomNavBar());
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => BottomNavBar()));
    } else {
      Get.to(() => const WellComeScreen());
    }
  });
}
