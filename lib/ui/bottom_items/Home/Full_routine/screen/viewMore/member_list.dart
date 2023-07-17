// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously, unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classmate/core/component/loaders.dart';

import '../../../../../../core/dialogs/alert_dialogs.dart';
import '../../../../../../widgets/error/error.widget.dart';
import '../../../../../../widgets/heading_row.dart';
import '../../../utils/utils.dart';
import '../../controller/check_status_controller.dart';
import '../../controller/members_controllers.dart';
import '../../controller/see_all_req_controller.dart';
import '../../utils/popup.dart';
import '../../widgets/account_card_widgets.dart';
import '../../widgets/member_account_card.dart';

final membersCountProvider = StateProvider.autoDispose<int>((ref) => 0);
final offsetProvider = StateProvider<Offset?>((ref) => null);

class MemberList extends StatefulWidget {
  final String routineId;

  const MemberList({Key? key, required this.routineId}) : super(key: key);

  @override
  State<MemberList> createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  late ScrollController memberScrollController;

  @override
  void initState() {
    super.initState();
    // Initialize the scrollController
    memberScrollController = ScrollController();
  }

  @override
  void dispose() {
    // Dispose of the scrollController
    memberScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      // Providers
      final checkStatus =
          ref.watch(checkStatusControllerProvider(widget.routineId));

      return checkStatus.when(
        data: (data) {
          final String status = data.activeStatus;
          final bool isCaptain = data.isCaptain;
          final bool isOwner = data.isOwner;

          if (status != 'joined') {
            return const ErrorScreen(
              error: "You Are Not Member In This Routine",
            );
          }

          return onData(context, isCaptain, isOwner);
        },
        error: (error, stackTrace) => Alert.handleError(context, error),
        loading: () => Loaders.center(),
      );
    });
  }

  Widget onData(BuildContext context, bool isCaptain, bool isOwner) {
    return Consumer(builder: (context, ref, _) {
      //! provider
      final allMembers = ref.watch(memberControllerProvider(widget.routineId));
      final allMembersNotifier =
          ref.watch(memberControllerProvider(widget.routineId).notifier);

      // notifiers
      // final checkStatus =
      //     ref.watch(checkStatusControllerProvider(widget.routineId));
      // bool notificationOff = checkStatus.value?.notificationOff ?? false;
      final memberCount = ref.watch(membersCountProvider);
      final memberCountNotifier = ref.watch(membersCountProvider.notifier);
      return RefreshIndicator(
        onRefresh: () async {
          final bool isOnline = await Utils.isOnlineMethod();
          if (!isOnline) {
            Alert.showSnackBar(context, 'You are in offline mode');
          } else {
            //! provider

            ref.refresh(memberControllerProvider(widget.routineId));
            ref.refresh(checkStatusControllerProvider(widget.routineId));
          }
        },
        child: GestureDetector(
          onTapDown: (offset) {
            print(offset.globalPosition);

            ref
                .watch(offsetProvider.notifier)
                .update((state) => offset.globalPosition);
          },
          child: ListView(
            shrinkWrap: true,
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
                JoinRequestPart(routineID: widget.routineId),
              ],

              ///
              //____________________________________Members___________________________________//
              ///
              ///

              HeadingRow(
                margin: EdgeInsets.zero,
                heading: "All Members",
                secondHeading:
                    "$memberCount member${memberCount > 1 ? "s" : ''}",
              ),

              allMembers.when(
                data: (data) {
                  if (data == null) {
                    return const Text("null");
                  }
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    memberCountNotifier.update((state) => data.totalCount);
                  });
                  void scrollListener() {
                    if (memberScrollController.position.pixels ==
                        memberScrollController.position.maxScrollExtent) {
                      allMembersNotifier.loadMore(data.currentPage);
                    }
                  }

                  memberScrollController.addListener(scrollListener);

                  return ListView.builder(
                    controller: memberScrollController,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.members.length,
                    itemBuilder: (context, i) => MemberAccountCard(
                      condition: isCaptain == true || isOwner == true,
                      member: data.members[i],
                      onPressed: () {
                        accountActions(
                          context,
                          ref,
                          offset: ref.watch(offsetProvider),
                          rutinId: widget.routineId,
                          username: data.members[i].username,
                          memberId: data.members[i].id,
                          isTheMemberIsCaptain: data.members[i].captain,
                          isTheMemberIsOwner: data.members[i].owner,
                        );
                      },
                    ),
                  );
                },
                error: (error, stackTrace) => Alert.handleError(context, error),
                loading: () => Loaders.center(),
              ),
            ],
          ),
        ),
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
                requestCountNotifier
                    .update((state) => data.listAccounts.length);
              });

              return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: data.listAccounts.length,
                itemBuilder: (context, index) {
                  return AccountCard(
                    accountData: data.listAccounts[index],

                    // accept or reject members
                    acceptUsername: () {
                      seeAllJonReq.acceptMember(
                          ref, data.listAccounts[index].username, context);
                    },
                    onRejectUsername: () {
                      seeAllJonReq.rejectMembers(
                          ref, data.listAccounts[index].username, context);
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
