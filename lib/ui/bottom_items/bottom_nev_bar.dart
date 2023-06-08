import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rp;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:table/ui/bottom_items/Add/screens/add__Notice__Screen.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/widgets/dash_border_button.dart';
import 'package:table/widgets/appWidget/dottted_divider.dart';

import '../../constant/app_color.dart';
import 'Account/accounu_ui/account_screen.dart';
import 'Home/home_screen/home_screen.dart';

final bottomNavBarIndexProvider = rp.StateProvider<int>((ref) => 0);

class BottomNavBar extends StatelessWidget {
  BottomNavBar({super.key});

  final List<Widget> pages = [
    HomeScreen(),
    const Text("Add Screen"),
    const AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return rp.Consumer(builder: (context, ref, _) {
      final index = ref.watch(bottomNavBarIndexProvider);

      final hideNavBar = ref.watch(hideNevBarOnScrooingProvider);

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
                  TabCustom(
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
                  TabCustom(
                    label: "Account",
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

class TabCustom extends StatelessWidget {
  final VoidCallback onTap;
  final bool isSelected;
  final IconData icon;
  final String label;

  const TabCustom({
    required this.onTap,
    required this.isSelected,
    required this.icon,
    required this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColor.nokiaBlue : const Color(0xFFA7CBFF);

    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          FaIcon(
            icon,
            color: color,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w600,
              fontSize: 14,
              height: 1.26, // line-height equivalent
              letterSpacing: 0.15,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// _showBottomSheet(BuildContext context) {
//   showModalBottomSheet(
//     context: context,
//     builder: (BuildContext context) {
//       return Container(
//         height: 280.0,
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(5.0),
//             topRight: Radius.circular(5.0),
//           ),
//         ),
//         child: Column(
//           children: [
//             Card(
//               elevation: 2.0,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(5.0),
//               ),
//               child: Column(
//                 children: [
//                   ListTile(
//                     leading: const Icon(Icons.note_add),
//                     title: const Text(
//                       'Create NoticeBoard',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16.0,
//                       ),
//                     ),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => CreateNoticeBoard()),
//                       );
//                       //
// //  Navigator.pop(context);
//                       // Handle add notice action here
//                     },
//                   ),
//                   ListTile(
//                     leading: const Icon(Icons.note_add),
//                     title: const Text(
//                       'Add Notice',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16.0,
//                       ),
//                     ),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => AddNoticeScreen()),
//                       );
//                       //
// //  Navigator.pop(context);
//                       // Handle add notice action here
//                     },
//                   ),
//                   MyDividerr(),
//                   ListTile(
//                     leading: const Icon(Icons.note_add),
//                     title: const Text(
//                       'Create Routine',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16.0,
//                       ),
//                     ),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => CreaeNewRutine()),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             ListTile(
//               leading: const Icon(Icons.cancel),
//               title: const Text(
//                 'Cancel',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16.0,
//                 ),
//               ),
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         ),
//       );
//     },
//   );
//}

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
                      onTap: () => Get.to(() => AddNoticeScreen()),
                    ),
                    DashBorderButtonMoni(
                      text: "Rutine",
                      icon: const Icon(Icons.abc),
                      onTap: () {},
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

rutineNotficationSeleect(BuildContext context) {
  showModalBottomSheet(
    elevation: 0,
    barrierColor: Colors.black.withAlpha(1),
    backgroundColor: Colors.transparent,
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        height: 250,
        width: 350,
        child: Card(
          color: Colors.white,
          margin: const EdgeInsets.all(18.0)
              .copyWith(left: 30, right: 30, bottom: 30),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Container(
              //   margin: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
              //   height: 40,
              //   child: Row(
              //     children: const [
              //       Icon(Icons.check_box_outline_blank_rounded),
              //       SizedBox(width: 10),
              //       Icon(Icons.attach_file),
              //       SizedBox(width: 10),
              //       Text("Choose Attachment"),
              //     ],
              //   ),
              // ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                height: 40,
                child: const Row(
                  children: [
                    Icon(Icons.check_box_outline_blank_rounded),
                    SizedBox(width: 10),
                    Icon(Icons.notifications_active),
                    SizedBox(width: 10),
                    Text("Notification On"),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                height: 40,
                child: const Row(
                  children: [
                    Icon(Icons.check_box_outline_blank_rounded),
                    SizedBox(width: 10),
                    Icon(Icons.notifications_off),
                    SizedBox(width: 10),
                    Text("Notification Off",
                        style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
              const DotedDivider(),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                height: 40,
                child: const Row(
                  children: [
                    SizedBox(width: 10),
                    Icon(Icons.logout_sharp),
                    SizedBox(width: 10),
                    Text(
                      "Leave Routine",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
