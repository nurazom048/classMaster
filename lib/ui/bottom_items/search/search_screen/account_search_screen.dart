import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/search/search%20controller/search_account_controller.dart';
import 'package:table/ui/bottom_items/search/search_screen/search_page.dart';
import 'package:table/widgets/error/error.widget.dart';

import '../../../../core/component/Loaders.dart';
import '../../../../core/dialogs/alart_dialogs.dart';
import '../../../../widgets/accound_card_row.dart';

class AccountSearchScreen extends StatefulWidget {
  const AccountSearchScreen({Key? key}) : super(key: key);

  @override
  State<AccountSearchScreen> createState() => _AccountSearchScreenState();
}

class _AccountSearchScreenState extends State<AccountSearchScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      //! Provider
      final searchText = ref.watch(Serarch_String_Provider);
      final searchAccounts = ref.watch(searchAccountController(searchText));
      return SizedBox(
        height: 500,
        width: MediaQuery.of(context).size.width,
        child: searchAccounts.when(
          data: (data) {
            return ListView.separated(
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
        ),
      );
    });
  }
}
