// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/models/membersModels.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/controller/Rutin_controller.dart';
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
    print("from comtroller : $message");

    Alart.showSnackBar(context, message);
  }

  //******** acceptMember   ************** */
  void acceptMember(WidgetRef ref, rutinId, username, context) async {
    final message = ref.read(
        accept_request_provider(accept(rutin_id: rutinId, usernme: username)));

    ref.watch(see_all_request_provider(rutinId));

    print("from comtroller : ${message}");

    Alart.showSnackBar(context, message);
  }

  //******** sendReq   ************** */
  void sendReqController(rutinId, context, WidgetRef ref) async {
    final r = ref.read(sendRequestProviser(rutinId));
    r.when(
        data: (d) {
          var message = Message.fromJson(d);
          Alart.errorAlartDilog(context, message.message);
        },
        error: (error, stackTrace) => Alart.handleError(context, error),
        loading: () {});
  }

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
}

class Message {
  String message;

  Message({required this.message});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
      };
}
