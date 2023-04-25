import 'package:flutter/material.dart';
import 'package:table/ui/bottom_items/Account/widgets/my_divider.dart';
import 'package:table/ui/bottom_items/Add/screens/add__Notice__Screen.dart';
import 'package:table/ui/bottom_items/Add/screens/create_new_rutine.dart';
import 'package:table/ui/bottom_items/Add/screens/create_notice_board.dart';
import 'package:table/ui/bottom_items/tab_bar.dart';

import 'Account/accounu_ui/Account_screen.dart';
import 'Home/home_screen/Home_screen.dart';

List<Widget> pages = [
  HomeScreen(),
  const Text("Add Screen"),
  const AccountScreen()
];

class BottomNevBar extends StatefulWidget {
  const BottomNevBar({super.key});

  @override
  State<BottomNevBar> createState() => _BottomNewBarState();
}

class _BottomNewBarState extends State<BottomNevBar> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      /******************BottomNavigationBarItem******************* */
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: "Home",
              backgroundColor: Colors.white),

          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "",
            backgroundColor: Colors.white,
          ),

          //Account
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: "Account",
            backgroundColor: Colors.white,
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            _showBottomSheet(context);
          } else {
            setState(() => currentIndex = index);
          }
        },
        elevation: 8.1,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
      ),
    );
  }
}

void _showBottomSheet(BuildContext context) {
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
