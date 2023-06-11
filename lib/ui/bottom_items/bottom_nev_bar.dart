import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rp;
import 'package:get/get.dart';
import 'package:table/core/dialogs/alart_dialogs.dart';
import 'package:table/ui/bottom_items/Add/screens/add__Notice__Screen.dart';
import 'package:table/ui/bottom_items/Add/screens/create_new_rutine.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/widgets/dash_border_button.dart';

import '../../constant/app_color.dart';
import '../../core/component/responsive.dart';
import '../auth_Section/auth_controller/auth_controller.dart';
import 'Account/accounu_ui/account_screen.dart';
import 'Home/home_screen/home_screen.dart';
import 'Home/widgets/bottombaritem_custom.dart';

final bottomNavBarIndexProvider = rp.StateProvider<int>((ref) => 0);

class BottomNavBar extends StatelessWidget {
  BottomNavBar({super.key});

  final List<Widget> pages = [
    HomeScreen(),
    const Text("Add Screen"),
    const AccountScreen(),
  ];
// Add Button
  static Widget add = CircleAvatar(
    radius: 20,
    backgroundColor: AppColor.nokiaBlue,
    child: const Icon(Icons.add, color: Colors.white),
  );
// Add popup
  static addpopup(BuildContext context) => _showBottomSheet(context);
  @override
  Widget build(BuildContext context) {
    return rp.Consumer(builder: (context, ref, _) {
      final index = ref.watch(bottomNavBarIndexProvider);

      final hideNavBar = ref.watch(hideNevBarOnScrooingProvider) ||
          !Responsive.isMobile(context);

      return Scaffold(
        body: pages[index],
        bottomNavigationBar: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: hideNavBar ? 0.0 : 1.0,
          child: Visibility(
            visible: !hideNavBar,
            child: Container(
              width: 340,
              height: 64,
              margin: const EdgeInsets.symmetric(horizontal: 26, vertical: 0)
                  .copyWith(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(63),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BottomBarItemCustom(
                    label: "Home",
                    icon: Icons.home_filled,
                    isSelected: index == 0,
                    onTap: () {
                      ref
                          .watch(bottomNavBarIndexProvider.notifier)
                          .update((state) => 0);
                    },
                  ),
                  InkWell(
                    onTap: () => _showBottomSheet(context),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColor.nokiaBlue,
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                  BottomBarItemCustom(
                    label: "Collections",
                    icon: Icons.person_outline_outlined,
                    isSelected: index == 2,
                    onTap: () {
                      ref
                          .watch(bottomNavBarIndexProvider.notifier)
                          .update((state) => 2);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

_showBottomSheet(BuildContext context) {
  showModalBottomSheet(
    elevation: 0,
    barrierColor: Colors.black.withAlpha(1),
    backgroundColor: Colors.transparent,
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
          height: 200,
          width: 500,
          child: Card(
            color: Colors.white,
            margin: const EdgeInsets.all(18.0)
                .copyWith(left: 30, right: 30, bottom: 100),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DashBorderButtonMoni(
                      text: "Notice",
                      icon: const Icon(Icons.abc),
                      onTap: () async {
                        final String? type =
                            await AuthController.getAccountType();
                        if (type != null && type == 'academy') {
                          return Get.to(() => AddNoticeScreen());
                        } else {
                          // ignore: use_build_context_synchronously
                          return Alart.upcoming(context);
                        }
                      },
                    ),
                    DashBorderButtonMoni(
                      text: "Rutine",
                      icon: const Icon(Icons.abc),
                      onTap: () => Get.to(() => CreaeNewRutine()),
                    ),
                  ],
                ),
                // SizedBox(height: 20),
                // Container(
                //   color: Colors.red,
                //   height: 100,
                //   width: 100,
                //   transform: Matrix4.rotationZ(0.8),
                // ),
              ],
            ),
          ));
    },
  );
}
