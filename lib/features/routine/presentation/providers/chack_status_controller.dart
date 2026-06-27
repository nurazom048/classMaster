// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_constructors, avoid_print, unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/export_core.dart';
import '../../data/datasources/routine_req.dart';
import '../../data/datasources/routine_member_req.dart';
import '../../data/implements/routine_imp.dart';
import '../../data/implements/member_imp.dart';
import '../../data/models/check_status_model.dart';
import '../../../account_fetures/domain/providers/account_providers.dart';
import 'routine_list_provider.dart';

final checkStatusControllerProvider = StateNotifierProvider.autoDispose
    .family<CheckStatusController, AsyncValue<CheckStatusModel>, String>((
      ref,
      routineId,
    ) {
      return CheckStatusController(
        ref,
        routineId,
        ref.read(routineReqProvider),
        ref.read(routineMemberReqProvider),
      );
    });

class CheckStatusController
    extends StateNotifier<AsyncValue<CheckStatusModel>> {
  final Ref ref;
  final String routineId;
  final RoutineRepositoryImp routineRepository;
  final MemberRepositoryImp memberRequests;

  CheckStatusController(
    this.ref,
    this.routineId,
    this.routineRepository,
    this.memberRequests,
  ) : super(AsyncLoading()) {
    getStatus();
  }

  getStatus() async {
    try {
      final CheckStatusModel res = await routineRepository.getCurrentUserStatus(
        routineId,
      );

      if (!mounted) return;
      state = AsyncData(res);
    } catch (error, stackTrace) {
      if (!mounted) return;
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void saveUnsaved(BuildContext context, condition) async {
    final result = await routineRepository.saveAndUnsaveRoutine(
      routineId,
      condition,
    );

    result.fold(
      (errorMessage) => Alert.errorAlertDialog(context, errorMessage),
      (response) {
        state = AsyncData(state.value!.copyWith(isSave: response.save));
        ref.refresh(routineListProvider(const RoutineListQuery(type: 'saved')));
        Alert.showSnackBar(context, response.message);
      },
    );
  }

  // Step 5: Refactored Riverpod providers/controllers for routine members to call sendMemberRequest.
  void sendReqController(BuildContext context, {String? requestMessage}) async {
    final result = await memberRequests.sendMemberRequest(routineId, requestMessage: requestMessage);

    result.fold(
      (errorMessage) => Alert.errorAlertDialog(context, errorMessage),
      (response) {
        state = AsyncData(
          state.value!.copyWith(activeStatus: response.activeStatus),
        );
        Alert.showSnackBar(context, response.message);
      },
    );
  }

  void notificationOff(context) async {
    final result = await routineRepository.classNotification(
      routineID: routineId,
      status: false,
    );

    result.fold(
      (errorMessage) => Alert.errorAlertDialog(context, errorMessage),
      (response) {
        state = AsyncData(
          state.value!.copyWith(notificationOn: response.notificationOn),
        );
        Alert.showSnackBar(context, response.message);
      },
    );
  }

  void notificationOn(context) async {
    final result = await routineRepository.classNotification(
      routineID: routineId,
      status: true,
    );

    result.fold(
      (errorMessage) => Alert.errorAlertDialog(context, errorMessage),
      (response) {
        state = AsyncData(
          state.value!.copyWith(notificationOn: response.notificationOn),
        );
        Alert.showSnackBar(context, response.message);
      },
    );
  }

  // Step 5: Refactored Riverpod providers/controllers for routine members to call removeMember for leaving.
  leaveMember(BuildContext context, WidgetRef ref) async {
    try {
      final accountDataEither = ref.read(accountDataProvider(null));
      final accountId = accountDataEither.asData?.value.fold(
        (error) => null,
        (account) => account.id,
      );

      if (accountId == null) {
        Alert.errorAlertDialog(context, "Could not identify your account. Please reload.");
        return;
      }

      final res = await memberRequests.removeMember(routineId, accountId);

      res.fold(
        (error) {
          return Alert.errorAlertDialog(context, error.message);
        },
        (data) {
          state = AsyncData(state.value!.copyWith(activeStatus: "not_joined"));
          return Alert.showSnackBar(context, data.message);
        },
      );
    } catch (e) {
      Alert.handleError(context, e);
    }
  }
}
