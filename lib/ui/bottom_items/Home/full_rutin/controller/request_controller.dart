// ignore_for_file: camel_case_types, invalid_return_type_for_catch_error, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/models/messageModel.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/request/member_request.dart';
import 'package:table/widgets/Alart.dart';

import '../../home_screen/Home_screen.dart';

final joinReqControllerProviders =
    StateNotifierProvider.autoDispose<joinReqController, String?>((ref) {
  return joinReqController(ref.watch(memberRequestProvider));
});

class joinReqController extends StateNotifier<String?> {
  memberRequest rutinRequest;

  joinReqController(this.rutinRequest) : super(null);

//... remove member .....//
  void removeMember(BuildContext context, String rutinId, username) async {
    Future<Message> message = rutinRequest.removeMemberReq(rutinId, username);

    message.catchError((error) => Alart.handleError(context, error));
    message.then((valu) => Alart.showSnackBar(context, valu.message));

    print("from comtroller : $message");
  }
}
