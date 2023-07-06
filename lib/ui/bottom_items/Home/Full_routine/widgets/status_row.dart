import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/Full_routine/controller/check_status_controller.dart';

import '../../../../../core/dialogs/alert_dialogs.dart';
import '../../../../../widgets/text and buttons/square_button.dart';

class StatusRow extends ConsumerWidget {
  final String rutinId;
  const StatusRow(
    this.rutinId, {
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // providers
    final checkStatus = ref.watch(checkStatusControllerProvider(rutinId));
    // with notifier
    final checkStatusNotifier =
        ref.watch(checkStatusControllerProvider(rutinId).notifier);
    String status = checkStatus.value?.activeStatus ?? '';
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          if (status == "joined")
            SquaresButton(
              icon: Icons.logout,
              inActiveText: "leave",
              color: Colors.redAccent,
              text: status,
              ontap: () {
                return Alert.errorAlertDialogCallBack(
                    context, "are you sure you want to leave", onConfirm: () {
                  //  Navigator.pop(context);

                  ref
                      .read(checkStatusControllerProvider(rutinId).notifier)
                      .leaveMember(context, ref);
                });
              },
            )
          else
            SquaresButton(
                icon: Icons.people_rounded,
                inActiveIcon: Icons.telegram,
                inActiveText: status,
                status: status == "request_pending" ? true : false,
                text: status,
                ontap: () {
                  checkStatusNotifier.sendReqController(context);
                }),
          SquaresButton(
              inActiveIcon: Icons.bookmark_added,
              icon: Icons.bookmark_add_sharp,
              text: 'Save',
              inActiveText: "add to save",
              status: checkStatus.value?.isSave,
              ontap: () {
                checkStatusNotifier.saveUnsaved(
                    context, !(checkStatus.value?.isSave ?? false));
              }),
          SquaresButton(
            icon: Icons.u_turn_right,
            text: 'Back to rutin',
            ontap: () => Navigator.pop(context),
            status: false,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
