// ignore_for_file: camel_case_types, invalid_return_type_for_catch_error

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/models/messageModel.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/request/member_request.dart';
import 'package:table/widgets/Alart.dart';

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

  void leaveMember(WidgetRef ref, rutinId, context) async {
    final message = ref.watch(lavePr(rutinId));
    state = "not_joined";
    var m;
    message.when(
      data: (data) {
        //  Navigator.pop(context);
        m = data;
        state = "not_joined";
        print("Hello from Controller");
        Alart.showSnackBar(context, data!.message);
      },
      error: (error, stackTrace) {
        // Navigator.pop(context);
        return Alart.handleError(context, error);
      },
      loading: () {},
    );

    print("from comtroller : ${m}");
  }

//... remove member .....//
  void removeMember(BuildContext context, String rutinId, username) async {
    Future<Message> message = rutinRequest.removeMemberReq(rutinId, username);

    message.catchError((error) => Alart.handleError(context, error));
    message.then((valu) => Alart.showSnackBar(context, valu.message));

    print("from comtroller : $message");
  }
}
