// ignore_for_file: must_be_immutable

import 'package:classmate/features/authentication_fetures/presentation/screen/change_password.dart';
import 'package:classmate/features/routine/presentation/widgets/dynamic_widgets/routine_card_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/utils.dart';

import 'package:classmate/core/dialogs/alert_dialogs.dart';

import '../../../../../core/widgets/appWidget/app_text.dart';
import '../../../../../core/widgets/appWidget/buttons/expended_button.dart';
import '../../../../../core/widgets/appWidget/dotted_divider.dart';
import '../../../../../core/widgets/appWidget/select_day_row.dart';
import '../../../../../core/widgets/mini_account_row.dart';
import '../../../../routine_summary_fetures/presentation/screens/summary_screen.dart';
import '../../../data/models/class_details_model.dart';
import '../../providers/chack_status_controller.dart';
import '../../providers/routine_details.controller.dart';
import '../../screens/view_more_screen.dart';
import '../../utils/routine_dialog.dart';
import '../static_widgets/routine_box_id_skeleton.dart';
import '../static_widgets/send_request_button.dart';
import 'polymorphic_routine_card.dart';

//! provider

final ownerNameProvider = StateProvider.family<String?, String>((
  ref,
  keyRoutineID,
) {
  return null;
});
final isExpandedProvider = StateProvider.family<bool, String>((
  ref,
  keyRoutineID,
) {
  return false;
});

final initialWeekdayProvider = StateProvider.family<int, String>((
  ref,
  routineId,
) {
  final int day = DateTime.now().weekday;
  return day == 7 ? 0 : day;
});

class RoutineBoxById extends StatelessWidget {
  final String routineName;
  final String routineId;
  final String routineType;
  final dynamic onTapMore;
  final EdgeInsetsGeometry? margin;

  const RoutineBoxById({
    super.key,
    required this.routineName,
    required this.onTapMore,
    required this.routineId,
    this.routineType = "CLASS",
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return RoutineFeedCard(
      routineId: routineId,
      routineName: routineName,
      routineType: routineType,
      onTapMore: onTapMore is VoidCallback ? onTapMore : () {},
      margin: margin,
    );
  }
}

class ClassSliderView extends ConsumerWidget {
  final String routineId;
  const ClassSliderView({super.key, required this.routineId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //! provider
    final routineDetails = ref.watch(routineDetailsProvider(routineId));
    //
    // final initialDay = ref.watch(initialWeekdayProvider(routineId));
    final initialDayNotifier = ref.watch(
      initialWeekdayProvider(routineId).notifier,
    );

    return Column(
      children: [
        ///  Select day row
        SelectDayRow(
          routineId: routineId,
          selectedDay: (selectedDay) {
            initialDayNotifier.update((state) => selectedDay);
          },
        ),

        routineDetails.when(
          data: (data) {
            final List<Day?> sun = data.weekdayClasses.sunday;
            final List<Day?> mon = data.weekdayClasses.monday;
            final List<Day?> tue = data.weekdayClasses.tuesday;
            final List<Day?> wed = data.weekdayClasses.wednesday;
            final List<Day?> thu = data.weekdayClasses.thursday;
            final List<Day?> fri = data.weekdayClasses.friday;
            final List<Day?> sat = data.weekdayClasses.saturday;

            final List<Day?> current = currentDay(
              sun,
              mon,
              tue,
              wed,
              thu,
              fri,
              sat,
              ref,
            );

            //
            final isExpanded = ref.watch(isExpandedProvider(routineId));
            final isExpandedNotifier = ref.watch(
              isExpandedProvider(routineId).notifier,
            );
            final int classLength =
                isExpanded == true || current.length <= 3 ? current.length : 3;
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: classLength,
              itemBuilder: (context, index) {
                if (current.isNotEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RoutineCardInfoRow(
                        isFirst: index == 0,
                        isThird: index == 2 && current.length == 3,
                        day: current[index],
                        onTap: () {
                          onTap(current[index], context);
                        },
                      ),
                      if (index.isEqual(classLength - 1) && current.length > 3)
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          child: ExpendedButton(
                            isExpanded: isExpanded,
                            onTap: () {
                              isExpandedNotifier.update((state) => !state);
                            },
                          ),
                        ),
                    ],
                  );
                } else {
                  return const Text("No Class");
                }
              },
            );
          },
          loading: () => const SizedBox(),
          error: (error, stackTrace) => Alert.handleError(context, error),
        ),
      ],
    );
  }

  List<Day?> currentDay(
    List<Day?> sun,
    List<Day?> mon,
    List<Day?> tue,
    List<Day?> wed,
    List<Day?> thu,
    List<Day?> fri,
    List<Day?> sat,
    WidgetRef ref,
  ) {
    List<Day?> newListOfDays;

    switch (ref.watch(initialWeekdayProvider(routineId))) {
      case 0:
        newListOfDays = sun;
        break;
      case 1:
        newListOfDays = mon;
        break;
      case 2:
        newListOfDays = tue;
        break;
      case 3:
        newListOfDays = wed;
        break;
      case 4:
        newListOfDays = thu;
        break;
      case 5:
        newListOfDays = fri;
        break;
      case 6:
        newListOfDays = sat;
        break;
      case 7:
        newListOfDays = sun;
        break;
      default:
        // If the selected day is not valid, use an empty list
        newListOfDays = [];
        break;
    }

    // if (!mounted) {}

    return newListOfDays;
  }

  void onTap(Day? day, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => SummaryScreen(
              classId: day!.id,
              className: day.name,
              instructorName: day.instructorName,
              routineID: day.routineId,
              subjectCode: day.subjectCode,
              startTime: day.startTime,
              endTime: day.endTime,
              room: day.room,
            ),
      ),
    );
  }
}
