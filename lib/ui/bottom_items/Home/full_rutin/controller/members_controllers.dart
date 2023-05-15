// ignore_for_file: non_constant_identifier_names, invalid_return_type_for_catch_error

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/core/dialogs/alart_dialogs.dart';
import 'package:table/models/members_models.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/request/member_request.dart';
import '../../../../../models/message_model.dart';

//! ** Providers ****/
final memberControllerProvider =
    StateNotifierProvider.family<MemberController, bool, String>(
        (ref, rutinId) =>
            MemberController(ref.read(memberRequestProvider), rutinId));

final all_members_provider =
    FutureProvider.family.autoDispose<MembersModel?, String>((ref, rutin_id) {
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

    Alart.showSnackBar(context, message);
  }

  void removeCapten(rutinId, username, context) async {
    final message = await memberRequests.removeCaptensReq(rutinId, username);

    Alart.showSnackBar(context, message);
  }

//...  select and remove member .....//
  void removeMembers(BuildContext context, username) async {
    Future<Message> message = memberRequests.removeMemberReq(rutinId, username);

    message.catchError((error) => Alart.handleError(context, error));
    message.then((valu) => Alart.showSnackBar(context, valu.message));
  }

  //******** addMember   ************** */
  void addMember(username, context) async {
    final message = await memberRequests.addMemberReq(rutinId, username);

    Alart.showSnackBar(context, message);
  }

  //******** remove member   ************** */
  void removeMember(username, context) async {
    final message = await memberRequests.removeMemberReq(rutinId, username);

    Alart.showSnackBar(context, message);
  }
}
