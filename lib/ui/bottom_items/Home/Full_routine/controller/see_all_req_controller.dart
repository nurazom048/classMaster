// ignore_for_file: prefer_typing_uninitialized_variables, invalid_return_type_for_catch_error, prefer_const_constructors, unused_element, unused_result

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/Full_routine/request/member_request.dart';
import '../../../../../core/dialogs/alert_dialogs.dart';
import '../../../../../models/see_all_request_model.dart';

//! Provider
final seeAllRequestControllerProvider = StateNotifierProvider.autoDispose
    .family<SeeAllRequestControllerClass, AsyncValue<SeeAllRequestModel>,
        String>((ref, classId) {
  return SeeAllRequestControllerClass(
      ref, classId, ref.read(memberRequestProvider));
});
//----------------------------------------------------------------//

class SeeAllRequestControllerClass
    extends StateNotifier<AsyncValue<SeeAllRequestModel>> {
  MemberRequest memberRequests;

  var ref;
  String routineId;
  SeeAllRequestControllerClass(this.ref, this.routineId, this.memberRequests)
      : super(AsyncLoading()) {
    getAllRequestList();
  }

  @override
  void dispose() {
    // Clean up any resources here
    super.dispose();
  }

  void getAllRequestList() async {
    if (!mounted) return;

    try {
      final res = await memberRequests.see_all_request(routineId);
      state = AsyncData(res);
    } catch (err, stack) {
      state = AsyncValue.error(err, stack);
    }
  }
//... Accept request.....//

  void acceptMember(WidgetRef ref, username, context, {bool? acceptAll}) async {
    final res =
        memberRequests.acceptRequest(routineId, username, acceptAll: acceptAll);

    res.catchError((error) => Alert.handleError(context, error));
    res.then((value) {
      ref.refresh(seeAllRequestControllerProvider(routineId));
      return Alert.showSnackBar(context, value.message);
    });
  }

//... rejectMembers request.....//
  void rejectMembers(WidgetRef ref, username, context) async {
    final res = memberRequests.rejectRequest(routineId, username);

    res.catchError((error) => Alert.handleError(context, error));
    res.then((value) {
      ref.refresh(seeAllRequestControllerProvider(routineId));
      return Alert.showSnackBar(context, value.message);
    });
  }
}
