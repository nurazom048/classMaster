import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/controller/saveroutine.controller.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/widgets/rutin_box/rutin_box_by_id.dart';

import '../../../../core/component/Loaders.dart';
import '../../../../core/dialogs/alart_dialogs.dart';
import '../../../../widgets/heder/heder_title.dart';
import '../../Home/full_rutin/utils/rutin_dialog.dart';
import '../../Home/home_req/home_rutins_controller.dart';

class SaveRoutinesScreen extends ConsumerWidget {
  SaveRoutinesScreen({super.key});
  final saveRoutinesScroller = ScrollController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //! provider
    final saveRoutines = ref.watch(saveroutineProvider);
//notifier
    final homeRutinsNotifier =
        ref.watch(homeRutinControllerProvider(null).notifier);
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
                    if (saveRoutinesScroller.position.pixels ==
                        saveRoutinesScroller.position.maxScrollExtent) {
                      print('end.........................');
                      ref
                          .watch(homeRutinControllerProvider(null).notifier)
                          .loadMore(data.currentPage);
                    }
                  }

                  saveRoutinesScroller.addListener(scrollListener);
                  return ListView.builder(
                    itemCount: data.savedRoutines.length,
                    controller: saveRoutinesScroller,
                    // physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return RutinBoxById(
                        rutinId: data.savedRoutines[index].id,
                        rutinName: data.savedRoutines[index].name,
                        onTapMore: () =>
                            RutinDialog.ChackStatusUser_BottomSheet(
                          context,
                          routineID: data.savedRoutines[index].id,
                          routineName: data.savedRoutines[index].name,
                          rutinsController: homeRutinsNotifier,
                        ),
                      );
                    },
                  );
                },
                error: (error, stackTrace) => Alart.handleError(context, error),
                loading: () => Loaders.center(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
