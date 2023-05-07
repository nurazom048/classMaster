import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../widgets/hedding_row.dart';

class NoticeBoardMembersScreen extends StatelessWidget {
  final String rutinId;
  const NoticeBoardMembersScreen({super.key, required this.rutinId});
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      //! provider
      // final allMembers = ref.watch(all_members_provider(rutinId));
      // final allRequest = ref.watch(seeAllRequestControllerProvider(rutinId));
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
                Container(
                  height: 200,
                  // child: allRequest.when(
                  //     data: (data) {
                  //       if (data == null) return const Text(" data null");
                  //       if (data.listAccounts.isEmpty)
                  //         return const Text("No new request ");
                  //       return ListView.builder(
                  //         scrollDirection: Axis.horizontal,
                  //         itemCount: data.listAccounts.length,
                  //         itemBuilder: (context, index) {
                  //           return AccountCard(
                  //             accountData: data.listAccounts[index],

                  //             // acsept or reject members
                  //             acceptUsername: () {
                  //               print(data.listAccounts[index].username);
                  //               seeAllJonReq.acceptMember(
                  //                   ref,
                  //                   data.listAccounts[index].username,
                  //                   context);
                  //             },
                  //             onRejectUsername: () {
                  //               print(data.listAccounts[index].username);
                  //               seeAllJonReq.rejectMembers(
                  //                   ref,
                  //                   data.listAccounts[index].username,
                  //                   context);
                  //             },
                  //           );
                  //         },
                  //       );
                  //     },
                  //     error: (error, stackTrace) =>
                  //         Alart.handleError(context, error),
                  //     loading: () => const Text("data"))
                ),
              ],
            ),
          ),

          ///
          ///

          const HeddingRow(
            hedding: "All Members",
            second_Hedding: "23 members",
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
