// ignore_for_file: sized_box_for_whitespace, non_constant_identifier_names, must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/controller/Rutin_controller.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/widgets/component/request_account_card.dart';
import 'package:table/widgets/Alart.dart';

class SeeAllRequest extends ConsumerWidget {
  String rutin_id;
  SeeAllRequest({super.key, required this.rutin_id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final all_request = ref.watch(see_all_request_provider(rutin_id));

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              height: 10,
              child: CloseButton(onPressed: () => Navigator.pop(context)),
            ),
            Container(
                height: 700,
                width: 700,
                child: all_request.when(
                    data: (data) {
                      return ListView.builder(
                        itemCount: data.allRequest?.length ?? 0,
                        itemBuilder: (context, index) {
                          return data.allRequest != null ||
                                  data.allRequest!.isNotEmpty
                              ? requestAccountCard(
                                  Request: data,
                                  accountData: data.allRequest![index],
                                  acceptOnTap: () {
                                    ref.watch(accept_request_provider(accept(
                                        rutin_id: rutin_id,
                                        user_id:
                                            data.allRequest![index].username)));
                                  },
                                )
                              : const Center(child: Text('No New Request'));
                        },
                      );
                    },
                    error: (error, stackTrace) =>
                        Alart.handleError(context, error),
                    loading: () => const Text("loding"))),
          ],
        ),
      ),
    );
  }
}
