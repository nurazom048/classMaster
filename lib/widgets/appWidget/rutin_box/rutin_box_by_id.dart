// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/models/rutins/rutins.dart';
import 'package:table/widgets/appWidget/appText.dart';
import 'package:table/widgets/appWidget/buttons/Expende_button.dart';
import 'package:table/widgets/appWidget/buttons/capsule_button.dart';
import 'package:table/widgets/appWidget/rutin_box/rutin_card_row.dart';
import 'package:table/widgets/mini_account_row.dart';

import '../../../core/dialogs/Alart_dialogs.dart';
import '../../../models/Account_models.dart';
import '../../../models/ClsassDetailsModel.dart';
import '../../../ui/bottom_items/Home/full_rutin/controller/chack_status_controller.dart';
import '../../../ui/bottom_items/Home/full_rutin/sunnary/summat_screens/summary_screen.dart';
import '../../../ui/server/rutinReq.dart';
import '../dottted_divider.dart';
import '../selectDayRow.dart';

class RutinBoxById extends StatefulWidget {
  final dynamic onTap;

  final String rutinNmae;
  final String rutinId;
  final dynamic onTapMore;
  const RutinBoxById({
    super.key,
    this.onTap,
    required this.rutinNmae,
    required this.onTapMore,
    required this.rutinId,
  });

  @override
  State<RutinBoxById> createState() => _RutinBoxState();
}

class _RutinBoxState extends State<RutinBoxById> {
  List<Day?> listOfDays = [];
  late int lenght = 0;
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      //! providers
      final chackStatus =
          ref.watch(chackStatusControllerProvider(widget.rutinId));
      //? Provider
      final rutinDetals = ref.watch(rutins_detalis_provider(widget.rutinId));
      String status = chackStatus.value?.activeStatus ?? '';

      //! notifier
      final chackStatusNotifier =
          ref.watch(chackStatusControllerProvider(widget.rutinId).notifier);
      return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        const MyDivider(),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(widget.rutinNmae).heding(),
              //
              chackStatus.when(
                  data: (data) {
                    if (status == "joined") {
                      return CapsuleButton(
                        "Leave",
                        color: Colors.red,
                        icon: Icons.logout,
                        onTap: () {
                          return Alart.errorAlertDialogCallBack(
                            context,
                            "are you sure you want to leave",
                            onConfirm: (bool isYes) {
                              //  Navigator.pop(context);

                              chackStatusNotifier.leaveMember(context);
                            },
                          );
                        },
                      );
                    } else {
                      return CapsuleButton(
                        status == "not_joined" ? "send request" : status,
                        icon:
                            status == "request_pending" ? null : Icons.telegram,
                        onTap: () {
                          chackStatusNotifier.sendReqController(context);
                        },
                      );
                    }
                  },
                  error: (error, stackTrace) =>
                      Alart.handleError(context, error),
                  loading: () => const Text("data")),
            ],
          ),
        ),

        //
        rutinDetals.when(
            data: (data) {
              if (data == null) return const Text("id null");

              List<Day?> sun = data.classes.sunday;
              List<Day?> mon = data.classes.monday;
              List<Day?> tue = data.classes.tuesday;
              List<Day?> wed = data.classes.wednesday;
              List<Day?> thu = data.classes.thursday;
              List<Day?> fri = data.classes.friday;
              List<Day?> sat = data.classes.saturday;

              return Column(
                children: [
                  SelectDayRow(selectedDay: (selectedDay) {
                    switch (selectedDay) {
                      case 0:
                        setState(() {
                          listOfDays = sun;
                        });

                        break;

                      case 1:
                        setState(() {
                          listOfDays = mon;
                        });

                        break;

                      case 2:
                        setState(() {
                          listOfDays = tue;
                        });

                        break;

                      case 3:
                        setState(() {
                          listOfDays = wed;
                        });

                        break;

                      case 4:
                        setState(() {
                          listOfDays = thu;
                        });

                        break;

                      case 5:
                        setState(() {
                          listOfDays = fri;
                        });

                        break;

                      case 6:
                        setState(() {
                          listOfDays = sat;
                        });

                        break;
                    }
                  }),

                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: List.generate(
                        listOfDays.length,
                        (index) {
                          return listOfDays.isNotEmpty
                              ? RutineCardInfoRow(
                                  isFrist: index == 0,
                                  day: listOfDays[index],
                                  onTap: () => ontap(listOfDays[index]),
                                )
                              : const Text("No Class");
                        },
                      ),
                    ),
                  ),

                  //
                  ExpendedButton(onTap: () {
                    setState(() {
                      if (lenght == listOfDays.length) {
                        lenght = 2;
                      } else {
                        lenght = listOfDays.length;
                      }
                    });
                  }),

                  //
                  MiniAccountInfo(
                      accountData: data.owner, onTapMore: widget.onTapMore),
                  const SizedBox(height: 15)
                ],
              );
            },
            error: (error, stackTrace) => Alart.handleError(context, error),
            loading: () => const Text("data")),
      ]);
    });
  }

  ontap(Day? day) {
    Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => SummaryScreen(
                classId: day?.classId ?? "",
                day: day,
              )),
    );
  }
}
