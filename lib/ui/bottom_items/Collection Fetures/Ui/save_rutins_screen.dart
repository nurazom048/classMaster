import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/Full_routine/controller/saveroutine.controller.dart';

import '../../../../core/component/Loaders.dart';
import '../../../../core/dialogs/alert_dialogs.dart';
import '../../../../widgets/heder/heder_title.dart';
import '../../Home/Full_routine/utils/routine_dialog.dart';
import '../../Home/Full_routine/widgets/routine_box/routine_box_by_ID.dart';
import '../../Home/home_req/home_routines_controller.dart';

class SaveRoutinesScreen extends ConsumerStatefulWidget {
  const SaveRoutinesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SaveRoutinesScreenState();
}

final saveRoutinesScrolled = ScrollController();

class _SaveRoutinesScreenState extends ConsumerState<SaveRoutinesScreen> {
  @override
  Widget build(BuildContext context) {
    //! provider
    final saveRoutines = ref.watch(saveRoutineProvider);
//notifier
    final homeRoutinesNotifier =
        ref.watch(homeRoutineControllerProvider(null).notifier);

    return SafeArea(
      child: Scaffold(
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
                      ref
                          .watch(homeRoutineControllerProvider(null).notifier)
                          .loadMore(data.currentPage);
                    }
                  }

                  saveRoutinesScrolled.addListener(scrollListener);
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.savedRoutines.length,
                    controller: saveRoutinesScrolled,
                    // physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return RoutineBoxById(
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
      )),
    );
  }
}
