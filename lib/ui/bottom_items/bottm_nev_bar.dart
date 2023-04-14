import 'package:flutter/material.dart';
import 'package:table/ui/bottom_items/tab_bar.dart';

import 'Account/accounu_ui/Account_screen.dart';

List<Widget> pages = [TabBatView(), const Text("Add Screen"), AccountScreen()];

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
        onTap: (index) => setState(() => currentIndex = (index)),
        elevation: 8.1,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
      ),
    );
  }
}
