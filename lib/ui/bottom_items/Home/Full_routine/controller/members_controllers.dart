// ignore_for_file: non_constant_identifier_names, invalid_return_type_for_catch_error

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/core/dialogs/alert_dialogs.dart';
import 'package:table/ui/bottom_items/Home/Full_routine/request/member_request.dart';
import '../models/members_models.dart';
import '../../../../../models/message_model.dart';

//! ** Providers ****/
final memberControllerProvider =
    StateNotifierProvider.family<MemberController, bool, String>(
        (ref, rutinId) =>
            MemberController(ref.read(memberRequestProvider), rutinId));

final all_members_provider = FutureProvider.autoDispose
    .family<RutineMembersModel?, String>((ref, rutin_id) {
  return ref.watch(memberRequestProvider).all_members(rutin_id);
});

//** MemberController ****/
class MemberController extends StateNotifier<bool> {
  memberRequest memberRequests;
  String rutinId;

  MemberController(this.memberRequests, this.rutinId) : super(false);

  //******** AddCapten   ************** */
  void AddCapten(rutinId, username, context) async {
    final message = await memberRequests.addCaptensReq(rutinId, username);
    //  print("from comtroller : $message");

    Alert.showSnackBar(context, message);
  }

  void removeCapten(rutinId, username, context) async {
    final message = await memberRequests.removeCaptensReq(rutinId, username);

    Alert.showSnackBar(context, message);
  }

//...  select and remove member .....//
  void removeMembers(BuildContext context, username) async {
    Future<Message> message = memberRequests.removeMemberReq(rutinId, username);

    message.catchError((error) => Alert.handleError(context, error));
    message.then((valu) => Alert.showSnackBar(context, valu.message));
  }

  //******** addMember   ************** */
  void addMember(username, context) async {
    final message = await memberRequests.addMemberReq(rutinId, username);

    Alert.showSnackBar(context, message);
  }

  //******** remove member   ************** */
  void removeMember(username, context) async {
    final message = await memberRequests.removeMemberReq(rutinId, username);

    Alert.showSnackBar(context, message);
  }

  //******** kickedout member   ************** */
  void kickeOutMember(memberid, context) async {
    final message = await memberRequests.kickOut(rutinId, memberid);

    Alert.showSnackBar(context, message.message);
  }
}
