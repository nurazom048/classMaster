// ignore_for_file: avoid_print, non_constant_identifier_names, must_be_immutable, unused_local_variable

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/helper/constant/constant.dart';
import 'package:table/models/ClsassDetailsModel.dart';
import 'package:table/ui/add_eddit_remove/addPriode.dart';
import 'package:table/ui/add_eddit_remove/add_class.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/Rutin_request/rutin_request.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/full_rutin_ui/view_more_details.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/sunnary/summary_screen.dart';
import 'package:table/ui/bottom_items/Home/home_req/priode_reuest.dart';
import 'package:table/ui/server/rutinReq.dart';
import 'package:table/widgets/AccoundCardRow.dart';
import 'package:table/widgets/Alart.dart';
import 'package:table/widgets/TopBar.dart';
import 'package:table/widgets/class_contaner.dart';
import 'package:table/widgets/days_container.dart';
import 'package:table/widgets/priodeContaner.dart';
import 'package:http/http.dart' as http;
import 'package:table/widgets/progress_indicator.dart';
import 'package:table/widgets/text%20and%20buttons/empty.dart';
import 'package:table/widgets/text%20and%20buttons/hedingText.dart';
import 'package:table/widgets/text%20and%20buttons/squareButton.dart';

class FullRutineView extends ConsumerWidget {
  String rutinId;
  String rutinName;
  FullRutineView({super.key, required this.rutinId, required this.rutinName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                      return CustomTopBar(valu!.rutin_name,
                          acction: IconButton(
                              onPressed: () =>
                                  _showModalBottomSheet(context, rutinId, valu),
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
                              bool permition = data == null
                                  ? true
                                  : data.isOwnwer == true ||
                                      data.isOwnwer == true;
                              var Classss = data?.classes;
                              var Priodes = data?.priodes ?? [];
                              int priodelenght = Priodes.length;
                              print("data!.cap10.toString()");
                              print(data?.cap10s.length ?? "no daa");
                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListOfPriodes(Priodes, rutinId, permition),

                                    //
                                    ListOfDays(Classss?.sunday ?? [], permition,
                                        priodelenght),

                                    ListOfDays(Classss?.monday ?? [], permition,
                                        priodelenght),
                                    ListOfDays(Classss?.thursday ?? [],
                                        permition, priodelenght),
                                    ListOfDays(Classss?.wednesday ?? [],
                                        permition, priodelenght),
                                    ListOfDays(Classss?.thursday ?? [],
                                        permition, priodelenght),
                                    ListOfDays(Classss?.friday ?? [], permition,
                                        priodelenght),
                                    ListOfDays(Classss?.saturday ?? [],
                                        permition, priodelenght),
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
                    print(data?.owener.username);
                    return data != null
                        ? AccountCardRow(accountData: data.owener)
                        : const CircularProgressIndicator();
                  },
                ),
              ]),
        ),
      ),
    );
  }

  //
  void _showModalBottomSheet(BuildContext context, id, var valu) {
    Future chackStatus() async {
      // Obtain shared preferences.
      final prefs = await SharedPreferences.getInstance();
      final String? getToken = prefs.getString('Token');
      try {
        final response = await http.get(
            Uri.parse('${Const.BASE_URl}/rutin/save/:$rutinId/chack'),
            headers: {'Authorization': 'Bearer $getToken'});

        if (response.statusCode == 200) {
          final res = json.decode(response.body);
        }
      } catch (e) {
        throw Exception('Failed to load data');
      }
    }

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Colors.grey[200],
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
              ),
              child: Consumer(builder: (context, ref, _) {
                final chackStatus = ref.read(chackStatusUser_provider(rutinId));

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    chackStatus.when(
                        data: (data) {
                          print(data.isCaptain.toString());
                          bool isSave = data.isSave;
                          bool isOwner = data.isOwner;
                          bool isCapten = data.isCaptain;
                          return data != null
                              ? Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SqureButton(
                                          icon: Icons.people_rounded,
                                          inActiveIcon: Icons.telegram,
                                          inActiveText: "Send Join request",
                                          text: 'Members',
                                          status: false,
                                        ),
                                        SqureButton(
                                          icon: Icons.bookmark_added,
                                          inActiveIcon:
                                              Icons.bookmark_add_sharp,
                                          text: 'Save',
                                          inActiveText: "add to save",
                                          status: isSave,
                                        ),
                                        SqureButton(
                                          icon: Icons.more_horiz,
                                          //  inActiveIcon: Icons.more_vert,
                                          text: 'view more',

                                          ontap: () => Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              fullscreenDialog: true,
                                              builder: (context) =>
                                                  ViewMorepage(rutinId),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(height: 20),
                                    isCapten || isOwner
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SqureButton(
                                                icon: Icons.add,
                                                text: "Add Priode",
                                                ontap: () => Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                    fullscreenDialog: true,
                                                    builder: (context) =>
                                                        AppPriodePage(
                                                            rutinId: rutinId),
                                                  ),
                                                ),
                                              ),
                                              SqureButton(
                                                icon: Icons.add,
                                                text: "Add Class",
                                                ontap: () => Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                    fullscreenDialog: true,
                                                    builder: (context) =>
                                                        AppPriodePage(
                                                            rutinId: rutinId),
                                                  ),
                                                ),
                                              ),
                                              const SqureButton(
                                                  icon: Icons.person_add_alt_1,
                                                  text: "Add captens"),
                                            ],
                                          )
                                        : const SizedBox.shrink(),
                                    const Divider(height: 20),
                                    isOwner || isCapten
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              SqureButton(
                                                  icon: Icons.groups_2,
                                                  text: "see all request"),
                                              SqureButton(
                                                  icon: Icons.person_add_alt_1,
                                                  text: "Add members"),
                                            ],
                                          )
                                        : const SizedBox.shrink(),
                                    const Divider(height: 20),
                                    isOwner || isCapten
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              SqureButton(
                                                icon: Icons.person_remove,
                                                text: "remove members",
                                                color: Colors.redAccent,
                                              ),
                                              SqureButton(
                                                icon: Icons.person_remove,
                                                color: Colors.redAccent,
                                                text: "remove captens",
                                              ),
                                              SqureButton(
                                                icon: Icons.delete,
                                                text: "Delete",
                                                color: Colors.red,
                                              ),
                                            ],
                                          )
                                        : const SizedBox.shrink(),
                                  ],
                                )
                              : Text("Login requaind ");
                        },
                        loading: () => const Progressindicator(),
                        error: (error, stackTrace) =>
                            Alart.handleError(context, error)),
                  ],
                );
              }),
            ),
          );
        });
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
                  onLongPress: () =>
                      ShowProdeButtomAction(context, day[index]?.id),

                  // ontap to go summay page..//
                  onTap: permition == true
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

  Future<dynamic> ShowProdeButtomAction(BuildContext context, classId) {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text(" Do you want to.. ",
            style: TextStyle(fontSize: 22, color: Colors.black87)),
        actions: [
          CupertinoActionSheetAction(
              child: const Text("Eddit"), // go to eddit

              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => AddClass(
                              rutinId: "rutinId",
                              classId: classId,
                              isEdit: true,
                            )));
              }),
          CupertinoActionSheetAction(
            child: const Text("Remove", style: TextStyle(color: Colors.red)),
            onPressed: () {
              ClassesRequest().deleteClass(context, classId);
              print(classId);
              Navigator.pop(context);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text("cancel"),
          onPressed: () => Navigator.pop(context),
        ),
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

                onLongPress: () =>
                    logPressOnPriode(context, Priodes[index]!.id),
              ),
      ),
    );
  }

  Future<dynamic> logPressOnPriode(BuildContext context, priodeId) {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text(" Do you want to.. ",
            style: TextStyle(fontSize: 22, color: Colors.black87)),
        actions: [
          CupertinoActionSheetAction(
            child: const Text("Remove", style: TextStyle(color: Colors.red)),
            onPressed: () {
              PriodeRequest().deletePriode(context, priodeId);
              print(priodeId);
              Navigator.pop(context);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text("cancel"),
          onPressed: () => Navigator.pop(context),
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

  //
}
