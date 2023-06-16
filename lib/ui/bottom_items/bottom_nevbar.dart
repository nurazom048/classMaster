import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rp;
import 'package:get/get.dart';
import 'package:table/core/dialogs/alart_dialogs.dart';
import 'package:table/ui/bottom_items/Add/screens/add__Notice__Screen.dart';
import 'package:table/ui/bottom_items/Add/screens/create_new_rutine.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/widgets/dash_border_button.dart';

import '../../constant/app_color.dart';
import '../../widgets/bottom_sheet_shape.dart';

import '../../core/component/responsive.dart';
import '../auth_Section/auth_controller/auth_controller.dart';
import 'Account/accounu_ui/account_screen.dart';
import 'Home/home_screen/home.screen.dart';
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
    barrierColor: Colors.black26,
    elevation: 0,
    isScrollControlled: true,
    // barrierColor: Colors.black.withAlpha(1),
    backgroundColor: Colors.transparent,
    context: context,

    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomSheetShape(
            size: 500,
            // height: 200,
            // width: 500,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DashBorderButtonMoni(
                    text: "Notices ",
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
                  Row(
                    children: [
                      DashBorderButtonMoni(
                        text: "Rutine",
                        icon: const Icon(Icons.abc),
                        onTap: () => Get.to(() => CreaeNewRutine()),
                      ),
                      const SizedBox(width: 6)
                    ],
                  ),
                ],
              ),
            ),
          ),
          //
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(height: 90),
          )
        ],
      );
    },
  );
}





              // child: Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     DashBorderButtonMoni(
              //       text: "Notice",
              //       icon: const Icon(Icons.abc),
                 
              //     ),
              //     DashBorderButtonMoni(
              //       text: "Rutine",
              //       icon: const Icon(Icons.abc),
              //       onTap: () => Get.to(() => CreaeNewRutine()),
              //     ),
              //   ],
              // )),
