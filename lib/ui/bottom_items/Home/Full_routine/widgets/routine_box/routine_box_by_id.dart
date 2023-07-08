// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:table/widgets/appWidget/app_text.dart';
import 'package:table/ui/bottom_items/Home/Full_routine/widgets/routine_box/rutin_card_row.dart';
import 'package:table/widgets/appWidget/buttons/expended_button.dart';
import 'package:table/widgets/appWidget/dotted_divider.dart';
import 'package:table/widgets/mini_account_row.dart';

import '../../../../../../core/dialogs/alert_dialogs.dart';
import '../../../../../../models/class_details_model.dart';
import '../../controller/check_status_controller.dart';
import '../../screen/viewMore/view_more_screen.dart';
import '../../Summary/summat_screens/summary_screen.dart';
import '../../request/routine_api.dart';
import '../../../../../../widgets/appWidget/select_day_row.dart';
import '../../utils/routine_dialog.dart';
import '../send_request_button.dart';
import '../skelton/routine_box_id_scelton.dart';

//! provider

final ownerNameProvider = StateProvider.autoDispose<String?>((ref) => null);
final isExpandedProvider = StateProvider.autoDispose<bool>((ref) => false);

class RoutineBoxById extends StatefulWidget {
  final String rutinName;
  final String rutinId;
  final dynamic onTapMore;
  final EdgeInsetsGeometry? margin;
  List<Day?> listOfDayState = [];
  List<Day?> allDays = [];

  int gSelectedDay = DateTime.now().weekday;

  RoutineBoxById({
    Key? key,
    required this.rutinName,
    required this.onTapMore,
    required this.rutinId,
    this.margin,
  }) : super(key: key);

  @override
  State<RoutineBoxById> createState() => _RutinBoxByIdState();
}

class _RutinBoxByIdState extends State<RoutineBoxById> {
  @override
  void initState() {
    super.initState();
    widget.gSelectedDay = DateTime.now().weekday;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      // Get providers
      final checkStatus =
          ref.watch(checkStatusControllerProvider(widget.rutinId));
      final rutinDetails = ref.watch(routine_details_provider(widget.rutinId));

      String status = checkStatus.value?.activeStatus ?? '';
      bool notificationOn = checkStatus.value?.notificationOn ?? false;
      // Get notifier
      final checkStatusNotifier =
          ref.watch(checkStatusControllerProvider(widget.rutinId).notifier);

      //
      final isExpanded = ref.watch(isExpandedProvider);
      final isExpandedNotifier = ref.watch(isExpandedProvider.notifier);

      return Container(
        constraints: const BoxConstraints(minHeight: 428),
        margin: widget.margin ??
            const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
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
                      // Rutin name
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewMore(
                              routineId: widget.rutinId,
                              routineName: widget.rutinName,
                              ownerName: ref.watch(ownerNameProvider),
                            ),
                          ),
                        ),
                        child: Text(
                          widget.rutinName,
                          style: TS.heading(),
                        ),
                      ),

                      // Notification button or request button
                      checkStatus.when(
                        data: (data) {
                          return SendReqButton(
                            isNotSendRequest: status == "not_joined",
                            isPending: status == "request_pending",
                            isMember: true,
                            notificationOn: notificationOn,
                            sendRequest: () {
                              checkStatusNotifier.sendReqController(context);
                            },
                            showPanel: () {
                              if (!mounted) return;

                              RoutineDialog.rutineNotificationsSelect(
                                context,
                                widget.rutinId,
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

                // Select day row
                SelectDayRow(selectedDay: (selectedDay) {
                  if (!mounted) return;

                  setState(() {
                    if (widget.gSelectedDay != selectedDay) {
                      widget.gSelectedDay = selectedDay;
                    }
                  });
                }),

                // Rutin info and owner info
                rutinDetails.when(
                  data: (data) {
                    if (data == null) return const Text("id null");

                    List<Day?> sun = data.classes.sunday;
                    List<Day?> mon = data.classes.monday;
                    List<Day?> tue = data.classes.tuesday;
                    List<Day?> wed = data.classes.wednesday;
                    List<Day?> thu = data.classes.thursday;
                    List<Day?> fri = data.classes.friday;
                    List<Day?> sat = data.classes.saturday;

                    //
                    int classLenght =
                        isExpanded == true || widget.listOfDayState.length <= 2
                            ? widget.listOfDayState.length
                            : 2;
                    selectDays(sun, mon, tue, wed, thu, fri, sat);
                    return Container(
                      //  color: Colors.red,
                      constraints: const BoxConstraints(minHeight: 200),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: classLenght,
                        itemBuilder: (context, index) {
                          if (widget.listOfDayState.isNotEmpty) {
                            return Column(
                              children: [
                                RutineCardInfoRow(
                                  isFirst: index == 0,
                                  day: widget.listOfDayState[index],
                                  onTap: () {
                                    if (!mounted) return;

                                    onTap(widget.listOfDayState[index], status,
                                        context);
                                  },
                                ),
                                if (index.isEqual(classLenght - 1) &&
                                    widget.listOfDayState.length > 2)
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: ExpendedButton(
                                      isExpanded: isExpanded,
                                      onTap: () {
                                        if (!mounted) return;
                                        isExpandedNotifier
                                            .update((state) => !state);
                                      },
                                    ),
                                  )
                              ],
                            );
                          } else {
                            return const Text("No Class");
                          }
                        },
                      ),
                    );
                  },
                  error: (error, stackTrace) =>
                      Alert.handleError(context, error),
                  loading: () => const Text(
                    "______________________________________________",
                  ),
                ),
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
                    if (data == null) {}
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        String? ownerName = data?.owner.name;
                        ref
                            .watch(ownerNameProvider.notifier)
                            .update((state) => ownerName);
                      }
                    });

                    return MiniAccountInfo(
                      accountData: data?.owner,
                      onTapMore: widget.onTapMore,
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

  void selectDays(
    List<Day?> sun,
    List<Day?> mon,
    List<Day?> tue,
    List<Day?> wed,
    List<Day?> thu,
    List<Day?> fri,
    List<Day?> sat,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      List<Day?> newListOfDays;

      switch (widget.gSelectedDay) {
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
        default:
          // If the selected day is not valid, use an empty list
          newListOfDays = [];
          break;
      }

      if (mounted) {
        setState(() {
          widget.listOfDayState = newListOfDays;
        });
      }
    });
  }
}

// Navigate to the SummaryScreen when a day is tapped
void onTap(Day? day, String status, context) {
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
      start: day.start,
      end: day.end,
      room: day.room,
    ),
  );
}
