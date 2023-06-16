// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:table/core/component/loaders.dart';
import 'package:table/ui/bottom_items/Add/screens/add_class_screen.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/screen/viewMore/view_more_screen.dart';

import '../../../../../../core/dialogs/alart_dialogs.dart';
import '../../../../../../models/class_details_model.dart';
import '../../../../../../sevices/notification services/local_notifications.dart';
import '../../../../../../widgets/hedding_row.dart';
import '../../../../../server/rutinReq.dart';
import '../../../../Add/screens/add_priode.dart';
import '../../controller/chack_status_controller.dart';
import '../../request/priode_request.dart';
import '../../sunnary_section/summat_screens/summary_screen.dart';
import '../../utils/logng_press.dart';
import '../../widgets/class_row.dart';
import '../../widgets/priode_widget.dart';

final totalPriodeCountProvider = StateProvider<int>((ref) => 0);
final totalClassCountProvider = StateProvider<int>((ref) => 0);

class ClassListPage extends StatelessWidget {
  final String rutinId;
  final String rutinName;
  const ClassListPage(
      {super.key, required this.rutinId, required this.rutinName});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      print(rutinId);

      //! provider
      final rutinDetals = ref.watch(rutins_detalis_provider(rutinId));
      final allPriode = ref.watch(allPriodeProvider(rutinId));
      final totalPriode = ref.watch(totalPriodeCountProvider);
      final totalClass = ref.watch(totalClassCountProvider);

      // notifiers
      final chackStatus = ref.watch(chackStatusControllerProvider(rutinId));
      // String status = chackStatus.value?.activeStatus ?? '';

      bool notificationOff = chackStatus.value?.notificationOff ?? false;

      final totalPriodeNotifier = ref.watch(totalPriodeCountProvider.notifier);
      final totalClassNotifier = ref.watch(totalClassCountProvider.notifier);

      return Scaffold(
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: [
            //-----------------------   "Priode Listt" -------------------------//

            HeddingRow(
              hedding: "Priode List",
              secondHeading: "$totalPriode priode${totalPriode > 1 ? "s" : ''}",
              margin: EdgeInsets.zero,
              buttonText: "Add Priode",
              onTap: () => Get.to(
                () => AppPriodePage(
                  rutinId: rutinId,
                  rutinName: rutinName,
                  isEdit: false,
                  totalPriode: totalPriode,
                ),
              ),
            ),
            SizedBox(
              height: 140,
              child: allPriode.when(
                data: (data) {
                  return data.fold((l) => Alart.handleError(context, l.message),
                      (data) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: data.priodes.length,
                      itemBuilder: (context, index) {
                        String priodeId = data.priodes[index].id;
                        int length = data.priodes.length;

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          totalPriodeNotifier.update((state) => length);
                        });

                        return PriodeWidget(
                          priodeNumber: data.priodes[index].priodeNumber,
                          startTime: data.priodes[index].startTime,
                          endTime: data.priodes[index].endTime,
                          //
                          onLongpress: () {
                            PriodeAlart.logPressOnPriode(context, priodeId,
                                rutinId, data.priodes[index]);
                          },
                        );
                      },
                    );
                  });
                },
                error: (error, stackTrace) => Alart.handleError(context, error),
                loading: () => Loaders.center(),
              ),
            ),

            //-----------------------   "Class List" -------------------------//

            HeddingRow(
              hedding: "Class List",
              secondHeading: "$totalClass classe${totalClass > 1 ? "s" : ''}",
              margin: const EdgeInsets.only(top: 10),
              buttonText: "Add Class",
              onTap: () {
                Get.to(() => AddClassScreen(routineId: rutinId, isEdit: false));
              },
            ),

            SizedBox(
                height: totalClass == 0 ? 50 : totalClass * 60,
                child: rutinDetals.when(
                  data: (data) {
                    if (data == null) {
                      return Text("Null $data");
                    }
                    // notification
                    if (notificationOff == false) {
                      print(
                          "CAll sudule notification ${data.classes.allClass.length}");

                      LocalNotification.scheduleNotifications(
                          data.classes.allClass);
                    }
                    int length = data.uniqClass.length;

                    return Column(
                      children: List.generate(length, (index) {
                        //
                        UniqClass uniqClass = data.uniqClass[index];

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          // Add Your Code here.
                          totalClassNotifier.update((state) => length);

                          ref
                              .watch(routineOwenerNameProvider.notifier)
                              .update((state) => data.owner.name);
                        });
                        print("data");

                        print(data);
                        if (length == 0) {
                          ErrorWidget('No Class Created');
                        }
                        return ClassRow(
                          id: uniqClass.id,
                          className: uniqClass.name,

                          //
                          onLongPress: () {
                            PriodeAlart.logPressClass(
                              context,
                              classId: data.classes.allClass[index].classId.id,
                              rutinId: rutinId,
                            );
                          },
                          ontap: () => Get.to(
                            () => SummaryScreen(
                              classId: uniqClass.id,
                              routineID: uniqClass.rutinId,
                              className: uniqClass.name,
                              instructorName: uniqClass.instuctorName,
                              subjectCode: uniqClass.subjectcode,
                            ),
                          ),
                        );
                      }),
                    );
                  },
                  error: (error, stackTrace) =>
                      Alart.handleError(context, error),
                  loading: () => Loaders.center(),
                )),
          ],
        ),
      );
    });
  }
}
