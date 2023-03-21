// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/request/svae_unsave.dart';
import 'package:table/widgets/Alart.dart';

final svae_unsave_Controller_Provider =
    Provider<svae_unsave_Controller_class>((ref) {
  return svae_unsave_Controller_class(ref.read(saveUnsaveProvider));
});

//
class svae_unsave_Controller_class {
  saveUnsave save_unsave_request;

  svae_unsave_Controller_class(this.save_unsave_request);

//
  void save_unsaves(WidgetRef ref, context, rutinId, condition) async {
    final s = await save_unsave_request.saveUnsaveRutinReq(rutinId, condition);
    s.fold((l) {
      Navigator.pop(context);
      Alart.errorAlartDilog(context, l);
    }, (r) {
      Navigator.pop(context);
      Alart.showSnackBar(context, r.message);
    });
  }

  // ref.watch(chackStatusUser_provider(rutinId)).whenData((status) {
  //       ref.read(isSaveBoolProvider.notifier).update((state) => r.save!);
  //       // Do something with the status, e.g. update UI
  //       print("Rutin status changed: $status");
  //     });
}
