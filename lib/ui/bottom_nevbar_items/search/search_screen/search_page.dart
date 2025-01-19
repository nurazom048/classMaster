// ignore_for_file: avoid_print

import 'package:classmate/ui/bottom_nevbar_items/search/widgets/search_bar_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/component/responsive.dart';
import '../../../../widgets/custom_tab_bar.widget.dart';
import '../../Home/widgets/custom_title_bar.dart';
import '../../Home/widgets/mydrawer.dart';
import 'account_search_screen.dart';
import 'search_routine_screen.dart';

//! search String provider
final searchStringProvider = StateProvider<String>((ref) => "");
final searchPageIndexProvider = StateProvider.autoDispose<int>((ref) => 0);

class SearchPAge extends StatefulWidget {
  const SearchPAge({super.key});

  @override
  State<SearchPAge> createState() => _SearchPAgeState();
}

class _SearchPAgeState extends State<SearchPAge> {
  final _appBar = const CustomTitleBar("title");

  @override
  Widget build(BuildContext context) {
    return Responsive(
      // Mobile

      mobile: SafeArea(child: Scaffold(body: _mobile())),

      // Desktop
      desktop: Scaffold(
          body: Column(
        children: [
          _appBar,
          Expanded(
            child: Row(
              children: [
                const Expanded(flex: 1, child: MyDrawer()),
                Expanded(
                  flex: 4,
                  child: Container(
                    color: Colors.yellow,
                    child: _mobile(),
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }

  Widget _mobile() {
    return Consumer(builder: (context, ref, _) {
      //
      final PageController pageController = PageController(initialPage: 0);
      return NestedScrollView(
        //   physics: const NeverScrollableScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SearchBarCustom(onChanged: (value) {
                      print(value);
                      if (mounted && value != '') {
                        ref.read(searchStringProvider.notifier).state = value;
                      }
                    }),
                  ),
                ),

                //
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: CustomTabBar(
                    // margin: const EdgeInsets.only(bottom: 20),
                    tabItems: const ['Account', 'Rutins'],
                    selectedIndex: ref.watch(searchPageIndexProvider),
                    onTabSelected: (index) {
                      pageController.jumpToPage(index);
                      ref
                          .watch(searchPageIndexProvider.notifier)
                          .update((state) => index);
                    },
                  ),
                ),
              ],
            ),
          )
        ],
        body: Container(
          margin:
              const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 0),
          width: MediaQuery.of(context).size.width,
          child: PageView(
            controller: pageController,
            onPageChanged: (index) {
              ref
                  .watch(searchPageIndexProvider.notifier)
                  .update((state) => index);
            },
            children: [
              AccountSearchScreen(),
              SearchRutineScreen(),
            ],
          ),
        ),
      );
    });
  }
}
