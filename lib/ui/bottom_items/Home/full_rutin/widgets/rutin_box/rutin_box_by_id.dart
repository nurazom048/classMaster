// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:table/models/rutins/rutins.dart';
import 'package:table/ui/bottom_items/Account/widgets/my_divider.dart';
import 'package:table/widgets/appWidget/appText.dart';
import 'package:table/widgets/appWidget/buttons/Expende_button.dart';
import 'package:table/widgets/appWidget/buttons/capsule_button.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/widgets/rutin_box/rutin_card_row.dart';
import 'package:table/widgets/mini_account_row.dart';

import '../../../../../../core/dialogs/Alart_dialogs.dart';
import '../../../../Account/models/Account_models.dart';
import '../../../../../../models/ClsassDetailsModel.dart';
import '../../controller/chack_status_controller.dart';
import '../../screen/view_more_screen.dart';
import '../../sunnary/summat_screens/summary_screen.dart';
import '../../../../../server/rutinReq.dart';
import '../../../../../../widgets/appWidget/dottted_divider.dart';
import '../../../../../../widgets/appWidget/selectDayRow.dart';

class RutinBoxByIdSkelton extends StatelessWidget {
  const RutinBoxByIdSkelton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;

    return Container(
      height: 450,
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        period: const Duration(seconds: 2),
        enabled: true,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 22,
                  width: width * 0.3,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                Container(
                  height: 30,
                  width: width * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Divider(
              thickness: 2,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              7,
              (index) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  height: 20,
                  width: width * 0.07,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),
          Container(
            alignment: Alignment.center,
            constraints: const BoxConstraints(minHeight: 200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(
                3,
                (index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    margin: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Divider(
              thickness: 2,
              color: Colors.black,
            ),
          ),
          // const SizedBox(height: 16),
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: Colors.black,
              ),
              const SizedBox(width: 10),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // name ad user name
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      height: 20,
                      width: MediaQuery.of(context).size.width / 3,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      height: 18,
                      width: MediaQuery.of(context).size.width / 3,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ]),
              const Spacer(),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.black,
                  ))
            ],
          ),
        ]),
      ),
    );
  }
}

class RutinBoxById extends StatefulWidget {
  final dynamic onTap;

  final String rutinName;
  final String rutinId;
  final dynamic onTapMore;
  const RutinBoxById({
    super.key,
    this.onTap,
    required this.rutinName,
    required this.onTapMore,
    required this.rutinId,
  });

  @override
  State<RutinBoxById> createState() => _RutinBoxState();
}

class _RutinBoxState extends State<RutinBoxById> {
  List<Day?> listOfDays = [];
  late int lenght = 0;

  ///
  ///
  //    List<Day?> sun = [];
  // List<Day?> mon = [];
  // List<Day?> tue = [];
  // List<Day?> wed = [];
  // List<Day?> thu = [];
  // List<Day?> fri = [];
  // List<Day?> sat= [];

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
      return Container(
        height: 455,
        margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ViewMore(rutinId: widget.rutinId)),
                        );
                      },
                      child: AppText(widget.rutinName, fontSize: 22).title(),
                    ),
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
                              icon: status == "request_pending"
                                  ? null
                                  : Icons.telegram,
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

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Divider(
                  thickness: 2,
                  color: Colors.blue.shade200,
                ),
              ),

              // SelectDayRow(selectedDay: (selectedDay) {}),
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

                        const SizedBox(height: 15),
                        Container(
                          constraints: const BoxConstraints(minHeight: 200),
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

                        ExpendedButton(onTap: () {
                          setState(() {
                            if (lenght == listOfDays.length) {
                              lenght = 2;
                            } else {
                              lenght = listOfDays.length;
                            }
                          });
                        }),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          child: Divider(
                            thickness: 2,
                            color: Colors.blue.shade200,
                          ),
                        ),
                        //

                        MiniAccountInfo(
                            accountData: data.owner,
                            onTapMore: widget.onTapMore),
                      ],
                    );
                  },
                  error: (error, stackTrace) =>
                      Alart.handleError(context, error),
                  loading: () => const Text("data")),
            ]),
      );
    });
  }

  ontap(Day? day) {
    Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => SummaryScreen(
                classId: day?.classId.id ?? "",
                day: day,
              )),
    );
  }
}
