import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Add/screens/add_class_screen.dart';

import '../../../../../../core/dialogs/alart_dialogs.dart';
import '../../../../../../models/class_details_model.dart';
import '../../../../../../sevices/notification services/local_notifications.dart';
import '../../../../../../widgets/hedding_row.dart';
import '../../../../../server/rutinReq.dart';
import '../../../../Add/screens/add_priode.dart';
import '../../controller/chack_status_controller.dart';
import '../../request/priode_request.dart';
import '../../sunnary_section/summat_screens/summary_screen.dart';
import '../../utils/logngPress.dart';
import '../../widgets/class_row.dart';
import '../../widgets/priode_widget.dart';

final totalPriodeCountProvider = StateProvider<int>((ref) => 0);

class ClassListPage extends StatefulWidget {
  final String rutinId;
  final String rutinName;
  const ClassListPage(
      {super.key, required this.rutinId, required this.rutinName});

  @override
  State<ClassListPage> createState() => _ClassListPageState();
}

int? totalMemberCount;
int? totalPriodeCount;

class _ClassListPageState extends State<ClassListPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      print(widget.rutinId);
      final rutinDetals = ref.watch(rutins_detalis_provider(widget.rutinId));
      final allPriode = ref.watch(allPriodeProvider(widget.rutinId));

      //
      final chackStatus =
          ref.watch(chackStatusControllerProvider(widget.rutinId));
      bool notification_Off = chackStatus.value?.notificationOff ?? false;

      return Scaffold(
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: [
            HeddingRow(
              hedding: "Priode List",
              secondHeading: "$totalPriodeCount  priode",
              margin: EdgeInsets.zero,
              buttonText: "Add Priode",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppPriodePage(
                      rutinId: widget.rutinId,
                      rutinName: widget.rutinName,
                      isEdit: false,
                      totalPriode: totalPriodeCount ?? 0,
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: 140,
              child: allPriode.when(
                  data: (data) {
                    return data.fold(
                        (l) => Alart.handleError(context, l.message), (r) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: r.priodes.length,
                        itemBuilder: (context, index) {
                          String priodeId = r.priodes[index].id;

                          int length = r.priodes.length;

                          if (totalPriodeCount == null) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (!mounted) {}
                              // Add Your Code here.
                              setState(() {
                                totalPriodeCount = length;
                              });

                              ref
                                  .watch(totalPriodeCountProvider.notifier)
                                  .update((state) => length);
                            });
                          }

                          return PriodeWidget(
                            priodeNumber: r.priodes[index].priodeNumber,
                            startTime: r.priodes[index].startTime,
                            endTime: r.priodes[index].endTime,
                            //
                            onLongpress: () {
                              PriodeAlart.logPressOnPriode(context, priodeId,
                                  widget.rutinId, r.priodes[index]);
                            },
                          );
                        },
                      );
                    });
                  },
                  error: (error, stackTrace) =>
                      Alart.handleError(context, error),
                  loading: () => const Text("loding")),
            ),
            HeddingRow(
              hedding: "Class List",
              secondHeading: "$totalMemberCount  classes",
              margin: EdgeInsets.zero,
              buttonText: "Add Class",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddClassScreen(
                      routineId: widget.rutinId,
                      isEdit: false,
                    ),
                  ),
                );
              },
            ),
            SizedBox(
                height: 300,
                child: rutinDetals.when(
                  data: (data) {
                    if (data == null) {
                      return const Text("Null");
                    }
                    // notification
                    if (notification_Off == false) {
                      print("CAll sudule notification");

                      LocalNotification.scheduleNotifications(
                          data.classes.allClass);
                    }

                    return ListView.builder(
                      itemCount: data.classes.allClass.length,
                      itemBuilder: (context, index) {
                        Day day = data.classes.allClass[index];
                        int length = data.classes.allClass.length;

                        if (totalMemberCount == null) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            // Add Your Code here.
                            setState(() => totalMemberCount = length);
                          });
                        }

                        return ClassRow(
                          id: day.id,
                          className: day.classId.name,

                          //
                          onLongPress: () {
                            PriodeAlart.logPressClass(
                              context,
                              classId: data.classes.allClass[index].classId.id,
                              rutinId: widget.rutinId,
                            );
                          },

                          ontap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => SummaryScreen(
                                  classId: day.classId.id,
                                  day: day,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  error: (error, stackTrace) =>
                      Alart.handleError(context, error),
                  loading: () => const Text("Loding"),
                )),
          ],
        ),
      );
    });
  }
}
