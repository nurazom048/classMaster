import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/Full_routine/controller/saveroutine.controller.dart';
import 'package:table/ui/bottom_items/Home/Full_routine/widgets/routine_box/rutin_box_by_id.dart';

import '../../../../core/component/Loaders.dart';
import '../../../../core/dialogs/alert_dialogs.dart';
import '../../../../widgets/heder/heder_title.dart';
import '../../Home/Full_routine/utils/routine_dialog.dart';
import '../../Home/home_req/home_routines_controller.dart';

class SaveRoutinesScreen extends ConsumerWidget {
  SaveRoutinesScreen({super.key});
  final saveRoutinesScrolled = ScrollController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //! provider
    final saveRoutines = ref.watch(saveRoutineProvider);
//notifier
    final homeRoutinesNotifier =
        ref.watch(homeRoutineControllerProvider(null).notifier);
    return Scaffold(
      body: Column(
        children: [
          HeaderTitle("All Save Routines", context),
          const SizedBox(height: 25),
          Expanded(
            child: Container(
              child: saveRoutines.when(
                data: (data) {
                  void scrollListener() {
                    if (saveRoutinesScrolled.position.pixels ==
                        saveRoutinesScrolled.position.maxScrollExtent) {
                      print('end.........................');
                      ref
                          .watch(homeRoutineControllerProvider(null).notifier)
                          .loadMore(data.currentPage);
                    }
                  }

                  saveRoutinesScrolled.addListener(scrollListener);
                  return ListView.builder(
                    itemCount: data.savedRoutines.length,
                    controller: saveRoutinesScrolled,
                    // physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return RutinBoxById(
                        rutinId: data.savedRoutines[index].id,
                        rutinName: data.savedRoutines[index].name,
                        onTapMore: () =>
                            RoutineDialog.CheckStatusUser_BottomSheet(
                          context,
                          routineID: data.savedRoutines[index].id,
                          routineName: data.savedRoutines[index].name,
                          routinesController: homeRoutinesNotifier,
                        ),
                      );
                    },
                  );
                },
                error: (error, stackTrace) => Alert.handleError(context, error),
                loading: () => Loaders.center(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
