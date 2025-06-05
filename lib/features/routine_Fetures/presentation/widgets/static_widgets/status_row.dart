import 'package:classmate/core/widgets/text%20and%20buttons/square_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classmate/features/routine_Fetures/presentation/providers/checkbox_selector_button.dart';

import '../../../../../core/dialogs/alert_dialogs.dart';

class StatusRow extends ConsumerWidget {
  final String routineId;
  const StatusRow(this.routineId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // providers
    final checkStatus = ref.watch(checkStatusControllerProvider(routineId));
    // with notifier
    final checkStatusNotifier = ref.watch(
      checkStatusControllerProvider(routineId).notifier,
    );
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
                  context,
                  "are you sure you want to leave",
                  onConfirm: (isConfirmed) {
                    if (isConfirmed) {
                      ref
                          .read(
                            checkStatusControllerProvider(routineId).notifier,
                          )
                          .leaveMember(context, ref);
                    }
                  },
                );
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
              },
            ),
          SquaresButton(
            inActiveIcon: Icons.bookmark_added,
            icon: Icons.bookmark_add_sharp,
            text: 'Save',
            inActiveText: "add to save",
            status: checkStatus.value?.isSave,
            ontap: () {
              checkStatusNotifier.saveUnsaved(
                context,
                !(checkStatus.value?.isSave ?? false),
              );
            },
          ),
          SquaresButton(
            icon: Icons.u_turn_right,
            text: 'Back to Routine',
            ontap: () => Navigator.pop(context),
            status: false,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
