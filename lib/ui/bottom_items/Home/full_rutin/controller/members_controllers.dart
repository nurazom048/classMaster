// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/models/membersModels.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/controller/Rutin_controller.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/request/member_request.dart';
import 'package:table/widgets/Alart.dart';

final memberRequestController = StateNotifierProvider(
    (ref) => MemberController(ref.read(memberRequestProvider.notifier)));

final all_members_provider =
    FutureProvider.family.autoDispose<MembersModel?, String>((ref, rutin_id) {
  return ref.read(memberRequestProvider.notifier).all_members(rutin_id);
});

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
  void acceptMember(WidgetRef ref, rutinId, username, context) async {
    final message = ref.read(
        accept_request_provider(accept(rutin_id: rutinId, usernme: username)));

    //("from comtroller : ${message}");

    message.hasError
        ? Alart.showSnackBar(context, message.hasError)
        : Alart.showSnackBar(context, message);
  }

  //******** sendReq   ************** */
  // void sendReqController(rutinId, context, WidgetRef ref) async {
  //   final r = ;
  //   r.when(
  //     data: (d) {
  //       if (d == null) Alart.errorAlartDilog(context, "");
  //       Navigator.pop(context);
  //       Alart.errorAlartDilog(context, d?.message);
  //     },
  //     error: (error, stackTrace) {
  //       Navigator.pop(context);
  //       return Alart.errorAlartDilog(context, error.toString());
  //     },
  //     loading: () {},
  //   );
  // }

  //******** acceptMember   ************** */
  void rejectMembers(WidgetRef ref, rutinId, username, context) async {
    final message = ref.read(
        reject_request_provider(accept(rutin_id: rutinId, usernme: username)));

    message.when(
      data: (data) {
        print("via daa $data");
        Alart.errorAlartDilog(context, data["message"]);
      },
      error: (error, stackTrace) => Alart.handleError(context, error),
      loading: () {},
    );

    print("from comtroller : ${message}");
  }

  //*******Leave Member   ************** */
  void leaveMember(WidgetRef ref, rutinId, context) async {
    final message = ref.watch(lavePr(rutinId));

    message.when(
      data: (data) {
        Navigator.pop(context);
        Alart.showSnackBar(context, data!.message);
      },
      error: (error, stackTrace) {
        Navigator.pop(context);
        return Alart.handleError(context, error);
      },
      loading: () {},
    );

    print("from comtroller : ${message.asData}");
  }
}
