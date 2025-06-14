// ignore_for_file: non_constant_identifier_names, invalid_return_type_for_catch_error

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/export_core.dart';
import '../../data/datasources/member_request.dart';
import '../../data/models/members_models.dart';

//! ** Providers ****/
final memberControllerProvider = StateNotifierProvider.family<
  MemberController,
  AsyncValue<RoutineMembersModel>,
  String
>(
  (ref, routineId) =>
      MemberController(ref.read(memberRequestProvider), routineId),
);

// final all_members_provider = FutureProvider.autoDispose
//     .family<RoutineMembersModel?, String>((ref, routineId) {
//   return ref.watch(memberRequestProvider).all_members(routineId);
// });

//** MemberController ****/
class MemberController extends StateNotifier<AsyncValue<RoutineMembersModel>> {
  final MemberRequest memberRequests;
  final String routineId;

  MemberController(this.memberRequests, this.routineId)
    : super(const AsyncLoading()) {
    getStatus();
  }
  getStatus() async {
    try {
      final RoutineMembersModel? res = await memberRequests.all_members(
        routineId,
      );

      if (res == null) {}

      if (!mounted) return;
      state = AsyncData(res!);
    } catch (error, stackTrace) {
      if (!mounted) return;
      if (kDebugMode) {
        print(error.toString());
      }
      state = AsyncValue.error(error, stackTrace);
    }
  }

  //
  //Loader More
  void loadMore(page) async {
    try {
      if (page == state.value!.members) {
      } else {
        if (kDebugMode) {
          print('call fore loader more $page ${state.value!.totalPages}');
        }

        final newData = await memberRequests.all_members(routineId);

        // Check if the new data's page number is greater than the current page number
        if (newData!.currentPage > state.value!.currentPage) {
          int? totalPages = newData.totalPages;
          if (newData.currentPage <= totalPages) {
            // Add new routines to the existing list and update the page number
            List<Member> members =
                state.value!.members..addAll(newData.members);
            state = AsyncData(
              state.value!.copyWith(
                members: members,
                currentPage: newData.currentPage,
              ),
            );
          }
        }
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  //******** Add Captans   ************** */
  void AddCaptans(routineId, username, context) async {
    final String message = await memberRequests.addCaptressReq(
      routineId,
      username,
    );
    //  print("from comptroller : $message");

    Alert.showSnackBar(context, message);
  }

  void removeCaptans(routineId, username, context) async {
    final message = await memberRequests.removeCaptansReq(routineId, username);

    Alert.showSnackBar(context, message as String);
  }

  //...  select and remove member .....//
  void removeMembers(BuildContext context, String username) async {
    try {
      final message = await memberRequests.removeMemberReq(routineId, username);
      if (context.mounted) {
        Alert.showSnackBar(context, message.message);
      }
    } catch (error) {
      if (context.mounted) {
        Alert.handleError(context, error);
      }
    }
  }

  //******** addMember   ************** */
  void addMember(username, context) async {
    final message = await memberRequests.addMemberReq(routineId, username);

    Alert.showSnackBar(context, message as String);
  }

  //******** remove member   ************** */
  void removeMember(username, context) async {
    final message = await memberRequests.removeMemberReq(routineId, username);

    Alert.showSnackBar(context, message as String);
  }

  //******** remove_member   ************** */
  void remove_member(memberId, context) async {
    final message = await memberRequests.remove_member(routineId, memberId);

    Alert.showSnackBar(context, message.message);
  }
}
