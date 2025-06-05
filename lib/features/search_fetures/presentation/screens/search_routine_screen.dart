// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/component/Loaders.dart';
import '../../../../core/dialogs/alert_dialogs.dart';
import '../../../../core/widgets/error/error.widget.dart';
import '../../../home_fetures/data/datasources/home_routines_controller.dart';
import '../../../routine_Fetures/presentation/utils/routine_dialog.dart';
import '../../../routine_Fetures/presentation/widgets/dynamic_widgets/routine_box_by_id.dart';
import '../../../routine_Fetures/presentation/widgets/dynamic_widgets/see_all_members_screen.dart';
import '../providers/search_rutine_controllers.dart';

class SearchRutineScreen extends ConsumerWidget {
  SearchRutineScreen({super.key});
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //! provider
    final searchText = ref.watch(searchStringProvider);
    final searchRoutine = ref.watch(searchRutineController(searchText));
    //notifier
    final homeRoutinesNotifier = ref.watch(
      homeRoutineControllerProvider(null).notifier,
    );

    //
    return Scaffold(
      body: searchRoutine.when(
        data: (data) {
          void scrollListener(double pixels) {
            if (pixels == scrollController.position.maxScrollExtent) {
              print('End of scroll');
              ref
                  .watch(searchRutineController(searchText).notifier)
                  .loadMore(data.currentPage);
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
                routineName: data.routines[index].name,
                onTapMore:
                    () => RoutineDialog.CheckStatusUser_BottomSheet(
                      context,
                      routineID: data.routines[index].id,
                      routineName: data.routines[index].name,
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
