// ignore_for_file: avoid_print

import 'package:classmate/features/search_fetures/presentation/widgets/static_wdgets/search_bar_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/component/responsive.dart';
import '../../../../core/widgets/custom_tab_bar.widget.dart';
import '../../../../core/widgets/widgets/custom_title_bar.dart';
import '../../../../core/widgets/widgets/mydrawer.dart';
import '../providers/search_account_controller.dart';
import '../../../routine/presentation/providers/routine_list_provider.dart';
import 'account_search_screen.dart';
import 'search_routine_screen.dart';
import 'search_notice_screen.dart';

//! search String provider
final searchStringProvider = StateProvider<String>((ref) => "");
final searchPageIndexProvider = StateProvider.autoDispose<int>((ref) => 0);

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _appBar = const CustomTitleBar("title");
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      final selectedIndex = ref.read(searchPageIndexProvider);
      final searchText = ref.read(searchStringProvider);
      if (selectedIndex == 0) {
        final searchAccounts = ref.read(searchAccountController(searchText));
        ref
            .read(searchAccountController(searchText).notifier)
            .loadMore(searchAccounts.value?.currentPage ?? 1);
      } else if (selectedIndex == 1) {
        ref
            .read(
              routineListProvider(
                RoutineListQuery(search: searchText),
              ).notifier,
            )
            .loadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body: _mobile()));
  }

  Widget _mobile() {
    return Consumer(
      builder: (context, ref, _) {
        final selectedIndex = ref.watch(searchPageIndexProvider);
        return SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SearchBarCustom(
                  onChanged: (value) {
                    print(value);
                    if (mounted && value != '') {
                      ref.read(searchStringProvider.notifier).state = value;
                    }
                  },
                ),
              ),

              // Custom Tab Bar with 3 tabs: Account, Routine, Notice
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                child: CustomTabBar(
                  tabItems: const ['Account', 'Routine', 'Notice'],
                  selectedIndex: selectedIndex,
                  onTabSelected: (index) {
                    ref.read(searchPageIndexProvider.notifier).state = index;
                  },
                ),
              ),

              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                ).copyWith(bottom: 0),
                width: MediaQuery.of(context).size.width,
                child: IndexedStack(
                  index: selectedIndex,
                  children: const [
                    AccountSearchScreen(),
                    SearchRoutineScreen(),
                    SearchNoticeScreen(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
