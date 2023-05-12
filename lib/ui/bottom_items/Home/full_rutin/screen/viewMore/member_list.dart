import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/dialogs/Alart_dialogs.dart';
import '../../../../../../widgets/accound_card_row.dart';
import '../../../../../../widgets/appWidget/TextFromFild.dart';
import '../../../../../../widgets/hedding_row.dart';
import '../../../../../../widgets/progress_indicator.dart';
import '../../../../../auth_Section/utils/login_validation.dart';
import '../../controller/members_controllers.dart';
import '../../controller/see_all_req_controller.dart';
import '../../widgets/account_card_widgets.dart';
import '../../widgets/dash_border_button.dart';

class MemberList extends StatelessWidget {
  final String rutinId;
  MemberList({super.key, required this.rutinId});
  final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      //! provider
      final allMembers = ref.watch(all_members_provider(rutinId));
      final allRequest = ref.watch(seeAllRequestControllerProvider(rutinId));
      final seeAllJonReq =
          ref.read(seeAllRequestControllerProvider(rutinId).notifier);
      return ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 26),
        children: [
          AppTextFromField(
            margin: EdgeInsets.zero,
            controller: _emailController,
            hint: "Invite Student",
            labelText: "Enter email address",
            validator: (value) => LoginValidation.validateEmail(value),
          ),
          const SizedBox(height: 20),
          const DashBorderButton(),
          const SizedBox(height: 30),

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
                          if (data == null) return const Text(" data null");
                          if (data.listAccounts.isEmpty)
                            return const Text("No new request ");
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: data.listAccounts.length,
                            itemBuilder: (context, index) {
                              return AccountCard(
                                accountData: data.listAccounts[index],

                                // acsept or reject members
                                acceptUsername: () {
                                  print(data.listAccounts[index].username);
                                  seeAllJonReq.acceptMember(
                                      ref,
                                      data.listAccounts[index].username,
                                      context);
                                },
                                onRejectUsername: () {
                                  print(data.listAccounts[index].username);
                                  seeAllJonReq.rejectMembers(
                                      ref,
                                      data.listAccounts[index].username,
                                      context);
                                },
                              );
                            },
                          );
                        },
                        error: (error, stackTrace) =>
                            Alart.handleError(context, error),
                        loading: () => const Text("data"))),
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

          allMembers.when(
            data: (data) {
              if (data == null || data.message == null)
                return const Text("null");
              return SizedBox(
                height: 140,
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.members!.length,
                    itemBuilder: (context, index) =>
                        AccountCardRow(accountData: data.members![index])),
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
