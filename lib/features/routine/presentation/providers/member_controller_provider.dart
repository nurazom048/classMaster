// ignore_for_file: non_constant_identifier_names, invalid_return_type_for_catch_error

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/export_core.dart';
import '../../data/datasources/routine_member_req.dart';
import '../../data/implements/member_imp.dart';
import '../../data/models/members_models.dart';

// Step 5: Defined Riverpod providers for routine members to call new repository methods.
final memberControllerProvider = StateNotifierProvider.family<
  MemberController,
  AsyncValue<RoutineMembersModel>,
  String
>(
  (ref, routineId) => MemberController(ref.read(routineMemberReqProvider), routineId),
);

final allMembersProvider = FutureProvider.family<RoutineMembersModel, String>((ref, routineId) {
  return ref.watch(routineMemberReqProvider).getAllMembers(routineId).then((val) => val!);
});

class MemberController extends StateNotifier<AsyncValue<RoutineMembersModel>> {
  final MemberRepositoryImp memberRequests;
  final String routineId;

  MemberController(this.memberRequests, this.routineId)
    : super(const AsyncLoading()) {
    getStatus();
  }

  getStatus() async {
    try {
      final RoutineMembersModel? res = await memberRequests.getAllMembers(routineId);
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

  void loadMore(int page) async {
    try {
      if (state.value == null) return;
      
      // Stop if we have reached the last page
      if (page >= state.value!.totalPages) {
        if (kDebugMode) print('All pages loaded');
        return;
      }

      if (kDebugMode) {
        print('call for load more ${page + 1} of ${state.value!.totalPages}');
      }

      final newData = await memberRequests.getAllMembers(routineId, page: page + 1);

      if (newData != null && newData.currentPage > state.value!.currentPage) {
        List<Member> members = List.from(state.value!.members)..addAll(newData.members);
        state = AsyncData(
          state.value!.copyWith(
            members: members,
            currentPage: newData.currentPage,
          ),
        );
      }
    } catch (error, stackTrace) {
      // Don't overwrite the whole state with an error if pagination fails, just log it
      if (kDebugMode) print('Pagination error: $error');
    }
  }

  // 🆕 Replaces AddCaptans and removeCaptans
  void updateRole(BuildContext context, String accountId, bool isCaptain) async {
    try {
      final message = await memberRequests.updateMemberRole(routineId, accountId, isCaptain: isCaptain);
      if (mounted) {
        Alert.showSnackBar(context, message.message);
        getStatus(); // Refresh the list to show the new role
      }
    } catch (error) {
      if (mounted) {
        Alert.handleError(context, error);
      }
    }
  }

  // 🆕 Replaces addMember (Direct Admin Add)
  void addMemberDirectly(BuildContext context, String targetAccountId) async {
    final result = await memberRequests.sendMemberRequest(routineId, targetAccountId: targetAccountId);
    
    result.fold(
      (errorMessage) => Alert.errorAlertDialog(context, errorMessage),
      (response) {
        Alert.showSnackBar(context, response.message);
        getStatus(); // Refresh list to show new member
      }
    );
  }

  // 🆕 Replaces removeMember and remove_member (Admin Kicking someone)
  void kickMember(BuildContext context, String accountId) async {
    final result = await memberRequests.removeMember(routineId, accountId);
    
    result.fold(
      (errorMsg) => Alert.errorAlertDialog(context, errorMsg.message),
      (response) {
        Alert.showSnackBar(context, response.message);
        getStatus(); // Refresh list to remove kicked member
      }
    );
  }
}