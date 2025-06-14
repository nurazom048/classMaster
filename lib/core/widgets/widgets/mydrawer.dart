import 'package:classmate/core/widgets/widgets/drawer_item.dart';
import 'package:flutter/material.dart';

import '../../../features/search_fetures/presentation/screens/search_page.dart';
import '../../../ui/bottom_nevbar_items/bottom_navbar.dart';
import '../../../features/home_fetures/presentation/screens/home.screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Items
          DrawerItems(
            icon: Icons.home,
            text: "Home",
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                ),
          ),

          DrawerItems(
            icon: Icons.search,
            text: "Search",
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchPage()),
                ),
          ),

          //Add
          DrawerItems(
            widget: BottomNavBar.add,
            text: "Add",
            onTap: () => BottomNavBar.addPopup(context),
          ),
        ],
      ),
    );
  }
}
