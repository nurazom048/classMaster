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
                      return data.routines.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.bookmark_border_rounded,
                                    size: 72,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "No saved routines yet",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 40),
                                    child: Text(
                                      "Routines you bookmark will appear here for quick access even when offline.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : NotificationListener<ScrollNotification>(
                              onNotification: (scrollInfo) {
                                if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                                  homeRoutinesNotifier.loadMore();
                                }
                                return false;
                              },
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: data.routines.length,
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
                              ),
                            );
                    },
                    error: (error, stackTrace) => Alert.handleError(context, error),
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
