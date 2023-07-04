// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/core/component/loaders.dart';

import '../../../../../../core/dialogs/alert_dialogs.dart';
import '../../../../../../widgets/error/error.widget.dart';
import '../../../../../../widgets/heading_row.dart';
import '../../controller/chack_status_controller.dart';
import '../../controller/members_controllers.dart';
import '../../controller/see_all_req_controller.dart';
import '../../utils/popup.dart';
import '../../widgets/account_card_widgets.dart';
import '../../widgets/member_account_card.dart';

final membersCountProvider = StateProvider.autoDispose<int>((ref) => 0);

class MemberList extends StatelessWidget {
  final String routineId;
  const MemberList({super.key, required this.routineId});
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      //! provider
      final allMembers = ref.watch(all_members_provider(routineId));

      // notifiers
      final checkStatus = ref.watch(checkStatusControllerProvider(routineId));
      final String status = checkStatus.value?.activeStatus ?? '';
      final bool isCaptain = checkStatus.value?.isCaptain ?? false;
      final bool isOwner = checkStatus.value?.isOwner ?? false;

      // bool notificationOff = checkStatus.value?.notificationOff ?? false;
      final memberCount = ref.watch(membersCountProvider);
      final memberCountNotifier = ref.watch(membersCountProvider.notifier);

      if (status != 'joined') {
        return const ErrorScreen(
          error: "You Are Not Member In This Routine",
        );
      }

      return ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          //____________________________________Invite___________________________________//

          // AppTextFromField(
          //   margin: EdgeInsets.zero,
          //   controller: _emailController,
          //   hint: "Invite Student",
          //   labelText: "Enter email address",
          //   validator: (value) => LoginValidation.validateEmail(value),
          // ),
          // const SizedBox(height: 20),
          // const DashBorderButton(),
          // const SizedBox(height: 30),

          //____________________________________Requests___________________________________//
          if (isCaptain == true || isOwner == true) ...[
            JoinRequestPart(routineID: routineId),
          ],

          ///
          //____________________________________Members___________________________________//
          ///

          HeadingRow(
            margin: EdgeInsets.zero,
            heading: "All Members",
            secondHeading: "$memberCount member${memberCount > 1 ? "s" : ''}",
          ),

          allMembers.when(
            data: (data) {
              if (data == null) {
                return const Text("null");
              }
              WidgetsBinding.instance.addPostFrameCallback((_) {
                memberCountNotifier.update((state) => data.count);
              });

              return SizedBox(
                height: 200,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.members.length,
                  itemBuilder: (context, i) => MemberAccountCard(
                    condition: isCaptain == true || isOwner == true,
                    member: data.members[i],
                    onPressed: () {
                      accountActions(
                        context,
                        ref,
                        rutinId: routineId,
                        username: data.members[i].username,
                        memberId: data.members[i].id,
                        isTheMemberIsCaptain: data.members[i].captain,
                        isTheMemberIsOwner: data.members[i].owner,
                      );
                    },
                  ),
                ),
              );
            },
            error: (error, stackTrace) => Alert.handleError(context, error),
            loading: () => Loaders.center(),
          ),
        ],
      );
    });
  }
}

final requestCountProvider = StateProvider.autoDispose<int>((ref) => 0);

class JoinRequestPart extends ConsumerWidget {
  final String routineID;
  const JoinRequestPart({super.key, required this.routineID});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //! provider
    final allRequest = ref.watch(seeAllRequestControllerProvider(routineID));
    final seeAllJonReq =
        ref.read(seeAllRequestControllerProvider(routineID).notifier);

//
    final requestCount = ref.watch(requestCountProvider);
    final requestCountNotifier = ref.watch(requestCountProvider.notifier);
    return Column(
      children: [
        HeadingRow(
          heading: "Join Requests",
          secondHeading: "$requestCount",
          margin: EdgeInsets.zero,
          buttonText: "Accept All",
          onTap: () {
            seeAllJonReq.acceptMember(ref, '', context, acceptAll: true);
          },
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
                        return const ErrorScreen(error: "data null");
                      }
                      if (data.listAccounts.isEmpty) {
                        return const ErrorScreen(error: "No new request ");
                      }

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        requestCountNotifier
                            .update((state) => data.listAccounts.length);
                      });

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: data.listAccounts.length,
                        itemBuilder: (context, index) {
                          return AccountCard(
                            accountData: data.listAccounts[index],

                            // accept or reject members
                            acceptUsername: () {
                              seeAllJonReq.acceptMember(ref,
                                  data.listAccounts[index].username, context);
                            },
                            onRejectUsername: () {
                              seeAllJonReq.rejectMembers(ref,
                                  data.listAccounts[index].username, context);
                            },
                          );
                        },
                      );
                    },
                    error: (error, stackTrace) =>
                        Alert.handleError(context, error),
                    loading: () => Loaders.center(),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}