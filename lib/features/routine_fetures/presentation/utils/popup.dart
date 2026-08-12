// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../providers/chack_status_controller.dart';
import '../providers/member_controller_provider.dart';

void accountActions(
  BuildContext context,
  WidgetRef ref, {
  required Offset? offset,
  required String routineID,
  required String username,
  required String memberId,
  required bool isTheMemberIsCaptain,
  required bool isTheMemberIsOwner,
}) async {
  final checkStatus = ref.watch(checkStatusControllerProvider(routineID));
  final bool isOwner = checkStatus.value?.isOwner ?? false;
  final bool isCaptain = checkStatus.value?.isCaptain ?? false;
  final membersCon = ref.watch(memberControllerProvider(routineID).notifier);

  List<PopupMenuItem<String>> items = [];

  if ((isCaptain || isOwner) && !isTheMemberIsOwner && !isTheMemberIsCaptain) {
    items.add(
      const PopupMenuItem<String>(
        value: 'Remove_Member',
        child: Text('Remove Member', style: TextStyle(color: Colors.red)),
      ),
    );
  }

  if ((isOwner || isCaptain) && !isTheMemberIsCaptain && !isTheMemberIsOwner) {
    items.add(
      const PopupMenuItem<String>(
        value: 'Make_Captain',
        child: Text('Make Captain', style: TextStyle(color: Colors.blue)),
      ),
    );
  } else if (isOwner && isTheMemberIsCaptain) {
    items.add(
      const PopupMenuItem<String>(
        value: 'Remove_Captaincy',
        child: Text('Remove captaincy', style: TextStyle(color: Colors.blue)),
      ),
    );
  }

  if (items.isEmpty) {
    Get.snackbar(
      'Sorry',
      'No Action here',
      // snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
    );
    // Alert.showSnackBar(context, 'No Action here');
    return;
  }
  final result = await showMenu(
    context: context,
    position: RelativeRect.fromLTRB(
      offset?.dx ?? 120,
      offset?.dy ?? 120,
      20,
      0,
    ),
    items: items,
    elevation: 8.0,
  );

  if (result != null) {
    // Step 6: Handled role updates (Make/Remove Captain) and kicking members using standard RESTful providers.
    if (result == 'Remove_Member') {
      membersCon.kickMember(context, memberId);
    } else if (result == 'Make_Captain') {
      membersCon.updateRole(context, memberId, true);
    } else if (result == 'Remove_Captaincy') {
      membersCon.updateRole(context, memberId, false);
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
