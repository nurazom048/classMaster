// ignore_for_file: sized_box_for_whitespace, non_constant_identifier_names, must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/controller/see_all_member.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/widgets/component/request_account_card.dart';
import 'package:table/widgets/Alart.dart';

class SeeAllRequest extends ConsumerWidget {
  String rutin_id;
  final Function(String?) onRejectUsername;
  final Function(String?) acceptUsername;

  SeeAllRequest(
      {super.key,
      required this.rutin_id,
      required this.onRejectUsername,
      required this.acceptUsername});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final all_request = ref.watch(seeAllRequestControllerProvider(rutin_id));

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.centerLeft,
                child: CloseButton(onPressed: () => Navigator.pop(context)),
              ),
            ),
            Expanded(
              flex: 38,
              child: Container(
                  child: all_request.when(
                      data: (data) {
                        return data.listAccounts.isNotEmpty
                            ? ListView.builder(
                                itemCount: data.listAccounts.length,
                                itemBuilder: (context, index) {
                                  return data.listAccounts.isNotEmpty
                                      ? requestAccountCard(
                                          accountData: data.listAccounts[index],

                                          //... acsept reject...//
                                          acceptUsername: () => acceptUsername(
                                              data.listAccounts[index]
                                                  .username),
                                          onRejectUsername: () =>
                                              onRejectUsername(data
                                                  .listAccounts[index]
                                                  .username),
                                        )
                                      : Center(
                                          child: Container(
                                              height: 300,
                                              child: const Text(
                                                  'No New Request')));
                                },
                              )
                            : Center(
                                child: Container(
                                    height: 300,
                                    width: 200,
                                    child: const Text('No New Request')));
                      },
                      error: (error, stackTrace) =>
                          Alart.handleError(context, error),
                      loading: () => const Text("loding"))),
            ),
          ],
        ),
      ),
    );
  }
}
