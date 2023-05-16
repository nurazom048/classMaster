import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/widgets/account_card_widgets.dart';

import '../../../../../../core/dialogs/alart_dialogs.dart';
import '../../../../../../widgets/accound_card_row.dart';
import '../../../../../../widgets/hedding_row.dart';
import '../../../../../../widgets/progress_indicator.dart';
import '../../notice controller/finalMEmbers_controller.dart';
import '../../notice controller/noticeboard_join_controller.dart';

class NoticeBoardMembersScreen extends StatelessWidget {
  final String noticeBoardId;
  const NoticeBoardMembersScreen({super.key, required this.noticeBoardId});
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      //! provider

      final allMembers = ref.watch(finalMemberConollerList(noticeBoardId));
      final memberRequest =
          ref.watch(noticeboardJoinRequestController(noticeBoardId));
// notifier
      final memberRequestNotifier =
          ref.watch(noticeboardJoinRequestController(noticeBoardId).notifier);
      // final seeAllJonReq =
      //     ref.read(seeAllRequestControllerProvider(rutinId).notifier);
      return ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 26),
        children: [
          //... Members...//
          HeddingRow(
            hedding: "Join Requests",
            secondHeading: "see more",
            buttonText: "Accept All",
            onTap: () {},
          ),

          SizedBox(
            height: 200,
            child: Column(
              children: [
                SizedBox(
                    height: 200,
                    child: memberRequest.when(
                        data: (data) {
                          if (data.joinRequests.isEmpty) {
                            return const Text("No new request ");
                          }
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: data.joinRequests.length,
                            itemBuilder: (context, index) {
                              String id = data.joinRequests[index].sId ?? '';
                              return AccountCard(
                                accountData: data.joinRequests[index],

                                // acsept or reject members
                                acceptUsername: () {
                                  memberRequestNotifier.acceptRequest(
                                      id, context, ref);
                                },
                                onRejectUsername: () {
                                  memberRequestNotifier.rejectMembers(
                                      id, context, ref);
                                },
                              );
                            },
                          );
                        },
                        error: (error, stackTrace) =>
                            Alart.handleError(context, error),
                        loading: () => const Text("Loding"))),
              ],
            ),
          ),

          ///
          ///

          const HeddingRow(
            hedding: "All Members",
            secondHeading: "24 members",
          ),
          //

          allMembers.when(
            data: (data) {
              return SizedBox(
                height: 140,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.members.length,
                  itemBuilder: (context, index) => AccountCardRow(
                    accountData: data.members[index],
                  ),
                ),
              );
            },
            error: (error, stackTrace) => Alart.handleError(context, error),
            loading: () => const Progressindicator(),
          ),
        ],
      );
    });
  }
}
