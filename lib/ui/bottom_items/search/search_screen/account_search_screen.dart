import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/search/search%20controller/search_account_controller.dart';
import 'package:table/ui/bottom_items/search/search_screen/search_page.dart';
import 'package:table/widgets/error/error.widget.dart';

import '../../../../core/component/Loaders.dart';
import '../../../../core/dialogs/alart_dialogs.dart';
import '../../../../widgets/accound_card_row.dart';

class AccountSearchScreen extends ConsumerWidget {
  const AccountSearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //! Provider
    final searchText = ref.watch(Serarch_String_Provider);
    final searchAccounts = ref.watch(searchAccountController(searchText));

    return searchAccounts.when(
      data: (data) {
        return ListView.separated(
          // physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 100),
          itemCount: data.accounts?.length ?? 0,
          itemBuilder: (context, index) {
            if (data.accounts!.isNotEmpty) {
              return AccountCardRow(accountData: data.accounts![index]);
            } else {
              return const ErrorScreen(error: 'No Account found');
            }
          },
          separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(height: 10),
        );
      },
      error: (error, stackTrace) {
        Alart.handleError(context, error);
        return ErrorScreen(error: error.toString());
      },
      loading: () => Loaders.center(),
    );
  }
}
