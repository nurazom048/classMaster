// ignore_for_file: sized_box_for_whitespace, non_constant_identifier_names, must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/request/member_request.dart';
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
    final all_request = ref.watch(see_all_request_provider(rutin_id));

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
                        return data.allRequest != null ||
                                data.allRequest!.isNotEmpty
                            ? ListView.builder(
                                itemCount: data.allRequest?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return data.allRequest != null ||
                                          data.allRequest!.isNotEmpty
                                      ? requestAccountCard(
                                          accountData: data.allRequest![index],

                                          //... acsept reject...//
                                          acceptUsername: () => acceptUsername(
                                              data.allRequest![index].username),
                                          onRejectUsername: () =>
                                              onRejectUsername(data
                                                  .allRequest![index].username),
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
