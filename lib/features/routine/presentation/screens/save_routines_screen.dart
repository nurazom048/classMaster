// ignore_for_file: use_build_context_synchronously, unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classmate/features/routine/presentation/providers/routine_list_provider.dart';
import '../../../../core/export_core.dart';
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
    final saveRoutines = ref.watch(routineListProvider(const RoutineListQuery(type: 'saved')));
    final homeRoutinesNotifier = ref.watch(
      routineListProvider(const RoutineListQuery(type: 'saved')).notifier,
    );

    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            final bool isOnline = await Utils.isOnlineMethod();
            if (!isOnline) {
              Alert.showSnackBar(context, 'You are in offline mode');
            } else {
              ref.refresh(routineListProvider(const RoutineListQuery(type: 'saved')));
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
                          homeRoutinesNotifier.loadMore();
                        }
                      }

                      saveRoutinesScrolled.addListener(scrollListener);
                      return data.routines.isEmpty
                          ? const ErrorScreen(error: 'No Save Routines')
                          : ListView.builder(
                            shrinkWrap: true,
                            itemCount: data.routines.length,
                            controller: saveRoutinesScrolled,
                            // physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final id = data.routines[index].id;
                              final name = data.routines[index].routineName;
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
