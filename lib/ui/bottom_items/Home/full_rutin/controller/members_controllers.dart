// ignore_for_file: non_constant_identifier_names, invalid_return_type_for_catch_error

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/models/membersModels.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/request/member_request.dart';
import 'package:table/widgets/Alart.dart';

//** Providers ****/
final memberRequestController = StateNotifierProvider(
    (ref) => MemberController(ref.read(memberRequestProvider)));

final all_members_provider =
    FutureProvider.family.autoDispose<MembersModel?, String>((ref, rutin_id) {
  return ref.watch(memberRequestProvider).all_members(rutin_id);
});

//** MemberController ****/
class MemberController extends StateNotifier {
  memberRequest member_request;

  MemberController(this.member_request) : super(null);

  //******** addMember   ************** */
  void addMember(rutinid, username, context) async {
    final message = await member_request.addMemberReq(rutinid, username);

    Alart.showSnackBar(context, message);
  }

  //******** remove member   ************** */
  void removeMember(rutinid, username, context) async {
    final message = await member_request.removeMemberReq(rutinid, username);

    Alart.showSnackBar(context, message);
  }

  //******** AddCapten   ************** */
  void AddCapten(rutinid, position, username, context) async {
    final message =
        await member_request.addCaptensReq(rutinid, position, username);
    //  print("from comtroller : $message");

    Alart.showSnackBar(context, message);
  }

  //******** acceptMember   ************** */
  void acceptMember(rutinId, username, context) async {
    final res = member_request.acceptRequest(rutinId, username);

    res.catchError((error) => Alart.handleError(context, error));
    res.then((value) => Alart.showSnackBar(context, value.message));
  }

  //******** acceptMember   ************** */
  void rejectMembers(rutinId, username, context) async {
    final res = member_request.rejectRequest(rutinId, username);

    res.catchError((error) => Alart.handleError(context, error));
    res.then((value) => Alart.showSnackBar(context, value.message));
  }
}
