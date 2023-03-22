// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/request/svae_unsave.dart';
import 'package:table/widgets/Alart.dart';

// final saveNotifierConroller =
//     StateNotifierProvider((ref) => ref.watch(svae_unsave_Controller_Provider));

final svae_unsave_Controller_Provider =
    StateNotifierProvider.autoDispose<svae_unsave_Controller_class, bool?>(
        (ref) {
  return svae_unsave_Controller_class(ref.watch(saveUnsaveProvider));
});

//
class svae_unsave_Controller_class extends StateNotifier<bool?> {
  saveUnsave save_unsave_request;

  svae_unsave_Controller_class(this.save_unsave_request) : super(null);

//
  void save_unsaves(WidgetRef ref, context, rutinId, condition) async {
    final s = await save_unsave_request.saveUnsaveRutinReq(rutinId, condition);
    s.fold((l) {
      // Navigator.pop(context);
      Alart.errorAlartDilog(context, l);
    }, (r) {
      state = r.save;
      // Navigator.pop(context);
      Alart.showSnackBar(context, r.message);
    });
  }
}
///
// final authController_provider = StateNotifierProvider.autoDispose(
//     (ref) => AuthController(ref.watch(auth_req_provider)));

// class AuthController extends StateNotifier<bool> {
//   final AuthReq authReqq;
//   AuthController(this.authReqq) : super(false);

//   //
// //******** siginIn      ************ */
//   void siginIn(username, password, context) async {
//     state = true;
//     final res = await authReqq.login(username: username, password: password);

//     res.fold(
//       (l) {
//         state = false;
//         return Alart.errorAlartDilog(context, l);
//       },
//       (r) {
//         state = false;
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => const BottomNevBar()));
//         Alart.showSnackBar(context, r);
//       },
//     );
//   }
// }
