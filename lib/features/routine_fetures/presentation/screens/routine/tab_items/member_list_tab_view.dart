// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously, unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:classmate/features/home_fetures/presentation/utils/utils.dart';
import 'package:classmate/features/routine_fetures/presentation/widgets/dynamic_widgets/account_card_widgets.dart';
import '../../../providers/chack_status_controller.dart';
import '../../../providers/member_controller_provider.dart';
import '../../../../../../core/export_core.dart';
import '../../../utils/popup.dart';
import '../../../widgets/static_widgets/member_account_card.dart';

final membersCountProvider = StateProvider.autoDispose<int>((ref) => 0);
final offsetProvider = StateProvider<Offset?>((ref) => null);

class MemberListTabView extends StatefulWidget {
  final String routineId;

  const MemberListTabView({super.key, required this.routineId});

  @override
  State<MemberListTabView> createState() => _MemberListTabViewState();
}

class _MemberListTabViewState extends State<MemberListTabView> {
  late ScrollController memberScrollController;

  @override
  void initState() {
    super.initState();
    memberScrollController = ScrollController();
  }

  @override
  void dispose() {
    memberScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final checkStatus = ref.watch(
          checkStatusControllerProvider(widget.routineId),
        );

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
      },
    );
  }

  Widget onData(BuildContext context, bool isCaptain, bool isOwner) {
    return Consumer(
      builder: (context, ref, _) {
        final allMembers = ref.watch(
          memberControllerProvider(widget.routineId),
        );
        final allMembersNotifier = ref.watch(
          memberControllerProvider(widget.routineId).notifier,
        );

        final memberCount = ref.watch(membersCountProvider);
        final memberCountNotifier = ref.watch(membersCountProvider.notifier);

        return RefreshIndicator(
          onRefresh: () async {
            final bool isOnline = await Utils.isOnlineMethod();
            if (!isOnline) {
              Alert.showSnackBar(context, 'You are in offline mode');
            } else {
              ref.refresh(memberControllerProvider(widget.routineId));
              ref.refresh(checkStatusControllerProvider(widget.routineId));
            }
          },
          child: GestureDetector(
            onTapDown: (offset) {
              ref
                  .watch(offsetProvider.notifier)
                  .update((state) => offset.globalPosition);
            },
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                HeadingRow(
                  margin: EdgeInsets.zero,
                  ButtonViability: true,
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
                      itemBuilder:
                          (context, i) => MemberAccountCard(
                            condition: isCaptain == true || isOwner == true,
                            member: data.members[i],
                            onPressed: () {
                              accountActions(
                                context,
                                ref,
                                offset: ref.watch(offsetProvider),
                                routineID: widget.routineId,
                                username: data.members[i].username,
                                memberId: data.members[i].id,
                                isTheMemberIsCaptain: data.members[i].captain,
                                isTheMemberIsOwner: data.members[i].owner,
                              );
                            },
                          ),
                    );
                  },
                  error:
                      (error, stackTrace) => Alert.handleError(context, error),
                  loading: () => Loaders.center(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
