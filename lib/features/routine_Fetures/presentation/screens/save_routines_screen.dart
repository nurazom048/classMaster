// ignore_for_file: use_build_context_synchronously, unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classmate/features/routine_Fetures/presentation/providers/save_routine.controller.dart';
import '../../../../core/export_core.dart';
import '../../../home_fetures/data/datasources/home_routines_controller.dart';
import '../../../home_fetures/presentation/utils/utils.dart';
import '../utils/routine_dialog.dart';
import '../widgets/dynamic_widgets/routine_box_by_id.dart';

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
    final homeRoutinesNotifier = ref.watch(
      homeRoutineControllerProvider(null).notifier,
    );

    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            final bool isOnline = await Utils.isOnlineMethod();
            if (!isOnline) {
              Alert.showSnackBar(context, 'You are in offline mode');
            } else {
              //! provider
              ref.refresh(saveRoutineProvider);
            }
          },
          child: Column(
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
                              .watch(
                                homeRoutineControllerProvider(null).notifier,
                              )
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
                              final id = data.savedRoutines[index].id;
                              final name = data.savedRoutines[index].name;
                              return RoutineBoxById(
                                routineId: id,
                                routineName: name,
                                onTapMore:
                                    () =>
                                        RoutineDialog.CheckStatusUser_BottomSheet(
                                          context,
                                          routineID: id,
                                          routineName: name,
                                          routinesController:
                                              homeRoutinesNotifier,
                                        ),
                              );
                            },
                          );
                    },
                    error:
                        (error, stackTrace) =>
                            Alert.handleError(context, error),
                    loading: () => Loaders.center(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
