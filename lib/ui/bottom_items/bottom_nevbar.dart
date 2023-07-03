import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:table/core/dialogs/alert_dialogs.dart';
import 'package:table/ui/bottom_items/Add/screens/add__Notice__Screen.dart';
import 'package:table/ui/bottom_items/Add/screens/create_new_rutine.dart';
import 'package:table/ui/bottom_items/Home/Full_routine/widgets/dash_border_button.dart';

import '../../constant/app_color.dart';
import '../../widgets/bottom_sheet_shape.dart';

import '../../core/component/responsive.dart';
import '../auth_Section/auth_controller/auth_controller.dart';
import 'Collection Fetures/Ui/collections.screen.dart';
import 'Home/home_screen/home.screen.dart';
import 'Home/widgets/bottombaritem_custom.dart';

final bottomNavBarIndexProvider = StateProvider<int>((ref) => 0);
final showPlusProvider = StateProvider<bool>((ref) => false);

class BottomNavBar extends StatelessWidget {
  BottomNavBar({super.key});

  final List<Widget> pages = [
    const HomeScreen(),
    const Text("Add Screen"),
    const CollectionScreen(),
  ];
// Add Button
  static Widget add = CircleAvatar(
    radius: 20,
    backgroundColor: AppColor.nokiaBlue,
    child: const Icon(Icons.add, color: Colors.white),
  );
// Add popup
  static addpopup(BuildContext context) => plusBottomSheet(
        context,
      );
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final index = ref.watch(bottomNavBarIndexProvider);

      final hideNavBar = ref.watch(hideNevBarOnScorningProvider) ||
          !Responsive.isMobile(context);
      final showPlus = ref.watch(showPlusProvider);
      return Scaffold(
        backgroundColor: showPlus ? AppColor.background2 : null,
        body: pages[index],
        bottomNavigationBar: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: hideNavBar ? 0.0 : 1.0,
          child: Visibility(
            visible: !hideNavBar,
            child: Container(
              padding: const EdgeInsets.only(top: 6),
              margin: const EdgeInsets.symmetric(horizontal: 26, vertical: 0)
                  .copyWith(bottom: 20),
              //color: Colors.red,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(63),
                child: Container(
                  width: 340,
                  height: 64,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BottomBarItemCustom(
                        label: "Home",
                        icon: Icons.home_filled,
                        isSelected: index == 0 && showPlus == false,
                        onTap: () {
                          ref
                              .watch(bottomNavBarIndexProvider.notifier)
                              .update((state) => 0);
                        },
                      ),
                      InkWell(
                        onTap: () {
                          ref.watch(showPlusProvider.notifier).update(
                              (state) => showPlus == false ? true : false);
                          plusBottomSheet(context);
                        },
                        child: showPlus == false
                            ? CircleAvatar(
                                radius: 22,
                                backgroundColor: AppColor.nokiaBlue,
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.white,
                                  child: FaIcon(FontAwesomeIcons.plus,
                                      color: AppColor.nokiaBlue),
                                ),
                              )
                            : CircleAvatar(
                                radius: 20,
                                backgroundColor: AppColor.nokiaBlue,
                                child:
                                    const Icon(Icons.add, color: Colors.white),
                              ),
                      ),
                      BottomBarItemCustom(
                        label: "Collections",
                        icon: Icons.person_outline_outlined,
                        isSelected: index == 2 && showPlus == false,
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
          ),
        ),
      );
    });
  }
}

plusBottomSheet(BuildContext context) {
  showModalBottomSheet(
    barrierColor: Colors.transparent,
    elevation: 0,
    isScrollControlled: true,

    // barrierColor: Colors.black.withAlpha(1),
    backgroundColor: Colors.transparent,
    context: context,
    showDragHandle: false,
    enableDrag: false,

    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () => Future.value(false),
        child: Consumer(builder: (context, ref, _) {
          return Column(
            children: [
              GestureDetector(
                onDoubleTap: () {
                  ref.watch(showPlusProvider.notifier).update((state) => false);
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: MediaQuery.of(context).size.height - 90,
                  width: MediaQuery.of(context).size.width,
                  //  margin: EdgeInsets.only(bottom: size.height * 0.101),
                  color: Colors.black54,
                  child: Container(
                    color: Colors.white60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
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
                                DashBorderButtonMini(
                                  text: "Notices ",
                                  icon: Icons.calendar_view_day,
                                  onTap: () async {
                                    final String? type =
                                        await AuthController.getAccountType();
                                    if (type != null && type != 'academy') {
                                      return Get.to(() => AddNoticeScreen());
                                    } else {
                                      // ignore: use_build_context_synchronously
                                      return Alert.upcoming(context);
                                    }
                                  },
                                ),
                                Row(
                                  children: [
                                    DashBorderButtonMini(
                                      text: "Routine",
                                      icon: Icons.blender_outlined,
                                      onTap: () =>
                                          Get.to(() => CreateNewRoutine()),
                                    ),
                                    const SizedBox(width: 6)
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        //
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  ref.watch(showPlusProvider.notifier).update((state) => false);
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 90,
                  color: Colors.transparent,
                  // child: BottomNavBar(),
                ),
              )
            ],
          );
        }),
      );
    },
  );
}
