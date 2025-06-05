// ignore_for_file: avoid_print, unused_local_variable, use_build_context_synchronously, unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import '../../../../../../features/home_fetures/presentation/utils/utils.dart';
import '../../../../../../features/routine_Fetures/presentation/providers/routine_details.controller.dart';
import '../providers/checkbox_selector_button.dart';
import '../../../../core/export_core.dart';
import '../../../../route/route_constant.dart';
import '../../../routine_summary_fetures/presentation/screens/summary_screen.dart';
import '../../data/models/class_details_model.dart';
import '../utils/long_press.dart';
import '../widgets/static_widgets/class_row.dart';

final totalClassCountProvider = StateProvider.autoDispose<int>((ref) => 0);

class ClassListPage extends StatelessWidget {
  final String routineId;
  final String routineName;

  const ClassListPage({
    super.key,
    required this.routineId,
    required this.routineName,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
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
            child: Builder(
              builder: (context) {
                return ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  children: [
                    //----------------------- "Class List" -------------------------//

                    // Add Classs Button can Only see Captain or owner
                    checkStatus.when(
                      data: (data) {
                        return HeadingRow(
                          heading: "Class List",
                          secondHeading: '',
                          // "$totalClass classes${totalClass > 1 ? "s" : ''}",
                          margin: const EdgeInsets.only(top: 10),
                          buttonText: "Add Class",
                          ButtonViability: data.isCaptain || data.isOwner,
                          onTap: () {
                            context.pushNamed(
                              RouteConst.addClass,
                              extra: false,
                              params: {'routineId': routineId},
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

                    routineDetails.when(
                      data: (data) {
                        final int length = data.allClass.length;

                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: length,
                          itemBuilder: (contexts, index) {
                            final AllClass allClass = data.allClass[index];
                            final String classsID = allClass.id;

                            print(data);
                            if (length == 0) {
                              return const ErrorScreen(
                                error: 'No Class Created',
                              );
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
                                  PeriodAlert.logPressClass(
                                    context,
                                    classId: classsID,
                                    routineId: routineId,
                                  );
                                },
                                ontap:
                                    () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => SummaryScreen(
                                              classId: allClass.id,
                                              routineID: allClass.routineId,
                                              className: allClass.name,
                                              instructorName:
                                                  allClass.instructorName,
                                              subjectCode: allClass.subjectCode,
                                            ),
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
              },
            ),
          ),
        );
      },
    );
  }
}
