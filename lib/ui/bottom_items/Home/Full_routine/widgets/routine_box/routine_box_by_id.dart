// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:classmate/widgets/appWidget/app_text.dart';
import 'package:classmate/ui/bottom_items/Home/Full_routine/widgets/routine_box/rutin_card_row.dart';
import 'package:classmate/widgets/appWidget/buttons/expended_button.dart';
import 'package:classmate/widgets/appWidget/dotted_divider.dart';
import 'package:classmate/widgets/mini_account_row.dart';

import '../../../../../../core/dialogs/alert_dialogs.dart';
import '../../../../../../models/class_details_model.dart';
import '../../controller/check_status_controller.dart';
import '../../controller/routine_details.controller.dart';
import '../../screen/viewMore/view_more_screen.dart';
import '../../Summary/summat_screens/summary_screen.dart';
import '../../../../../../widgets/appWidget/select_day_row.dart';
import '../../utils/routine_dialog.dart';
import '../send_request_button.dart';
import '../skelton/routine_box_id_scelton.dart';

//! provider

final ownerNameProvider =
    StateProvider.family<String?, String>((ref, keyRoutineID) {
  return null;
});
final isExpandedProvider =
    StateProvider.family<bool, String>((ref, keyRoutineID) {
  return false;
});

final initialWeekdayProvider =
    StateProvider.family<int, String>((ref, routineId) {
  final int day = DateTime.now().weekday;
  return day == 7 ? 0 : day;
});

class RoutineBoxById extends StatelessWidget {
  final String rutinName;
  final String routineId;
  final dynamic onTapMore;
  final EdgeInsetsGeometry? margin;

  const RoutineBoxById({
    Key? key,
    required this.rutinName,
    required this.onTapMore,
    required this.routineId,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      // Get providers
      final checkStatus = ref.watch(checkStatusControllerProvider(routineId));
      final rutinDetails = ref.watch(routineDetailsProvider(routineId));
      final checkStatusNotifier =
          ref.watch(checkStatusControllerProvider(routineId).notifier);

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
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewMore(
                              routineId: routineId,
                              routineName: rutinName,
                              ownerName:
                                  ref.watch(ownerNameProvider(routineId)),
                            ),
                          ),
                        ),
                        child: Text(
                          rutinName,
                          style: TS.heading(),
                        ),
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
                              RoutineDialog.rutineNotificationsSelect(
                                context,
                                routineId,
                              );
                            },
                          );
                        },
                        error: (error, stackTrace) =>
                            Alert.handleError(context, error),
                        loading: () => const Text("...."),
                      ),
                    ],
                  ),
                ),

                // Divider
                MyDivider(
                  padding: const EdgeInsets.symmetric(vertical: 10)
                      .copyWith(bottom: 0),
                ),
                ClassSliderView(routineId: routineId),
              ],
            ),
            // Bottom section
            Column(
              children: [
                MyDivider(
                  padding: const EdgeInsets.symmetric(vertical: 10)
                      .copyWith(top: 0)
                      .copyWith(bottom: 3),
                ),
                rutinDetails.when(
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
                  error: (error, stackTrace) =>
                      Alert.handleError(context, error),
                  loading: () => const AccountScelton(),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class ClassSliderView extends ConsumerWidget {
  final String routineId;
  const ClassSliderView({
    super.key,
    required this.routineId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //! provider
    final rutinDetails = ref.watch(routineDetailsProvider(routineId));
    //
    // final initialDay = ref.watch(initialWeekdayProvider(routineId));
    final initialDayNotifier =
        ref.watch(initialWeekdayProvider(routineId).notifier);

    return Column(
      children: [
        ///  Select day row
        SelectDayRow(
          routineId: routineId,
          selectedDay: (selectedDay) {
            initialDayNotifier.update((state) => selectedDay);
          },
        ),

        rutinDetails.when(
          data: (data) {
            final List<Day?> sun = data.classes.sunday;
            final List<Day?> mon = data.classes.monday;
            final List<Day?> tue = data.classes.tuesday;
            final List<Day?> wed = data.classes.wednesday;
            final List<Day?> thu = data.classes.thursday;
            final List<Day?> fri = data.classes.friday;
            final List<Day?> sat = data.classes.saturday;

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
            final isExpandedNotifier =
                ref.watch(isExpandedProvider(routineId).notifier);
            final int classLenght =
                isExpanded == true || current.length <= 3 ? current.length : 3;
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: classLenght,
              itemBuilder: (context, index) {
                if (current.isNotEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RutineCardInfoRow(
                        isFirst: index == 0,
                        isThird: index == 2 && current.length == 3,
                        day: current[index],
                        onTap: () {
                          onTap(current[index], context);
                        },
                      ),
                      if (index.isEqual(classLenght - 1) && current.length > 3)
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: ExpendedButton(
                            isExpanded: isExpanded,
                            onTap: () {
                              isExpandedNotifier.update((state) => !state);
                            },
                          ),
                        )
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

  void onTap(Day? day, context) {
    Get.to(
      () => SummaryScreen(
        classId: day!.classId.id,
        className: day.classId.name,
        instructorName: day.classId.instuctorName,
        routineID: day.routineId,
        subjectCode: day.classId.subjectcode,
        //
        startTime: day.startTime,
        endTime: day.endTime,
        room: day.room,
      ),
    );
  }
}
