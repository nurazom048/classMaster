// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/component/loaders.dart';
import '../../../../core/dialogs/alert_dialogs.dart';
import '../../../../core/widgets/error/error.widget.dart';
import '../../../routine/presentation/providers/routine_list_provider.dart';
import '../../../routine/presentation/utils/routine_dialog.dart';
import '../../../routine/presentation/widgets/dynamic_widgets/routine_box_by_id.dart';
import 'search_page.dart' show searchStringProvider;

class SearchRoutineScreen extends ConsumerWidget {
  SearchRoutineScreen({super.key});
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchText = ref.watch(searchStringProvider);
    final searchRoutine = ref.watch(routineListProvider(RoutineListQuery(search: searchText)));
    final homeRoutinesNotifier = ref.watch(
      routineListProvider(RoutineListQuery(search: searchText)).notifier,
    );

    //
    return Scaffold(
      body: searchRoutine.when(
        data: (data) {
          void scrollListener(double pixels) {
            if (pixels == scrollController.position.maxScrollExtent) {
              print('End of scroll');
              homeRoutinesNotifier.loadMore();
            }
          }

          scrollController.addListener(() {
            scrollListener(scrollController.position.pixels);
          });

          return ListView.separated(
            //physics: const NeverScrollableScrollPhysics(),
            controller: scrollController,
            padding: const EdgeInsets.only(bottom: 100),
            itemCount: data.routines.length,
            itemBuilder: (context, index) {
              return RoutineBoxById(
                margin: EdgeInsets.zero,
                routineName: data.routines[index].routineName,
                onTapMore:
                    () => RoutineDialog.CheckStatusUser_BottomSheet(
                      context,
                      routineID: data.routines[index].id,
                      routineName: data.routines[index].routineName,
                      routinesController: homeRoutinesNotifier,
                    ),
                routineId: data.routines[index].id,
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 10),
          );
        },
        error: (error, stackTrace) {
          Alert.handleError(context, error);
          return ErrorScreen(error: error.toString());
        },
        loading: () => Loaders.center(),
      ),
    );
  }
}
