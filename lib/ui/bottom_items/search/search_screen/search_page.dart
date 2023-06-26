// ignore_for_file: sized_box_for_whitespace, non_constant_identifier_names, prefer_typing_uninitialized_variables, avoid_print, unused_local_variable, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/search/search_screen/account_search_screen.dart';
import 'package:table/ui/bottom_items/search/search_screen/search_rutine_screen.dart';
import 'package:table/ui/bottom_items/search/widgets/search_bar_custom.dart';

import '../../../../core/component/responsive.dart';
import '../../../../widgets/custom_tab_bar.widget.dart';
import '../../Home/widgets/custom_title_bar.dart';
import '../../Home/widgets/mydrawer.dart';

//! search String provider
final Serarch_String_Provider = StateProvider<String>((ref) => "");
final searchPageIndexProvider = StateProvider<int>((ref) => 0);

class SearchPAge extends StatefulWidget {
  const SearchPAge({super.key});

  @override
  State<SearchPAge> createState() => _SearchPAgeState();
}

class _SearchPAgeState extends State<SearchPAge> {
  final _appBar = const ChustomTitleBar("title");

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
                const Expanded(flex: 1, child: MyDawer()),
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
        physics: const NeverScrollableScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  height: 50,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SearchBarCustom(onChanged: (valu) {
                      print(valu);
                      if (mounted && valu != '') {
                        ref.read(Serarch_String_Provider.notifier).state = valu;
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
          margin: const EdgeInsets.symmetric(horizontal: 10),
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
