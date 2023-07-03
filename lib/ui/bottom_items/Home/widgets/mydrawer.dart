import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table/ui/bottom_items/Home/home_screen/home.screen.dart';
import 'package:table/ui/bottom_items/Home/widgets/drawer_item.dart';

import '../../bottom_nevbar.dart';
import '../../search/search_screen/search_page.dart';

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
            onTap: () => Get.to(() => const HomeScreen()),
          ),

          DrawerItems(
            icon: Icons.search,
            text: "Search",
            onTap: () => Get.to(() => const SearchPAge()),
          ),

          //Add
          DrawerItems(
            widget: BottomNavBar.add,
            text: "Add",
            onTap: () => BottomNavBar.addpopup(context),
          ),
        ],
      ),
    );
  }
}
