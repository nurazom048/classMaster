import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classmate/ui/bottom_items/Home/Full_routine/controller/saveroutine.controller.dart';
import 'package:classmate/widgets/error/error.widget.dart';

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
                  return data.savedRoutines.isEmpty
                      ? const ErrorScreen(error: 'No Save Routines')
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.savedRoutines.length,
                          controller: saveRoutinesScrolled,
                          // physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final id = data.savedRoutines[index].routineID.id;
                            final name =
                                data.savedRoutines[index].routineID.name;
                            return RoutineBoxById(
                              rutinId: id,
                              rutinName: name,
                              onTapMore: () =>
                                  RoutineDialog.CheckStatusUser_BottomSheet(
                                context,
                                routineID: id,
                                routineName: name,
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
