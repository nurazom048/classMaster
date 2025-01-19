import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classmate/ui/bottom_nevbar_items/Add/widgets/wekkday_view.dart';

import '../../../../core/component/Loaders.dart';
import '../../../../core/dialogs/alert_dialogs.dart';
import '../../Home/Full_routine/controller/weekday_controller.dart';
import '../utils/add_weekday_screen.dart';
import 'add_weekday_button.dart';

class ShowWeekdayWidgets extends ConsumerWidget {
  final String classId;
  const ShowWeekdayWidgets({super.key, required this.classId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //!provider
    final weekdayListProvider =
        ref.watch(weekdayControllerStateProvider(classId));
    final weekdayController =
        ref.read(weekdayControllerStateProvider(classId).notifier);

    return Column(
      children: [
        weekdayListProvider.when(
          data: (data) {
            return Column(
              children: List.generate(
                data.weekdays.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: WeekdayView(
                    showDeleteButton: data.weekdays.length != 1,
                    weekday: data.weekdays[index],

                    // delete weekday
                    onTap: () {
                      String id = data.weekdays[index].id;
                      weekdayController.deleteWeekday(context, id, classId);
                    },
                  ),
                ),
              ),
            );
          },
          error: (error, stackTrace) => Alert.handleError(context, error),
          loading: () => Loaders.center(),
        ),
        AddWeekdayButton(
            icon: Icons.add,
            text: 'Add More Weekday',
            onPressed: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  fullscreenDialog: true,
                  opaque: false,
                  pageBuilder: (BuildContext context, animation, __) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOut,
                      )),
                      child: AddWeekdayScreen(classId: classId),
                    );
                  },
                ),
              );
            })
      ],
    );
  }
}
