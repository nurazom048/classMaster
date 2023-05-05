import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/search/search_screen/search_page.dart';
import 'package:flutter/material.dart' as ma;

import '../../../../core/dialogs/Alart_dialogs.dart';
import '../../../../widgets/AccoundCardRow.dart';
import '../../../../widgets/progress_indicator.dart';
import '../search_request/search_request.dart';

class AccountSearchScreen extends ConsumerWidget {
  const AccountSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //! provider
    final searchText = ref.watch(Serarch_String_Provider);
    final searchAccounts = ref.watch(search_Account_Provider(searchText));

    //
    return SizedBox(
        height: 500,
        width: MediaQuery.of(context).size.width,
        child: searchAccounts.when(
            data: (data) {
              return data.fold(
                  (l) => Alart.showSnackBar(context, l),
                  (r) => ListView.builder(
                        itemCount: r.accounts?.length,
                        itemBuilder: (context, index) {
                          if (r.accounts!.isNotEmpty) {
                            return AccountCardRow(
                                accountData: r.accounts![index]);
                          } else {
                            return const Center(
                                child: ma.Text("No Account found"));
                          }
                        },
                      ));
            },
            error: (error, stackTrace) => Alart.handleError(context, error),
            loading: () => const Progressindicator()));
  }
}
