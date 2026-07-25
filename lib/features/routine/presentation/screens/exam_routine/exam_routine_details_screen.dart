import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/class_details_model.dart';
import 'exam_routine_detail_view.dart';
import 'package:classmate/features/notice_fetures/presentation/widgets/static_widgets/custom_share_bottom_sheet.dart';

class ExamRoutineDetailsScreen extends ConsumerWidget {
  final AllClassesResponse data;
  final String routineId;
  final String routineName;
  final bool isOwnerOrCaptain;

  const ExamRoutineDetailsScreen({
    super.key,
    required this.data,
    required this.routineId,
    required this.routineName,
    required this.isOwnerOrCaptain,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A), size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(
          routineName,
          style: const TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share_rounded, color: Color(0xFF0F172A), size: 20),
            onPressed: () => CustomShareButton.show(
              context,
              "https://classmaster.top/routine?routineId=$routineId",
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ExamRoutineDetailView(
          data: data,
          routineId: routineId,
          routineName: routineName,
          isOwnerOrCaptain: isOwnerOrCaptain,
        ),
      ),
    );
  }
}
