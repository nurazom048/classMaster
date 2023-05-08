import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Account/models/Account_models.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/widgets/account_card_widgets.dart';

import '../../../../../../core/dialogs/Alart_dialogs.dart';
import '../../../../../../widgets/hedding_row.dart';
import '../../notice controller/notice_board_request_controller.dart';

class NoticeBoardMembersScreen extends StatelessWidget {
  final String noticeBoardId;
  const NoticeBoardMembersScreen({super.key, required this.noticeBoardId});
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      //! provider

      // final allMembers = ref.watch(all_members_provider(rutinId));
      final allRequest =
          ref.watch(noticeBoardJoinRequestControllerProvider(noticeBoardId));
      // final seeAllJonReq =
      //     ref.read(seeAllRequestControllerProvider(rutinId).notifier);
      return ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 26),
        children: [
          //... Members...//
          HeddingRow(
            hedding: "Join Requests",
            second_Hedding: "see more",
            buttonText: "Accept All",
            onTap: () {},
          ),

          SizedBox(
            height: 200,
            child: Column(
              children: [
                SizedBox(
                    height: 200,
                    child: allRequest.when(
                        data: (data) {
                          print("data");
                          // return const Text(" data ");
                          if (data.joinRequests.isEmpty) {
                            return const Text("No new request ");
                          }
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: data.joinRequests.length,
                            itemBuilder: (context, index) {
                              return AccountCard(
                                accountData: data.joinRequests[index],

                                // acsept or reject members
                                acceptUsername: () {
                                  // print(data.joinRequests[index].username);
                                  // seeAllJonReq.acceptMember(
                                  //     ref,
                                  //     data.listAccounts[index].username,
                                  //     context);
                                },
                                onRejectUsername: () {
                                  // print(data.joinRequests[index].username);
                                  // seeAllJonReq.rejectMembers(
                                  //     ref,
                                  //    data.joinRequests[index].username,
                                  //     context);
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
            second_Hedding: "24 members",
          ),
          //

          // allMembers.when(
          //   data: (data) {
          //     if (data == null || data.message == null)
          //       return const Text("null");
          //     return SizedBox(
          //       height: 140,
          //       child: ListView.builder(
          //           physics: const NeverScrollableScrollPhysics(),
          //           itemCount: data.Members!.length,
          //           itemBuilder: (context, index) =>
          //               AccountCardRow(accountData: data.Members![index])),
          //     );
          //   },
          //   error: (error, stackTrace) => Alart.handleError(context, error),
          //   loading: () => const Progressindicator(),
          // ),
        ],
      );
    });
  }
}
