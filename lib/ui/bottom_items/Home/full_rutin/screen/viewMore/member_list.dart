import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/core/component/loaders.dart';

import '../../../../../../core/dialogs/Alart_dialogs.dart';
import '../../../../../../widgets/accound_card_row.dart';
import '../../../../../../widgets/appWidget/TextFromFild.dart';
import '../../../../../../widgets/hedding_row.dart';
import '../../../../../auth_Section/utils/login_validation.dart';
import '../../controller/members_controllers.dart';
import '../../controller/see_all_req_controller.dart';
import '../../utils/popup.dart';
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
          //____________________________________Invite___________________________________//

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

          //____________________________________Requests___________________________________//

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
                    child: allRequest.when(
                        data: (data) {
                          if (data == null) {
                            return const Text(" data null");
                          }
                          if (data.listAccounts.isEmpty) {
                            return const Text("No new request ");
                          }
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: data.listAccounts.length,
                            itemBuilder: (context, index) {
                              return AccountCard(
                                accountData: data.listAccounts[index],

                                // acsept or reject members
                                acceptUsername: () {
                                  seeAllJonReq.acceptMember(
                                      ref,
                                      data.listAccounts[index].username,
                                      context);
                                },
                                onRejectUsername: () {
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
                        loading: () => Loaders.center())),
              ],
            ),
          ),

          ///
          //____________________________________Members___________________________________//
          ///

          const HeddingRow(
            hedding: "All Members",
            secondHeading: "23 members",
          ),

          allMembers.when(
            data: (data) {
              if (data == null || data.message == null) {
                return const Text("null");
              }
              return SizedBox(
                height: 140,
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.members!.length,
                    itemBuilder: (context, index) => AccountCardRow(
                          accountData: data.members![index],
                          suffix: IconButton(
                            onPressed: () {
                              accountActions(context, ref,
                                  rutinId: rutinId,
                                  username:
                                      data.members?[index].username ?? '');
                            },
                            // onPressed: () {
                            //   print("tap");
                            //   CustomPopupMenu(
                            //       menuBuilder: () => Column(
                            //             children: const [
                            //               Text("data"),
                            //               // PopupMenuItem(
                            //               //   value: 'kickout',
                            //               //   child: Text('Kickout'),
                            //               // ),
                            //             ],
                            //           ),
                            //       pressType: PressType.singleClick,
                            //       child: Container(
                            //         child: Icon(Icons.add_circle_outline,
                            //             color: Colors.white),
                            //         padding: const EdgeInsets.all(20),
                            //       ));
                            // },

                            icon: const Icon(Icons.more_vert),
                          ),
                        )),
              );
            },
            error: (error, stackTrace) => Alart.handleError(context, error),
            loading: () => Loaders.center(),
          ),
        ],
      );
    });
  }
}
