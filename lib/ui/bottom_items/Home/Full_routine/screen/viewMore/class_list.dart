// ignore_for_file: avoid_print, unused_local_variable, use_build_context_synchronously, unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:classmate/core/component/loaders.dart';
import 'package:classmate/ui/bottom_items/Add/screens/add_class_screen.dart';

import '../../../../../../core/dialogs/alert_dialogs.dart';
import '../../../../../../models/class_details_model.dart';
import '../../../../../../widgets/error/error.widget.dart';
import '../../../../../../widgets/heading_row.dart';
import '../../../utils/utils.dart';
import '../../controller/priode_controller.dart';
import '../../controller/riutine_details.controller.dart';
import '../../../../Add/screens/add_priode.dart';
import '../../controller/check_status_controller.dart';
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
      // key
      final _scaffoldKey = GlobalKey<ScaffoldState>();

      // Provider
      final routineDetails = ref.watch(routineDetailsProvider(routineId));
      final allPriode = ref.watch(priodeController(routineId));
      final totalPriode = ref.watch(totalPriodeCountProvider);
      final totalClass = ref.watch(totalClassCountProvider);

      // Notifiers
      final checkStatus = ref.watch(checkStatusControllerProvider(routineId));
      final totalPriodeNotifier = ref.read(totalPriodeCountProvider.notifier);
      final totalClassNotifier = ref.read(totalClassCountProvider.notifier);

      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white10,
        body: RefreshIndicator(
          onRefresh: () async {
            final bool isOnline = await Utils.isOnlineMethod();
            if (!isOnline) {
              Alert.showSnackBar(context, 'You are in offline mode');
            } else {
              //! provider

              ref.refresh(routineDetailsProvider(routineId));
              ref.refresh(priodeController(routineId));
            }
          },
          child: Builder(builder: (context) {
            return ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                //----------------------- "Priode Lists" -------------------------//
                HeadingRow(
                  heading: "Priode List",
                  secondHeading:
                      "$totalPriode priode${totalPriode > 1 ? "s" : ''}",
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
                                context: _scaffoldKey.currentContext!,
                                priodeId: priodeId,
                                routineId: routineId,
                                Priode: data.priodes[index],
                                ref: ref,
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
                  secondHeading:
                      "$totalClass classes${totalClass > 1 ? "s" : ''}",
                  margin: const EdgeInsets.only(top: 10),
                  buttonText: "Add Class",
                  onTap: () {
                    Get.to(() =>
                        AddClassScreen(routineId: routineId, isEdit: false));
                  },
                ),

                routineDetails.when(
                  data: (data) {
                    final int length = data.uniqClass.length;

                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: length,
                      itemBuilder: (context, index) {
                        final UniqClass uniqClass = data.uniqClass[index];
                        final String classsID = uniqClass.id;

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
                                classId: classsID,
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
            );
          }),
        ),
      );
    });
  }
}
