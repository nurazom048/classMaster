// ignore_for_file: non_constant_identifier_names

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/models/membersModels.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/request/member_request.dart';
import 'package:table/widgets/Alart.dart';

final memberRequestController =
    Provider((ref) => MemberController(ref.read(memberRequestProvider)));

final all_members_provider =
    FutureProvider.family.autoDispose<MembersModel?, String>((ref, rutin_id) {
  return ref.read(memberRequestProvider).all_members(rutin_id);
});

class MemberController {
  memberRequest member_request;

  MemberController(this.member_request);

  //******** addMember   ************** */
  void addMember(rutinid, username, context) async {
    final message = await member_request.addMemberReq(rutinid, username);
    print("from comtroller : $message");

    Alart.showSnackBar(context, message);
  }

  //******** remove member   ************** */
  void removeMember(rutinid, username, context) async {
    final message = await member_request.removeMemberReq(rutinid, username);
    print("from comtroller : $message");

    Alart.showSnackBar(context, message);
  }
}
