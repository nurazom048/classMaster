// ignore_for_file: curly_braces_in_flow_control_structures, unnecessary_null_comparison, avoid_print, unused_local_variable, unused_result, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/export_core.dart';
import '../../providers/routine_details.controller.dart';
import '../../widgets/dynamic_widgets/routine_box_by_id.dart';
import 'class_list.dart';

class ClassRoutineDetailView extends StatelessWidget {
  final String routineId;
  final String? routineName;
  final String? ownerName;

  const ClassRoutineDetailView({
    super.key,
    required this.routineId,
    this.routineName,
    this.ownerName,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final routineDetails = ref.watch(routineDetailsProvider(routineId));
        final cachedOwnerName = ref.watch(ownerNameProvider(routineId));

        final resolvedName =
            routineName ?? routineDetails.value?.routineName ?? "Routine";

        return DesktopLayoutWrapper(
          child: SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xFFF8FAFC),
              body: ClassListPage(
                routineId: routineId,
                routineName: resolvedName,
              ),
            ),
          ),
        );
      },
    );
  }
}
