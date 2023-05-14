// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/widgets/appWidget/app_text.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/widgets/rutin_box/rutin_card_row.dart';
import 'package:table/widgets/appWidget/dottted_divider.dart';
import 'package:table/widgets/mini_account_row.dart';

import '../../../../../../core/dialogs/alart_dialogs.dart';
import '../../../../../../models/class_details_model.dart';
import '../../../../../../sevices/notification services/local_notifications.dart';
import '../../controller/chack_status_controller.dart';
import '../../screen/viewMore/view_more_screen.dart';
import '../../sunnary_section/summat_screens/summary_screen.dart';
import '../../../../../server/rutinReq.dart';
import '../../../../../../widgets/appWidget/select_day_row.dart';
import '../../utils/rutin_dialog.dart';
import '../sceltons/rutinebox_id_scelton.dart';
import '../send_request_button.dart';

//! provider
final gSelectedDayProvider = StateProvider<int>((ref) {
  return DateTime.now().weekday;
});

final listOfDayStateProvider = StateProvider<List<Day?>>((ref) => []);

class RutinBoxById extends ConsumerWidget {
  final String rutinName;
  final String rutinId;
  final dynamic onTapMore;

  const RutinBoxById({
    Key? key,
    required this.rutinName,
    required this.onTapMore,
    required this.rutinId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get providers
    final chackStatus = ref.watch(chackStatusControllerProvider(rutinId));
    final rutinDetails = ref.watch(rutins_detalis_provider(rutinId));
    String status = chackStatus.value?.activeStatus ?? '';
    bool notification_Off = chackStatus.value?.notificationOff ?? false;

    List<Day?> listOfDays = ref.watch(listOfDayStateProvider);
    int gSelectedDay = ref.watch(gSelectedDayProvider);

    // Get notifier
    final chackStatusNotifier =
        ref.watch(chackStatusControllerProvider(rutinId).notifier);

    return Container(
      height: 455,
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
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
                            rutinId: rutinId,
                            rutineName: rutinName,
                          ),
                        ),
                      ),
                      child: AppText(rutinName, fontSize: 22).title(),
                    ),

                    // Notification button or request button
                    chackStatus.when(
                      data: (data) {
                        return SendReqButton(
                          isNotSendRequest: status == "not_joined",
                          isPending: status == "request_pending",
                          isMember: true,
                          notificationOff: notification_Off,
                          sendRequest: () {
                            chackStatusNotifier.sendReqController(context);
                          },
                          showPanel: () {
                            RutinDialog.rutineNotficationSeleect(
                              context,
                              rutinId,
                            );
                          },
                        );
                      },
                      error: (error, stackTrace) =>
                          Alart.handleError(context, error),
                      loading: () => const Text("data"),
                    ),
                  ],
                ),
              ),

              // Divider
              MyDivider(
                padding: const EdgeInsets.symmetric(vertical: 13)
                    .copyWith(bottom: 3),
              ),

              // Select day row
              SelectDayRow(selectedDay: (selectedDay) {
                print("thee day is : $selectedDay");
                ref
                    .watch(gSelectedDayProvider.notifier)
                    .update((state) => selectedDay);
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

                  _selectDays(
                      ref, gSelectedDay, sun, mon, tue, wed, thu, fri, sat);

                  LocalNotification.scheduleNotifications(context, sun);

                  return Container(
                    margin: const EdgeInsets.only(top: 15),
                    constraints: const BoxConstraints(minHeight: 200),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(
                        listOfDays.length,
                        (index) {
                          if (listOfDays.isNotEmpty) {
                            return RutineCardInfoRow(
                              isFrist: index == 0,
                              day: listOfDays[index],
                              onTap: () => onTap(listOfDays[index], context),
                            );
                          } else {
                            return const Text("No Class");
                          }
                        },
                      ),
                    ),
                  );
                },
                error: (error, stackTrace) => Alart.handleError(context, error),
                loading: () => const Text(
                  "______________________________________________",
                ),
              ),

              const SizedBox(height: 5)
            ],
          ),

          // Bottom section
          Column(
            children: [
              MyDivider(
                padding: const EdgeInsets.symmetric(vertical: 10)
                    .copyWith(bottom: 3),
              ),
              rutinDetails.when(
                data: (data) {
                  if (data == null) {}

                  return MiniAccountInfo(
                    accountData: data?.owner,
                    onTapMore: onTapMore,
                  );
                },
                error: (error, stackTrace) => Alart.handleError(context, error),
                loading: () => const AccounScelton(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Navigate to the SummaryScreen when a day is tapped
void onTap(Day? day, context) {
  Navigator.push(
    context,
    CupertinoPageRoute(
      builder: (context) => SummaryScreen(
        classId: day?.classId.id ?? "",
        day: day,
      ),
    ),
  );
}

// Update the list of days to display based on the selected day
void _selectDays(
    WidgetRef ref, selectedDay, List<Day?> sun, mon, tue, wed, thu, fri, sat) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    List<Day?> newListOfDays;

    switch (ref.watch(gSelectedDayProvider)) {
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

    // Only update the state if the component is still mounted
    ref.watch(listOfDayStateProvider.notifier).update((state) => newListOfDays);
  });
}


///////
