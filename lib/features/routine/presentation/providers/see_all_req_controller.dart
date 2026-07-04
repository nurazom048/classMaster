// ignore_for_file: prefer_typing_uninitialized_variables, invalid_return_type_for_catch_error, prefer_const_constructors, unused_element, unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/export_core.dart';
import '../../data/datasources/routine_member_req.dart';
import '../../data/implements/member_imp.dart';
import '../../data/models/see_all_request_model.dart';
import 'member_controller_provider.dart';

// Step 5: Created seeAllRequestControllerProvider using MemberRepositoryImp.getAllRequests and handleRequestStatus.
final seeAllRequestControllerProvider = StateNotifierProvider.autoDispose
    .family<
      SeeAllRequestControllerClass,
      AsyncValue<SeeAllRequestModel>,
      String
    >((ref, routineId) {
      return SeeAllRequestControllerClass(
        ref,
        routineId,
        ref.read(routineMemberReqProvider),
      );
    });

class SeeAllRequestControllerClass
    extends StateNotifier<AsyncValue<SeeAllRequestModel>> {
  final MemberRepositoryImp memberRequests;
  final Ref ref;
  final String routineId;

  SeeAllRequestControllerClass(this.ref, this.routineId, this.memberRequests)
    : super(AsyncLoading()) {
    getAllRequestList();
  }

  void getAllRequestList() async {
    if (!mounted) return;

    try {
      final res = await memberRequests.getAllRequests(routineId);
      state = AsyncData(res);
    } catch (err, stack) {
      state = AsyncValue.error(err, stack);
    }
  }

  void acceptMember(WidgetRef ref, String? requestId, BuildContext context, {bool? acceptAll}) async {
    try {
      final value = await memberRequests.handleRequestStatus(
        routineId,
        requestId: requestId,
        status: 'ACCEPTED',
        acceptAll: acceptAll,
      );

      ref.refresh(seeAllRequestControllerProvider(routineId));
      ref.refresh(memberControllerProvider(routineId)); // Refresh member list to show newly accepted members
      
      if (context.mounted) {
        Alert.showSnackBar(context, value.message);
      }
    } catch (error) {
      if (context.mounted) {
        Alert.handleError(context, error);
      }
    }
  }

  void rejectMembers(WidgetRef ref, String requestId, BuildContext context) async {
    try {
      final value = await memberRequests.handleRequestStatus(
        routineId,
        requestId: requestId,
        status: 'REJECTED',
      );

      ref.refresh(seeAllRequestControllerProvider(routineId));
      
      if (context.mounted) {
        Alert.showSnackBar(context, value.message);
      }
    } catch (error) {
      if (context.mounted) {
        Alert.handleError(context, error);
      }
    }
  }
}
