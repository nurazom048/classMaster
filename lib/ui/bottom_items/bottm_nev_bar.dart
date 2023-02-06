import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:table/ui/bottom_items/Account_screen.dart';
import 'package:table/ui/bottom_items/all_rutins.dart';

List<Widget> pages = [AllRutins(), Text("data"), AccountScreen()];

class BottomNewBar extends StatefulWidget {
  const BottomNewBar({super.key});

  @override
  State<BottomNewBar> createState() => _BottomNewBarState();
}

class _BottomNewBarState extends State<BottomNewBar> {
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

          // post
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
            backgroundColor: Colors.white,
          ),
          // Chats

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
