// ignore_for_file: must_be_immutable

import 'package:classmate/features/authentication_fetures/presentation/screen/change_password.dart';
import 'package:classmate/features/routine_Fetures/presentation/widgets/dynamic_widgets/routine_card_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/utils.dart';

import '../../../../../../core/dialogs/alert_dialogs.dart';

import '../../../../../core/widgets/appWidget/app_text.dart';
import '../../../../../core/widgets/appWidget/buttons/expended_button.dart';
import '../../../../../core/widgets/appWidget/dotted_divider.dart';
import '../../../../../core/widgets/appWidget/select_day_row.dart';
import '../../../../../core/widgets/mini_account_row.dart';
import '../../../../routine_summary_fetures/presentation/screens/summary_screen.dart';
import '../../../data/models/class_details_model.dart';
import '../../providers/checkbox_selector_button.dart';
import '../../providers/routine_details.controller.dart';
import '../../screens/view_more_screen.dart';
import '../../utils/routine_dialog.dart';
import '../static_widgets/routine_box_id_skeleton.dart';
import '../static_widgets/send_request_button.dart';

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
  final dynamic onTapMore;
  final EdgeInsetsGeometry? margin;

  const RoutineBoxById({
    super.key,
    required this.routineName,
    required this.onTapMore,
    required this.routineId,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        // Get providers
        final checkStatus = ref.watch(checkStatusControllerProvider(routineId));
        final routineDetails = ref.watch(routineDetailsProvider(routineId));
        final checkStatusNotifier = ref.watch(
          checkStatusControllerProvider(routineId).notifier,
        );

        //

        return Container(
          constraints: const BoxConstraints(minHeight: 426),
          margin:
              margin ?? const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  // Top section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Routine name
                        InkWell(
                          onTap:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ViewMore(
                                        routineId: routineId,
                                        routineName: routineName,
                                        ownerName: ref.watch(
                                          ownerNameProvider(routineId),
                                        ),
                                      ),
                                ),
                              ),
                          child: Text(routineName, style: TS.heading()),
                        ),

                        //  Notification button or request button
                        checkStatus.when(
                          data: (data) {
                            String status = data.activeStatus;
                            bool notificationOn = data.notificationOn;
                            return SendReqButton(
                              isNotSendRequest: status == "not_joined",
                              isPending: status == "request_pending",
                              isMember: true,
                              notificationOn: notificationOn,
                              sendRequest: () {
                                checkStatusNotifier.sendReqController(context);
                              },
                              showPanel: () {
                                RoutineDialog.routineNotificationsSelect(
                                  context,
                                  routineId,
                                );
                              },
                            );
                          },
                          error:
                              (error, stackTrace) =>
                                  Alert.handleError(context, error),
                          loading: () => const Text("...."),
                        ),
                      ],
                    ),
                  ),

                  // Divider
                  MyDivider(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ).copyWith(bottom: 0),
                  ),
                  ClassSliderView(routineId: routineId),
                ],
              ),
              // Bottom section
              Column(
                children: [
                  MyDivider(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ).copyWith(top: 0).copyWith(bottom: 3),
                  ),
                  routineDetails.when(
                    data: (data) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        String? ownerName = data.owner.name;
                        ref
                            .watch(ownerNameProvider(routineId).notifier)
                            .update((state) => ownerName);
                      });

                      return MiniAccountInfo(
                        accountData: data.owner,
                        onTapMore: onTapMore,
                      );
                    },
                    error:
                        (error, stackTrace) =>
                            Alert.handleError(context, error),
                    loading: () => const AccountSkeleton(),
                  ),
                ],
              ),
            ],
          ),
        );
      },
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
