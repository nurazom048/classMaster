// ignore_for_file: avoid_print, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:table/core/component/loaders.dart';
import 'package:table/ui/bottom_items/Add/screens/add_class_screen.dart';

import '../../../../../../core/dialogs/alert_dialogs.dart';
import '../../../../../../models/class_details_model.dart';
import '../../../../../../widgets/error/error.widget.dart';
import '../../../../../../widgets/heading_row.dart';
import '../../request/routine_api.dart';
import '../../../../Add/screens/add_priode.dart';
import '../../controller/check_status_controller.dart';
import '../../request/priode_request.dart';
import '../../Summary/summat_screens/summary_screen.dart';
import '../../utils/logng_press.dart';
import '../../widgets/class_row.dart';
import '../../widgets/priode_widget.dart';

final totalPriodeCountProvider = StateProvider.autoDispose<int>((ref) => 0);
final totalClassCountProvider = StateProvider.autoDispose<int>((ref) => 0);

class ClassListPage extends StatelessWidget {
  final String routineId;
  final String routineName;

  const ClassListPage({
    Key? key,
    required this.routineId,
    required this.routineName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      print(routineId);

      // Provider
      final routineDetails = ref.watch(routine_details_provider(routineId));
      final allPriode = ref.watch(allPriodeProvider(routineId));
      final totalPriode = ref.watch(totalPriodeCountProvider);
      final totalClass = ref.watch(totalClassCountProvider);

      // Notifiers
      final checkStatus = ref.watch(checkStatusControllerProvider(routineId));
      final totalPriodeNotifier = ref.read(totalPriodeCountProvider.notifier);
      final totalClassNotifier = ref.read(totalClassCountProvider.notifier);

      return Scaffold(
        backgroundColor: Colors.white10,
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: [
            //----------------------- "Priode Lists" -------------------------//
            HeadingRow(
              heading: "Priode List",
              secondHeading: "$totalPriode priode${totalPriode > 1 ? "s" : ''}",
              margin: EdgeInsets.zero,
              buttonText: "Add Priode",
              onTap: () => Get.to(
                () => AppPriodePage(
                  routineId: routineId,
                  routineName: routineName,
                  isEdit: false,
                  totalPriode: totalPriode,
                ),
              ),
            ),
            SizedBox(
              height: 140,
              child: allPriode.when(
                data: (data) {
                  return data.fold(
                    (l) {
                      Alert.handleError(context, l.message);
                      return ErrorScreen(error: l.message);
                    },
                    (data) {
                      return ListView.builder(
                        shrinkWrap: true,
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
                            onLongpress: () {
                              PriodeAlert.logPressOnPriode(
                                context,
                                priodeId,
                                routineId,
                                data.priodes[index],
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
                error: (error, stackTrace) {
                  Alert.handleError(context, error);
                  return ErrorScreen(error: error.toString());
                },
                loading: () => Loaders.center(height: 200, width: 100),
              ),
            ),

            //----------------------- "Class List" -------------------------//
            HeadingRow(
              heading: "Class List",
              secondHeading: "$totalClass classes${totalClass > 1 ? "s" : ''}",
              margin: const EdgeInsets.only(top: 10),
              buttonText: "Add Class",
              onTap: () {
                Get.to(
                    () => AddClassScreen(routineId: routineId, isEdit: false));
              },
            ),

            routineDetails.when(
              data: (data) {
                if (data == null) {
                  return Text("Null $data");
                }

                int length = data.uniqClass.length;

                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: length,
                  itemBuilder: (context, index) {
                    UniqClass uniqClass = data.uniqClass[index];

                    print(data);
                    if (length == 0) {
                      return const ErrorScreen(error: 'No Class Created');
                    }
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      totalClassNotifier.update((state) => length);
                    });

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ClassRow(
                        id: uniqClass.id,
                        className: uniqClass.name,
                        onLongPress: () {
                          PriodeAlert.logPressClass(
                            context,
                            classId: data.classes.allClass[index].classId.id,
                            rutinId: routineId,
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
                      ),
                    );
                  },
                );
              },
              error: (error, stackTrace) {
                Alert.handleError(context, error);
                return ErrorScreen(error: error.toString());
              },
              loading: () => Loaders.center(),
            ),
          ],
        ),
      );
    });
  }
}
