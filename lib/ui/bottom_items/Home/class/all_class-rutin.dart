// ignore_for_file: avoid_print, non_constant_identifier_names, must_be_immutable

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table/helper/constant/constant.dart';
import 'package:table/models/Account_models.dart';
import 'package:table/models/ClsassDetailsModel.dart';
import 'package:table/ui/add_eddit_remove/addPriode.dart';
import 'package:table/ui/add_eddit_remove/add_cap10s.page.dart';
import 'package:table/ui/add_eddit_remove/add_class.dart';
import 'package:table/ui/bottom_items/Home/class/class_request/class_request.dart';
import 'package:table/ui/bottom_items/Home/class/sunnary/summary_screen.dart';
import 'package:table/ui/server/rutinReq.dart';
import 'package:table/widgets/AccoundCardRow.dart';
import 'package:table/widgets/Alart.dart';
import 'package:table/widgets/TopBar.dart';
import 'package:table/widgets/class_contaner.dart';
import 'package:table/widgets/days_container.dart';
import 'package:table/widgets/priodeContaner.dart';
import 'package:http/http.dart' as http;
import 'package:table/widgets/text%20and%20buttons/bottomText.dart';
import 'package:table/widgets/text%20and%20buttons/empty.dart';
import 'package:table/widgets/text%20and%20buttons/hedingText.dart';

class AllClassScreen extends ConsumerWidget {
  String rutinId;
  String rutinName;
  AllClassScreen({super.key, required this.rutinId, required this.rutinName});

  String? message;

  // Future chackStatus() async {
  //   // Obtain shared preferences.
  //   final prefs = await SharedPreferences.getInstance();
  //   final String? getToken = prefs.getString('Token');
  //   try {
  //     final response = await http.get(
  //         Uri.parse('${Const.BASE_URl}/rutin/save/:$rutinId/chack'),
  //         headers: {'Authorization': 'Bearer $getToken'});

  //     if (response.statusCode == 200) {
  //       final res = json.decode(response.body);

  //       //  print(res);
  //     } else {
  //       throw Exception('Failed to load data');
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

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
                              icon: const Icon(Icons.more_vert)),
                          ontap: () => Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  fullscreenDialog: true,
                                  builder: (context) =>
                                      AddClass(rutinId: rutinId))));
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
                          const ListOfWeakdays(),

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
                              var Priodes = data?.priodes;
                              print("data!.cap10.toString()");
                              print(data?.cap10s.length ?? "no daa");
                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListOfPriodes(
                                        Priodes ?? [], rutinId, permition),

                                    //
                                    ListOfDays(
                                        Classss?.sunday ?? [], permition),

                                    ListOfDays(
                                        Classss?.monday ?? [], permition),
                                    ListOfDays(
                                        Classss?.thursday ?? [], permition),
                                    ListOfDays(
                                        Classss?.wednesday ?? [], permition),
                                    ListOfDays(
                                        Classss?.thursday ?? [], permition),
                                    ListOfDays(
                                        Classss?.friday ?? [], permition),
                                    ListOfDays(
                                        Classss?.saturday ?? [], permition),
                                  ]);
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                HedingText(" Owner Account"),

                ///
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HedingText("  cap10s"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  fullscreenDialog: true,
                                  builder: (context) =>
                                      AddCap10sPage(rutinId: rutinId)));
                        },
                        child: const Text(" Add Cap10  ")),
                  ],
                ),

                //
                rutinDetals.when(
                  data: (data) {
                    print(data!.isOwnwer.toString());
                    List<AccountModels> cap10 = data.cap10s;
                    double lenghts = double.parse(cap10.length.toString());
                    return SizedBox(
                      width: 500,
                      height: 130 * lenghts,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cap10.length,
                        itemBuilder: (context, index) {
                          return AccountCardRow(accountData: cap10[index]);
                        },
                      ),
                    );
                  },
                  error: (error, stackTrace) => Text(error.toString()),
                  loading: () => const CircularProgressIndicator(),
                ),

                //
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HedingText(" Members"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  fullscreenDialog: true,
                                  builder: (context) =>
                                      AddCap10sPage(rutinId: rutinId)));
                        },
                        child: const Text(" Members  ")),
                  ],
                ),

                //
                rutinDetals.when(
                  data: (data) {
                    List<AccountModels> cap10 = data?.cap10s ?? [];
                    double lenghts = double.parse(cap10.length.toString());
                    return SizedBox(
                      width: 500,
                      height: 130 * lenghts,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cap10.length,
                        itemBuilder: (context, index) {
                          return AccountCardRow(accountData: cap10[index]);
                        },
                      ),
                    );
                  },
                  error: (error, stackTrace) => Text(error.toString()),
                  loading: () => const CircularProgressIndicator(),
                ),
              ]),

          //
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
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  valu.isOwnwer == true || valu.isOwnwer == true
                      ? BottomText("Add Priode",
                          onPressed: () => Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  fullscreenDialog: true,
                                  builder: (context) =>
                                      AppPriodePage(rutinId: rutinId))))
                      : Container(),
                  valu.isOwnwer == true || valu.isOwnwer == true
                      ? ListTile(
                          leading: const Icon(Icons.add),
                          title: const Text("Add Class ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    fullscreenDialog: true,
                                    builder: (context) =>
                                        AddClass(rutinId: rutinId)));
                          })
                      : Container(),
                  ListTile(
                      leading: const Icon(Icons.save),
                      title: Text(valu.isSaved == false ? "Saved" : " unsave",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      onTap: () async {
                        print("ontap");
                        print("save:${valu.isSaved}");
                        valu.isSaved == true
                            ? Rutin_Req().unSaveRutin(rutinId)
                            : chackStatus();
                      }),
                  valu.isOwnwer == true
                      ? ListTile(
                          leading: const Icon(Icons.delete, color: Colors.red),
                          title: const Text("Delete",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red)),
                          onTap: () {})
                      : Container()
                ],
              ),
            ),
          );
        });
  }
}

// ///.... onlong press
// void onLongpress_class(context, classId, message) {
//   showModalBottomSheet(
//     backgroundColor: Colors.transparent,
//     context: context,
//     builder: (context) => Container(
//       decoration: BoxDecoration(
//           color: Colors.white, borderRadius: BorderRadius.circular(12)),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Padding(
//               padding: EdgeInsets.all(16.0),
//               child: Text("Do you want to..",
//                   style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black))),

//           BottomText(
//             "Edit",
//             onPressed: () => Navigator.push(
//               context,
//               CupertinoPageRoute(
//                   fullscreenDialog: true,
//                   builder: (context) => AddClass(
//                         rutinId: "rutinId",
//                         classId: classId,
//                         isEdit: true,
//                       )),
//             ),
//           ),

//           //.... remove
//           BottomText(
//             "Remove",
//             color: CupertinoColors.destructiveRed,
//             onPressed: () => ClassesRequest().deleteClass(context, classId),
//           ),
//           //.... Cancel
//           BottomText("Cancel"),
//         ],
//       ),
//     ),
//   );
// }
//.. list of days ...///

class ListOfDays extends StatelessWidget {
  List<Day?> day;
  ListOfDays(this.day, this.permition, {super.key});
  bool permition;

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

            onPressed: () {},
          ),
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
              onTap: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => AppPriodePage(
                        rutinId: rutinId,
                      ),
                    ),
                  )),
    ));
  }
}
//

class ListOfWeakdays extends StatelessWidget {
  const ListOfWeakdays({super.key});

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
            ),
          ),
        ),
      ],
    );
  }

  //
}
