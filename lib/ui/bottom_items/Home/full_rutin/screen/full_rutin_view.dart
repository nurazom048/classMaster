import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/models/ClsassDetailsModel.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/controller/chack_status_controller.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/screen/dailog/logngPress.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/screen/dailog/rutin_dialog.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/sunnary/summat_screens/summary_screen.dart';
import 'package:table/ui/server/rutinReq.dart';
import 'package:table/widgets/AccoundCardRow.dart';
import 'package:table/widgets/TopBar.dart';
import 'package:table/widgets/class_contaner.dart';
import 'package:table/widgets/days_container.dart';
import 'package:table/widgets/priodeContaner.dart';
import 'package:table/widgets/text%20and%20buttons/empty.dart';
import 'package:table/widgets/text%20and%20buttons/hedingText.dart';
import '../../../../../core/dialogs/Alart_dialogs.dart';

class FullRutineView extends ConsumerWidget {
  const FullRutineView(
      {super.key, required this.rutinId, required this.rutinName});

  final String rutinId;
  final String rutinName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //! providers
    final rutinDetals = ref.watch(rutins_detalis_provider(rutinId));
    // ignore: avoid_print
    print("RutinId:  $rutinId");

    return SafeArea(
      child: Scaffold(
        body: Scrollbar(
          thickness: 10,
          radius: const Radius.circular(10),
          scrollbarOrientation: ScrollbarOrientation.left,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //...... Appbar.......!!
                  CustomTopBar(
                    rutinName,
                    acction: IconButton(
                        onPressed: () {
                          RutinDialog.ChackStatusUser_BottomSheet(
                              context, rutinId);
                        },
                        icon: const Icon(Icons.more_vert)),
                    // ontap: () => ref
                    //     .read(isEditingModd.notifier)
                    //     .update((state) => !state)
                  ),

                  //.....Priode rows.....//
                  Scrollbar(
                    thickness: 10,
                    radius: const Radius.circular(10),
                    scrollbarOrientation: ScrollbarOrientation.top,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          padding: const EdgeInsets.only(left: 6, right: 30),
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListOfWeakdays(rutinId: rutinId),

                              ///.. show all priodes  class

                              rutinDetals.when(
                                data: (data) {
                                  var classss = data?.classes;

                                  //? priodes
                                  var priodes = data?.priodes ?? [];
                                  var endPriodeNumber = priodes.isEmpty
                                      ? 0
                                      : priodes[priodes.length - 1]
                                          .priode_number;

                                  return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ListOfPriodes(priodes, rutinId),

                                        //
                                        ListOfDays(classss?.sunday ?? [],
                                            endPriodeNumber, rutinId),

                                        ListOfDays(classss?.monday ?? [],
                                            endPriodeNumber, rutinId),
                                        ListOfDays(classss?.tuesday ?? [],
                                            endPriodeNumber, rutinId),
                                        ListOfDays(classss?.wednesday ?? [],
                                            endPriodeNumber, rutinId),
                                        ListOfDays(classss?.thursday ?? [],
                                            endPriodeNumber, rutinId),
                                        ListOfDays(classss?.friday ?? [],
                                            endPriodeNumber, rutinId),
                                        ListOfDays(classss?.saturday ?? [],
                                            endPriodeNumber, rutinId),
                                      ]);
                                },
                                loading: () => const Center(
                                    child: CircularProgressIndicator()),
                                error: (error, stackTrace) =>
                                    Alart.handleError(context, error),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  HedingText("    Owner Account"),
                  rutinDetals.when(
                    error: (error, stackTrace) => Text(error.toString()),
                    loading: () => const CircularProgressIndicator(),
                    data: (data) {
                      if (data != null) {
                        return AccountCardRow(accountData: data.owner);
                      }
                      return const Text("data");
                    },
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}

class ListOfDays extends ConsumerWidget {
  const ListOfDays(this.day, this.priodeLenght, this.rutinId, {super.key});
  final List<Day?> day;
  final int priodeLenght;
  final String rutinId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (day.isEmpty) {
      return const SizedBox(height: 100, width: 200, child: Text("  No Class"));
    } else {
      //! provider
      final chackStatus = ref.watch(chackStatusControllerProvider(rutinId));
      return Row(
        children: List.generate(
          day.length,
          (index) => ClassContainer(
              instractorname: day[index]?.instuctorName,
              roomnum: day[index]?.room,
              subCode: day[index]?.subjectcode,
              start: day[index]!.start,
              end: day[index]!.end,
              startTime: day[index]?.startTime,
              endTime: day[index]?.endTime,
              weakday: day[index]?.weekday,
              classname: day[index]?.name,
              previous_end: index == 0 ? day[index]!.end : day[index - 1]!.end,
              weakdayIndex: day[index]?.weekday,

              //
              priodeLenght: priodeLenght,
              isLast: day.length - 1 == index,
              onLongPress: () {
                return chackStatus.whenData((value) {
                  if (value.isCaptain || value.isOwner) {
                    LongPressDialog.long_press_to_class(
                        context, day[index]?.id);
                  }
                });
              },

              // ontap to go summay page..//
              onTap: () {
                return chackStatus.whenData((value) {
                  print(value.isCaptain);
                  if (value.isCaptain == true || value.isOwner == true) {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => SummaryScreen(
                          classId: day[index]!.id,
                          istractorName: day[index]!.instuctorName,
                          roomNumber: day[index]!.room,
                          subjectCode: day[index]!.subjectcode,
                        ),
                      ),
                    );
                  }
                });
              }),
        ),
      );
    }
  }
}

class ListOfPriodes extends StatelessWidget {
  const ListOfPriodes(this.priodes, this.rutinId, {super.key});
  final List<Priode?> priodes;
  final String rutinId;
  @override
  Widget build(
    BuildContext context,
  ) {
    return Row(
      children: List.generate(
        priodes.isEmpty ? 1 : priodes.length,
        (index) {
          if (priodes.isEmpty) {
            return const SizedBox(
                height: 100, child: Center(child: Text("   No Priode")));
          } else {
            return Consumer(builder: (context, ref, _) {
              //! provider
              final chackStatus =
                  ref.watch(chackStatusControllerProvider(rutinId));
              return PriodeContaner(
                startTime: priodes[index]!.startTime,
                endtime: priodes[index]!.endTime,
                priode: priodes[index]?.priode_number,
                lenght: 1,
                index: index,
                previusPriode:
                    priodes[index == 0 ? index : index - 1]?.priode_number,

                // ontap to go summay page..//

                onLongPress: () {
                  return chackStatus.whenData((value) {
                    if (value.isCaptain || value.isOwner) {
                      LongPressDialog.logPressOnPriode(
                          context, priodes[index]!.id, rutinId);
                    }
                  });
                },
              );
            });
          }
        },
      ),
    );
  }
}

//

class ListOfWeakdays extends StatelessWidget {
  const ListOfWeakdays({super.key, this.rutinId});

  final String? rutinId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Empty(corner: true),
        Column(
          children: List.generate(
            7,
            (indexofdate) => DaysContaner(
              indexofdate: indexofdate,
              rutinId: rutinId,
            ),
          ),
        ),
      ],
    );
  }
}
