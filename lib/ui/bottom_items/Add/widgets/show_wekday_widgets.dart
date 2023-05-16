import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Add/widgets/wekkday_view.dart';

import '../../../../core/component/Loaders.dart';
import '../../../../core/dialogs/alart_dialogs.dart';
import '../../Home/full_rutin/controller/weekday_controller.dart';
import '../utils/weekdayUtils.dart';
import 'addWeekdayButton.dart';

class ShowWeekdayWidgets extends ConsumerWidget {
  final String classId;
  const ShowWeekdayWidgets({super.key, required this.classId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //!provider
    final weekdayListProvider =
        ref.watch(weekayControllerStateProvider(classId));
    final weekdayController =
        ref.read(weekayControllerStateProvider(classId).notifier);
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
                    weekday: data.weekdays[index],

                    // delete weekday
                    onTap: () {
                      String id = data.weekdays[index].id;
                      weekdayController.deleteWeekday(context, id);
                    },
                  ),
                ),
              ),
            );
          },
          error: (error, stackTrace) => Alart.handleError(context, error),
          loading: () => Loaders.center(),
        ),
        AddWeekdayButton(onPressed: () {
          WeekdayUtils.addWeekday(context, classId);
        }),
      ],
    );
  }
}
