import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rp;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:table/ui/bottom_items/Account/widgets/my_divider.dart';
import 'package:table/ui/bottom_items/Add/screens/add__Notice__Screen.dart';
import 'package:table/ui/bottom_items/Add/screens/create_new_rutine.dart';

import '../../helper/constant/AppColor.dart';
import 'Account/accounu_ui/Account_screen.dart';
import 'Add/screens/create_notice_board.dart';
import 'Home/home_screen/Home_screen.dart';

final BotomNevBarIndexProvider = rp.StateProvider<int>((ref) => 0);

class BottomNevBar extends StatelessWidget {
  BottomNevBar({super.key});
//
  List<Widget> pages = [
    HomeScreen(),
    const Text("Add Screen"),
    const AccountScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return rp.Consumer(builder: (BuildContext context, rp.WidgetRef ref, _) {
      //! provider
      final index = ref.watch(BotomNevBarIndexProvider);

      return Scaffold(
        // body
        body: pages[index],
        /******************BottomNavigationBarItem********************/
        bottomNavigationBar: Container(
          width: 340,
          height: 64,
          margin:
              const EdgeInsets.symmetric(horizontal: 26).copyWith(bottom: 20),
          padding: const EdgeInsets.symmetric(vertical: 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(63),
            // boxShadow: [
            //   BoxShadow(
            //     color: Color.fromRGBO(242, 242, 242, 1),
            //     blurRadius: 30,
            //     offset: Offset(0, 5),
            //     spreadRadius: 25,
            //   ),
            // ],
          ),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Add navigation items here
                Text("${ref.watch(BotomNevBarIndexProvider)}"),
                TabCustom(
                  lable: "Home",
                  icon: Icons.home_filled,
                  isSelcted: ref.watch(BotomNevBarIndexProvider) == 0,
                  onTap: () {
                    ref
                        .watch(BotomNevBarIndexProvider.notifier)
                        .update((state) => 0);
                    print("ontap");
                  },
                ),
                InkWell(
                    onTap: () {
                      _showBottomSheet(context);
                      // ref
                      //     .watch(BotomNevBarIndexProvider.notifier)
                      //     .update((state) => 1);
                      print("ontap");
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColor.nokiaBlue,
                      child: const Icon(Icons.add, color: Colors.white),
                    )),
                InkWell(
                  child: const Text("Account"),
                  onTap: () {
                    ref
                        .watch(BotomNevBarIndexProvider.notifier)
                        .update((state) => 2);
                    print("ontap");
                  },
                ),
              ],
            ),
          ),
        ),
        // bottomNavigationBar: BottomNavigationBar(
        //   items: const [
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.home_filled),
        //         label: "Home",
        //         backgroundColor: Colors.white),

        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.add),
        //       label: "",
        //       backgroundColor: Colors.white,
        //     ),

        //     //Account
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.account_circle_outlined),
        //       label: "Account",
        //       backgroundColor: Colors.white,
        //     ),
        //   ],
        //   onTap: (index) {
        //     if (index == 1) {
        //       _showBottomSheet(context);
        //     } else {
        //       setState(() => currentIndex = index);
        //     }
        //   },
        //   elevation: 8.1,
        //   type: BottomNavigationBarType.fixed,
        //   currentIndex: currentIndex,
        // ),
      );
    });
  }
}

class TabCustom extends StatelessWidget {
  final dynamic onTap;
  final bool isSelcted;
  final IconData icon;
  final String lable;
  const TabCustom({
    super.key,
    required this.onTap,
    required this.isSelcted,
    required this.icon,
    required this.lable,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          FaIcon(
            icon,
            color: isSelcted ? const Color(0xFFA7CBFF) : Colors.black,
          ),
          const SizedBox(width: 5),
          Text(
            lable,
            style: TextStyle(
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w600,
              fontSize: 14,
              height: 1.26, // line-height equivalent
              letterSpacing: 0.15,
              color: isSelcted ? const Color(0xFFA7CBFF) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

_showBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 280.0,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5.0),
            topRight: Radius.circular(5.0),
          ),
        ),
        child: Column(
          children: [
            Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.note_add),
                    title: const Text(
                      'Create NoticeBoard',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateNoticeBoard()),
                      );
                      //
//  Navigator.pop(context);
                      // Handle add notice action here
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.note_add),
                    title: const Text(
                      'Add Notice',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddNoticeScreen()),
                      );
                      //
//  Navigator.pop(context);
                      // Handle add notice action here
                    },
                  ),
                  MyDividerr(),
                  ListTile(
                    leading: const Icon(Icons.note_add),
                    title: const Text(
                      'Create Routine',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreaeNewRutine()),
                      );
                    },
                  ),

                  ///
                  ///
                  ///
                  // ListTile(
                  //   leading: const Icon(Icons.note_add),
                  //   title: const Text(
                  //     'Add Class',
                  //     style: TextStyle(
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 16.0,
                  //     ),
                  //   ),
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => CreaeNewRutine()),
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text(
                'Cancel',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
