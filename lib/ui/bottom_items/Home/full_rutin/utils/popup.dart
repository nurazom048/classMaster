// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../controller/chack_status_controller.dart';
import '../controller/members_controllers.dart';

void accountActions(
  BuildContext context,
  WidgetRef ref, {
  required String rutinId,
  required String username,
  required String memberId,
  required bool isTheMemberIsCaptain,
  required bool isTheMemberIsOwner,
}) async {
  final chackStatus = ref.watch(chackStatusControllerProvider(rutinId));
  final bool isOwner = chackStatus.value?.isOwner ?? false;
  final bool isCaptain = chackStatus.value?.isCaptain ?? false;
  final membersCon = ref.watch(memberControllerProvider(rutinId).notifier);

  List<PopupMenuItem<String>> items = [];

  if ((isCaptain || isOwner) && !isTheMemberIsOwner && !isTheMemberIsCaptain) {
    items.add(
      const PopupMenuItem<String>(
        value: 'kickout',
        child: Text('Kickout', style: TextStyle(color: Colors.red)),
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
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10));
    // Alart.showSnackBar(context, 'No Action here');
    return;
  }

  final result = await showMenu(
    context: context,
    position: const RelativeRect.fromLTRB(120, 535, 0, 0),
    items: items,
    elevation: 8.0,
  );

  if (result != null) {
    // Handle selected menu item
    if (result == 'kickout') {
      membersCon.kickeOutMember(memberId, context);
    } else if (result == 'make_captains') {
      membersCon.AddCapten(rutinId, username, context);
    } else if (result == 'remove_captains') {
      membersCon.removeCapten(rutinId, username, context);
    }
  }
}
