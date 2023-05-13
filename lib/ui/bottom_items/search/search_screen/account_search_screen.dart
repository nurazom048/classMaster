import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/search/search%20controller/search_account_controller.dart';
import 'package:table/ui/bottom_items/search/search_screen/search_page.dart';
import 'package:flutter/material.dart' as ma;

import '../../../../core/dialogs/alart_dialogs.dart';
import '../../../../widgets/accound_card_row.dart';
import '../../../../widgets/progress_indicator.dart';

class AccountSearchScreen extends ConsumerWidget {
  const AccountSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //! provider
    final searchText = ref.watch(Serarch_String_Provider);
    final searchAccounts = ref.watch(searchAccountController(searchText));

    //
    return SizedBox(
        height: 500,
        width: MediaQuery.of(context).size.width,
        child: searchAccounts.when(
            data: (data) {
              return ListView.builder(
                itemCount: data.accounts?.length,
                itemBuilder: (context, index) {
                  if (data.accounts!.isNotEmpty) {
                    return AccountCardRow(accountData: data.accounts![index]);
                  } else {
                    return const Center(child: ma.Text("No Account found"));
                  }
                },
              );
            },
            error: (error, stackTrace) => Alart.handleError(context, error),
            loading: () => const Progressindicator()));
  }
}
