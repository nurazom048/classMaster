import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/chack_status_controller.dart';
import '../controller/members_controllers.dart';

void accountActions(BuildContext context, WidgetRef ref,
    {required String rutinId, required String username}) async {
  //! provider
  final chackStatus = ref.watch(chackStatusControllerProvider(rutinId));
  final bool isOwner = chackStatus.value?.isOwner ?? false;
  final bool isCaptain = chackStatus.value?.isCaptain ?? false;

  final result = await showMenu(
    context: context,
    position: const RelativeRect.fromLTRB(120, 535, 0, 0),
    items: [
      if (isOwner == true)
        const PopupMenuItem(
          value: 'kickout',
          child: Text('Kickout', style: TextStyle(color: Colors.red)),
        ),
      if (isOwner == true || isCaptain == true)
        const PopupMenuItem(
          value: 'make_captains',
          child: Text('Make Captains', style: TextStyle(color: Colors.blue)),
        ),
    ],
    elevation: 8.0,
  );

  if (result != null) {
    // Handle selected menu item
    if (result == 'kickout') {
      // Perform kickout action
      print('Kickout action');
    } else if (result == 'make_captains') {
      ref
          .watch(memberControllerProvider(rutinId).notifier)
          .AddCapten(rutinId, username, context);
      // Perform make captains action
    }
  }
}
