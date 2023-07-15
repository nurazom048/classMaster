import 'package:get/get.dart';
import 'package:table/local%20data/local_data.dart';

import '../ui/bottom_items/bottom_navbar.dart';

Future<void> navigateBaseOnToken() async {
  final String? token = await LocalData.getAuthToken();
  final String? refreshToken = await LocalData.getRefreshToken();

  // ignore: avoid_print
  print("Token: $token");
  if (token != null && refreshToken != null) {
    // ignore: use_build_context_synchronously

    Get.to(() => BottomNavBar());
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => BottomNavBar()));
  }
}
