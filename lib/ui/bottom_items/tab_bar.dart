import 'package:flutter/material.dart';
import 'package:table/helper/constant/AppColor.dart';
import 'package:table/ui/bottom_items/search/search_screen/search_page.dart';

import 'Home/home_screen/Home_screen.dart';
import 'package:intl/intl.dart';

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

    TabController _controller = TabController(vsync: this, length: 2);

    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: ChustomTitleBar(
                "title",
                ontap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPAge()),
                ),
              ),
            )
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
                  controller: _controller,
                  physics: const BouncingScrollPhysics(),
                  tabs: [
                    const Tab(child: Text("Joined Rutine")),
                    const Tab(child: Text("Joined notice")),
                    // MyTab("Feed  ", Icons.play_arrow),
                    // MyTab(" My Community", Icons.people_alt),
                    // MyTab(" My Course", MyIcons.course_file, size: 22),
                    // MyTab("Notifications", Icons.notifications)
                  ],
                ),
              ),
              // tabbar view
              Expanded(
                child: TabBarView(
                  controller: _controller,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [const HomeScreen(), const Text("norice")],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChustomTitleBar extends StatelessWidget {
  final String title;
  final IconData? icon;
  final double elevation;
  final Widget? acction;
  final dynamic ontap;

  const ChustomTitleBar(
    this.title, {
    this.ontap,
    this.icon,
    this.elevation = 4.0,
    this.acction,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    String dayOfWeek = DateFormat('EEEE').format(now);
    String date = DateFormat('MM/dd/yy').format(now);
    return Container(
      height: 60,
      color: Colors.white,
      padding: const EdgeInsets.all(9.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(flex: 1),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dayOfWeek,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  color: AppColor.nokiaBlue,
                ),
              ),
              Text(
                date,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColor.nokiaBlue,
                ),
              ),
            ],
          ),
          const Spacer(flex: 20),
          InkWell(
            onTap: ontap ?? () {},
            child: Icon(
              icon ?? Icons.search,
              size: 22,
              color: AppColor.nokiaBlue,
            ),
          ),
          acction ?? const SizedBox(width: 0),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
