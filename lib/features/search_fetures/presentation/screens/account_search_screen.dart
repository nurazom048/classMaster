import 'package:classmate/features/routine/presentation/widgets/dynamic_widgets/see_all_members_screen.dart';
import 'package:classmate/features/search_fetures/presentation/providers/search_account_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/export_core.dart';
import '../../../../core/widgets/account_card_row.dart';

class AccountSearchScreen extends ConsumerWidget {
  const AccountSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //! Provider
    final searchText = ref.watch(searchStringProvider);
    final searchAccounts = ref.watch(searchAccountController(searchText));

    return searchAccounts.when(
        data: (data) {
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 200),
            itemCount: data.accounts?.length ?? 0,
            itemBuilder: (context, index) {
              if (data.accounts!.isNotEmpty) {
                return AccountCardRow(accountData: data.accounts![index]);
              } else {
                return const ErrorScreen(error: 'No Account found');
              }
            },
            separatorBuilder: (context, index) => const SizedBox(height: 10),
          );
        },
        error: (error, stackTrace) {
          return Alert.handleError(context, error);
          // return ErrorScreen(error: error.toString());
        },
        loading: () => Loaders.center(),
      );
  }
}
