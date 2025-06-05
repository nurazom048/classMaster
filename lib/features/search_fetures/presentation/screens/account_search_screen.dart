import 'package:classmate/features/routine_Fetures/presentation/widgets/dynamic_widgets/see_all_members_screen.dart';
import 'package:classmate/features/search_fetures/presentation/providers/search_account_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/export_core.dart';
import '../../../../core/widgets/account_card_row.dart';

class AccountSearchScreen extends ConsumerWidget {
  AccountSearchScreen({super.key});
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //! Provider
    final searchText = ref.watch(searchStringProvider);
    final searchAccounts = ref.watch(searchAccountController(searchText));

    return Scaffold(
      body: searchAccounts.when(
        data: (data) {
          void scrollListener(double pixels) {
            if (pixels == scrollController.position.maxScrollExtent) {
              // ignore: avoid_print
              print('End of scroll');
              ref
                  .watch(searchAccountController(searchText).notifier)
                  .loadMore(data.currentPage ?? 1);
            }
          }

          scrollController.addListener(() {
            scrollListener(scrollController.position.pixels);
          });

          return ListView.separated(
            // physics: const NeverScrollableScrollPhysics(),
            controller: scrollController,
            padding: const EdgeInsets.only(bottom: 200),
            itemCount: data.accounts?.length ?? 0,
            itemBuilder: (context, index) {
              if (data.accounts!.isNotEmpty) {
                return AccountCardRow(accountData: data.accounts![index]);
              } else {
                return const ErrorScreen(error: 'No Account found');
              }
            },
            separatorBuilder:
                (BuildContext context, int index) => const SizedBox(height: 10),
          );
        },
        error: (error, stackTrace) {
          return Alert.handleError(context, error);
          // return ErrorScreen(error: error.toString());
        },
        loading: () => Loaders.center(),
      ),
    );
  }
}
