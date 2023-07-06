import 'package:get/get.dart';

import '../ui/auth_Section/auth_controller/auth_controller.dart';
import '../ui/bottom_items/bottom_navbar.dart';

Future<void> navigateBaseOnToken() async {
  final String? token = await AuthController.getToken();

  // ignore: avoid_print
  print("Token: $token");
  if (token != null) {
    // ignore: use_build_context_synchronously

    Get.to(() => BottomNavBar());
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => BottomNavBar()));
  }
}
