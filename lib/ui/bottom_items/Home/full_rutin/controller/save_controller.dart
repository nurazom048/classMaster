// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/request/save_request.dart';
import 'package:table/widgets/Alart.dart';

// providers
final saveRutinController_Provider =
    StateNotifierProvider.autoDispose<SaveUnsaveController, bool?>(
        (ref) => SaveUnsaveController(ref.watch(saveReqProvider)));

//
//
// Define a class for SaveUnsaveController
class SaveUnsaveController extends StateNotifier<bool?> {
  SaveUnsaveRequest saveUnsaveRequest;

  SaveUnsaveController(this.saveUnsaveRequest) : super(null);

  // Define a method for saving or unsaving a rutin
  void saveUnsave(BuildContext context, String rutinId, bool? condition) async {
    // Determine the current save condition
    condition = condition != null ? !condition : false;
    final result =
        await saveUnsaveRequest.saveUnsaveRutinReq(rutinId, condition);

    // Handle the result of the save or unsave request
    result.fold(
      (errorMessage) => Alart.errorAlartDilog(context, errorMessage),
      (response) {
        state = response.save;

        Alart.showSnackBar(context, response.message);
      },
    );
  }
}
