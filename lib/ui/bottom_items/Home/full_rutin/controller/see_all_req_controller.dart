// ignore_for_file: prefer_typing_uninitialized_variables, invalid_return_type_for_catch_error, prefer_const_constructors, unused_element, unused_result

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/request/member_request.dart';
import '../../../../../core/dialogs/Alart_dialogs.dart';
import '../../../../../models/seeAllRequestModel.dart';

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
  memberRequest memberRequests;

  var ref;
  String rutinId;
  SeeAllRequestControllerClass(this.ref, this.rutinId, this.memberRequests)
      : super(AsyncLoading()) {
    getAllRequestList();
  }

  void dispose() {
    // Clean up any resources here
    super.dispose();
  }

  void getAllRequestList() async {
    try {
      final res = await memberRequests.sell_all_request(rutinId);

      if (mounted) {
        state = AsyncData(res);
      }
    } catch (e) {
      if (mounted) {
        state = throw Exception(e);
      }
    }
  }
//... Accept request.....//

  void acceptMember(WidgetRef ref, username, context) async {
    final res = memberRequests.acceptRequest(rutinId, username);

    res.catchError((error) => Alart.handleError(context, error));
    res.then((value) {
      ref.refresh(seeAllRequestControllerProvider(rutinId));
      return Alart.showSnackBar(context, value.message);
    });
  }

//... rejectMembers request.....//
  void rejectMembers(WidgetRef ref, username, context) async {
    final res = memberRequests.rejectRequest(rutinId, username);

    res.catchError((error) => Alart.handleError(context, error));
    res.then((value) {
      ref.refresh(seeAllRequestControllerProvider(rutinId));
      return Alart.showSnackBar(context, value.message);
    });
  }
}
