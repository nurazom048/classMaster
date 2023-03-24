// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/models/chackStatusModel.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/controller/Rutin_controller.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/request/Rutin_request/rutin_request.dart';

import '../../../../../widgets/Alart.dart';

//
final chackStatusProvider = StateNotifierProvider.autoDispose
    .family<ChackStatusController, AsyncValue<CheckStatusModel>, String>(
        (ref, rutinId) {
  return ChackStatusController(ref, rutinId, ref.read(FullRutinProvider));
});

//

class ChackStatusController
    extends StateNotifier<AsyncValue<CheckStatusModel>> {
  var ref;
  String rutinId;
  FullRutinrequest fullRutinReq;
  ChackStatusController(this.ref, this.rutinId, this.fullRutinReq)
      : super(AsyncLoading()) {
    getStatus();
  }

// ! gets status....//
  getStatus() async {
    try {
      AsyncValue<CheckStatusModel> res =
          await ref.watch(chackStatusUser_provider(rutinId));

      res.whenData((value) {
        print("vai ami controller ${value}");
      });

      state = res;
    } catch (e) {
      state = throw Exception(e);
    }
  }

  //

  // Define a method for saving or unsaving a rutin
  void saveUnsave(BuildContext context, condition) async {
    final result = await fullRutinReq.saveUnsaveRutinReq(rutinId, condition);
    print("c $rutinId $condition");

    // Handle the result of the save or unsave request
    result.fold(
      (errorMessage) => Alart.errorAlartDilog(context, errorMessage),
      (response) {
        state = AsyncData(state.value!.copyWith(isSave: response.save));

        Alart.showSnackBar(context, response.message);
      },
    );
  }
}
