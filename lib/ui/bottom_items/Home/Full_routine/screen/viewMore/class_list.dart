// ignore_for_file: avoid_print, unused_local_variable, use_build_context_synchronously, unused_result

import 'package:classmate/ui/bottom_items/Home/Full_routine/utils/long_press.dart';
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
import '../../controller/routine_details.controller.dart';
import '../../controller/check_status_controller.dart';
import '../../Summary/summat_screens/summary_screen.dart';
import '../../widgets/class_row.dart';

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
      final scaffoldKey = GlobalKey<ScaffoldState>();

      // Provider
      final routineDetails = ref.watch(routineDetailsProvider(routineId));

      // Notifiers
      final checkStatus = ref.watch(checkStatusControllerProvider(routineId));
      final totalClassNotifier = ref.read(totalClassCountProvider.notifier);

      return Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white10,
        body: RefreshIndicator(
          onRefresh: () async {
            final bool isOnline = await Utils.isOnlineMethod();
            if (!isOnline) {
              Alert.showSnackBar(context, 'You are in offline mode');
            } else {
              //! provider

              ref.refresh(routineDetailsProvider(routineId));
            }
          },
          child: Builder(builder: (context) {
            return ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                //----------------------- "Class List" -------------------------//
                HeadingRow(
                  heading: "Class List",
                  secondHeading: '',
                  //"$totalClass classes${totalClass > 1 ? "s" : ''}",
                  margin: const EdgeInsets.only(top: 10),
                  buttonText: "Add Class",
                  onTap: () {
                    Get.to(() =>
                        AddClassScreen(routineId: routineId, isUpdate: false));
                  },
                ),

                routineDetails.when(
                  data: (data) {
                    final int length = data.allClass.length;

                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: length,
                      itemBuilder: (context, index) {
                        final AllClass allClass = data.allClass[index];
                        final String classsID = allClass.id;

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
                            id: allClass.id,
                            className: allClass.name,
                            onLongPress: () {
                              PriodeAlert.logPressClass(
                                context,
                                classId: classsID,
                                rutinId: routineId,
                              );
                            },
                            ontap: () => Get.to(
                              () => SummaryScreen(
                                classId: allClass.id,
                                routineID: allClass.routineId,
                                className: allClass.name,
                                instructorName: allClass.instructorName,
                                subjectCode: allClass.subjectCode,
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
