// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:table/helper/constant/app_color.dart';
import 'Home/home_screen/Home_screen.dart';
import 'Home/tababar items/joined_rutine_screen.dart';

class TabBatView extends StatefulWidget {
  const TabBatView({Key? key}) : super(key: key);

  @override
  _TopTabController createState() => _TopTabController();
}

class _TopTabController extends State<TabBatView>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    // provider

    TabController controller = TabController(vsync: this, length: 3);

    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            // SliverToBoxAdapter(
            //   child: ChustomTitleBar(
            //     "title",
            //     ontap: () => Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const SearchPAge()),
            //     ),
            //   ),
            // )
          ],

          // top tabbar
          body: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 6, bottom: 6),
                // color: Theme.of(context).scaffoldBackgroundColor,
                color: AppColor.background,
                width: double.infinity,
                child: TabBar(
                  unselectedLabelColor: Colors.black54,
                  labelColor: Colors.blue.shade300,
                  //  indicatorWeight: 0.00001,
                  isScrollable: true,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  controller: controller,
                  physics: const BouncingScrollPhysics(),
                  tabs: const [
                    Tab(child: Text("Joined Rutine")),
                    Tab(child: Text("Joined notice")),
                    Tab(child: Text("Notification")),
                  ],
                ),
              ),
              // tabbar view
              Expanded(
                child: TabBarView(
                  controller: controller,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    HomeScreen(),
                    const JoinedRutineScreen(),
                    const Text("notification"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
