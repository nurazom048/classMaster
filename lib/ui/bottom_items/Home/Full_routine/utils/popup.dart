// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../controller/check_status_controller.dart';
import '../controller/members_controllers.dart';

void accountActions(
  BuildContext context,
  WidgetRef ref, {
  required Offset? offset,
  required String rutinId,
  required String username,
  required String memberId,
  required bool isTheMemberIsCaptain,
  required bool isTheMemberIsOwner,
}) async {
  final checkStatus = ref.watch(checkStatusControllerProvider(rutinId));
  final bool isOwner = checkStatus.value?.isOwner ?? false;
  final bool isCaptain = checkStatus.value?.isCaptain ?? false;
  final membersCon = ref.watch(memberControllerProvider(rutinId).notifier);

  List<PopupMenuItem<String>> items = [];

  if ((isCaptain || isOwner) && !isTheMemberIsOwner && !isTheMemberIsCaptain) {
    items.add(
      const PopupMenuItem<String>(
        value: 'kickOut',
        child: Text('kickOut', style: TextStyle(color: Colors.red)),
      ),
    );
  }

  if ((isOwner || isCaptain) && !isTheMemberIsCaptain && !isTheMemberIsOwner) {
    items.add(
      const PopupMenuItem<String>(
        value: 'make_captains',
        child: Text(
          'Make Captains',
          style: TextStyle(color: Colors.blue),
        ),
      ),
    );
  } else if (isOwner && isTheMemberIsCaptain) {
    items.add(
      const PopupMenuItem<String>(
        value: 'remove_captains',
        child: Text(
          'Remove Captains',
          style: TextStyle(color: Colors.blue),
        ),
      ),
    );
  }

  if (items.isEmpty) {
    Get.snackbar('Sorry', 'No Action here',
        // snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10));
    // Alert.showSnackBar(context, 'No Action here');
    return;
  }
  final result = await showMenu(
    context: context,
    position:
        RelativeRect.fromLTRB(offset?.dx ?? 120, offset?.dy ?? 120, 20, 0),
    items: items,
    elevation: 8.0,
  );

  if (result != null) {
    // Handle selected menu item
    if (result == 'kickOut') {
      membersCon.kickedOutMember(memberId, context);
    } else if (result == 'make_captains') {
      membersCon.AddCaptans(rutinId, username, context);
    } else if (result == 'remove_captains') {
      membersCon.removeCaptans(rutinId, username, context);
    }
  }
}

// end maker "z"
String endMaker(String test) {
  test = test.trim();

  // Check if the string ends with 'Z'
  if (test.endsWith('Z')) {
    return test;
  } else {
    // Append 'Z' to the string if it does not end with 'Z'
    return '${test}Z';
  }
}
