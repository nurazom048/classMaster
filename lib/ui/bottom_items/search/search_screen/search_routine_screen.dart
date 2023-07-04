// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/home_req/home_routines_controller.dart';
import 'package:table/ui/bottom_items/search/search_screen/search_page.dart';
import 'package:table/widgets/error/error.widget.dart';

import '../../../../core/component/Loaders.dart';
import '../../../../core/dialogs/alert_dialogs.dart';
import '../../Home/Full_routine/utils/routine_dialog.dart';
import '../../Home/Full_routine/widgets/routine_box/rutin_box_by_id.dart';
import '../search controller/search_rutine_controllers.dart';

class SearchRutineScreen extends ConsumerWidget {
  SearchRutineScreen({super.key});
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //! provider
    final searchText = ref.watch(searchStringProvider);
    final searchRoutine = ref.watch(searchRutineController(searchText));
    //notifier
    final homeRoutinesNotifier =
        ref.watch(homeRoutineControllerProvider(null).notifier);

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
            itemCount: data.routine.length,
            itemBuilder: (context, index) {
              return RutinBoxById(
                  margin: EdgeInsets.zero,
                  rutinName: data.routine[index].name,
                  onTapMore: () => RoutineDialog.CheckStatusUser_BottomSheet(
                        context,
                        routineID: data.routine[index].id,
                        routineName: data.routine[index].name,
                        routinesController: homeRoutinesNotifier,
                      ),
                  rutinId: data.routine[index].id);
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