// ignore_for_file: camel_case_types, invalid_return_type_for_catch_error, avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/models/messageModel.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/request/member_request.dart';
import 'package:table/widgets/Alart.dart';

import '../../home_screen/Home_screen.dart';

final joinReqControllerProviders =
    StateNotifierProvider.autoDispose<joinReqController, String?>((ref) {
  return joinReqController(ref.watch(memberRequestProvider.notifier));
});

class joinReqController extends StateNotifier<String?> {
  memberRequest rutinRequest;

  joinReqController(this.rutinRequest) : super(null);

//......

  void sendReqController(rutinId, context, WidgetRef ref) async {
    final result = await rutinRequest.sendRequest(rutinId);

    result.fold(
      (errorMessage) => Alart.errorAlartDilog(context, errorMessage),
      (response) {
        state = response.activeStatus;

        Alart.showSnackBar(context, response.message);
      },
    );
  }

//
//***********  leaveMember *********** */
  leaveMember(WidgetRef ref, rutinId, context) async {
    final message = ref.watch(lavePr(rutinId));
    state = "not_joined";

    message.when(
      data: (data) {
        state = "not_joined";
        print("Hello from Controller");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));

        Alart.showSnackBar(context, data!.message);
      },
      error: (error, stackTrace) => Alart.handleError(context, error),
      loading: () {},
    );
  }

//... remove member .....//
  void removeMember(BuildContext context, String rutinId, username) async {
    Future<Message> message = rutinRequest.removeMemberReq(rutinId, username);

    message.catchError((error) => Alart.handleError(context, error));
    message.then((valu) => Alart.showSnackBar(context, valu.message));

    print("from comtroller : $message");
  }
}
