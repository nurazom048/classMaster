// ignore_for_file: avoid_print, non_constant_identifier_names, must_be_immutable, unused_local_variable

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
  String rutinId;
  String rutinName;
  FullRutineView({super.key, required this.rutinId, required this.rutinName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //! providers
    final chackStatus = ref.watch(chackStatusControllerProvider(rutinId));
    final rutinDetals = ref.watch(rutins_detalis_provider(rutinId));
    print("RutinId:  $rutinId");

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //...... Appbar.......!!
                rutinDetals.when(
                    data: (valu) {
                      return CustomTopBar("",
                          acction: IconButton(
                              onPressed: () =>
                                  RutinDialog.ChackStatusUser_BottomSheet(
                                      context, rutinId),
                              icon: const Icon(Icons.more_vert)), ontap: () {
                        ref
                            .read(isEditingModd.notifier)
                            .update((state) => !state);
                      });
                    },
                    loading: () => CustomTopBar(rutinName),
                    error: (error, stackTrace) =>
                        Alart.handleError(context, error)),

                //.....Priode rows.....//
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListOfWeakdays(rutinId: rutinId),

                          ///.. show all priodes  class

                          rutinDetals.when(
                            loading: () => const Center(
                                child: CircularProgressIndicator()),
                            error: (error, stackTrace) =>
                                Alart.handleError(context, error),
                            data: (data) {
                              var Classss = data?.classes;
                              var Priodes = data?.priodes ?? [];
                              int priodelenght = Priodes.length;
                              print("data!.cap10.toString()");

                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListOfPriodes(Priodes, rutinId, false),

                                    //
                                    ListOfDays(Classss?.sunday ?? [], false,
                                        priodelenght),

                                    ListOfDays(Classss?.monday ?? [], false,
                                        priodelenght),
                                    ListOfDays(Classss?.thursday ?? [], false,
                                        priodelenght),
                                    ListOfDays(Classss?.wednesday ?? [], false,
                                        priodelenght),
                                    ListOfDays(Classss?.thursday ?? [], false,
                                        priodelenght),
                                    ListOfDays(Classss?.friday ?? [], false,
                                        priodelenght),
                                    ListOfDays(Classss?.saturday ?? [], false,
                                        priodelenght),
                                    // ListOfDays(Classss?.saturday ?? [],
                                    //     false, priodelenght),
                                  ]);
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                HedingText(" Owner Account"),

                rutinDetals.when(
                  error: (error, stackTrace) => Text(error.toString()),
                  loading: () => const CircularProgressIndicator(),
                  data: (data) {
                    return data != null
                        ? AccountCardRow(accountData: data.owner)
                        : const CircularProgressIndicator();
                  },
                ),
              ]),
        ),
      ),
    );
  }
}

class ListOfDays extends StatelessWidget {
  List<Day?> day;
  ListOfDays(this.day, this.permition, this.priodeLenght, {super.key});
  bool permition;
  int priodeLenght;
  String? rutinId;

  @override
  Widget build(BuildContext context) {
    return day.isEmpty
        ? const SizedBox(height: 100, width: 200, child: Text("No Class"))
        : Row(
            children: List.generate(
              day.length,
              (index) => ClassContainer(
                  instractorname: day[index]?.instuctorName,
                  roomnum: day[index]?.room,
                  subCode: day[index]?.subjectcode,
                  start: day[index]!.start,
                  end: day[index]!.end,
                  startTime: day[index]!.startTime,
                  endTime: day[index]?.endTime,
                  weakday: day[index]?.weekday,
                  classname: day[index]?.name,
                  previous_end:
                      index == 0 ? day[index]!.end : day[index - 1]!.end,
                  weakdayIndex: day[index]?.weekday,

                  //
                  priodeLenght: priodeLenght,
                  isLast: day.length - 1 == index,
                  onLongPress: () => LongPressDialog.long_press_to_class(
                      context, day[index]?.id),

                  // ontap to go summay page..//
                  onTap: false == true
                      ? () => Navigator.push(
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
                          )
                      : () {}),
            ),
          );
  }
}

class ListOfPriodes extends StatelessWidget {
  List<Priode?> Priodes;
  String rutinId;
  ListOfPriodes(this.Priodes, this.rutinId, this.permition, {super.key});
  bool permition;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        Priodes.length,
        (index) => Priodes.isEmpty
            ? const Text("No Priode")
            : PriodeContaner(
                startTime: Priodes[index]!.startTime,
                endtime: Priodes[index]!.endTime,
                priode: index,
                lenght: 1,

                // ontap to go summay page..//

                onLongPress: () => LongPressDialog.logPressOnPriode(
                    context, Priodes[index]!.id, rutinId),
              ),
      ),
    );
  }
}

//

class ListOfWeakdays extends StatelessWidget {
  ListOfWeakdays({super.key, this.rutinId});

  String? rutinId;

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
