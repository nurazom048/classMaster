// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:classmate/features/routine/presentation/widgets/dynamic_widgets/account_card_widgets.dart';
import '../../../providers/see_all_req_controller.dart';
import '../../../../../../core/export_core.dart';

final requestCountProvider = StateProvider.autoDispose<int>((ref) => 0);

class JoinRequestTabView extends ConsumerWidget {
  final String routineID;
  const JoinRequestTabView({super.key, required this.routineID});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allRequest = ref.watch(seeAllRequestControllerProvider(routineID));
    final seeAllJonReq = ref.read(
      seeAllRequestControllerProvider(routineID).notifier,
    );

    final requestCount = ref.watch(requestCountProvider);
    final requestCountNotifier = ref.watch(requestCountProvider.notifier);

    return Column(
      children: [
        HeadingRow(
          ButtonViability: true,
          heading: "Join Requests",
          secondHeading: "$requestCount",
          margin: EdgeInsets.zero,
          buttonText: "Accept All",
          onTap: () {
            seeAllJonReq.acceptMember(ref, '', context, acceptAll: true);
          },
        ),
        Container(
          height: 200,
          alignment: Alignment.centerLeft,
          child: allRequest.when(
            data: (data) {
              if (data == null) {
                return const ErrorScreen(error: "data null");
              }
              if (data.listAccounts.isEmpty) {
                return const ErrorScreen(error: "No new request ");
              }

              WidgetsBinding.instance.addPostFrameCallback((_) {
                requestCountNotifier.update(
                  (state) => data.listAccounts.length,
                );
              });

              return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: data.listAccounts.length,
                itemBuilder: (context, i) {
                  return AccountCard(
                    accountData: data.listAccounts[i],
                    acceptUsername: () {
                      seeAllJonReq.acceptMember(
                        ref,
                        data.listAccounts[i].requestId,
                        context,
                      );
                    },
                    onRejectUsername: () {
                      seeAllJonReq.rejectMembers(
                        ref,
                        data.listAccounts[i].requestId ?? '',
                        context,
                      );
                    },
                  );
                },
              );
            },
            error: (error, stackTrace) => Alert.handleError(context, error),
            loading: () => Loaders.center(),
          ),
        ),
      ],
    );
  }
}
