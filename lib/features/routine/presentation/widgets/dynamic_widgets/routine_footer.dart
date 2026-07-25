import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../notice_fetures/presentation/widgets/static_widgets/custom_share_bottom_sheet.dart';
import '../../../../routine_summary_fetures/presentation/screens/summary_screen.dart';
import '../../providers/chack_status_controller.dart';
import '../../../../../core/export_core.dart';

class RoutineFooter extends ConsumerWidget {
  final String routineId;
  final String routineName;
  final bool isExam;
  final String? aboutDescription;
  final String? shareableUrl;

  const RoutineFooter({
    super.key,
    required this.routineId,
    required this.routineName,
    this.isExam = false,
    this.aboutDescription,
    this.shareableUrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final effectiveShareUrl =
        shareableUrl ?? "https://classmaster.top/routine?routineId=$routineId";

    final defaultAboutText =
        isExam
            ? "This is the exam routine for $routineName. Please check all exam dates and room numbers carefully."
            : "This is the regular class routine for $routineName. Please follow the schedule and attend classes on time.";

    final primaryColor =
        isExam ? const Color(0xFF7C3AED) : const Color(0xFF2563EB);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),

        // 1. ABOUT THIS ROUTINE CARD
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFECFDF5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFA7F3D0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.article_outlined,
                    color: Color(0xFF047857),
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    isExam ? "About  Exam Instractions" : "About This Routine",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF065F46),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                aboutDescription ?? defaultAboutText,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF047857),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // 2. DISCUSSION CARD
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => SummaryScreen(
                      classId: routineId,
                      routineID: routineId,
                      className: routineName,
                      subjectCode:
                          isExam ? "EXAM-DISCUSSION" : "CLASS-DISCUSSION",
                    ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3E8FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.forum_outlined,
                    color: Color(0xFF9333EA),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isExam ? "Exam Discussion" : "Class Discussion",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isExam
                            ? "General discussion about exam, instructions, seat plan, etc."
                            : "Discuss with classmates about classes, notes, assignments etc.",
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // 3. BOTTOM ACTION BUTTONS (Share & Dynamic Status/Join)
        Row(
          children: [
            Expanded(
              child: CustomShareButton(
                shareableUrl: effectiveShareUrl,
                label: "Share Routine",
                primaryColor: const Color(0xFF334155),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Consumer(
                builder: (context, ref, _) {
                  final statusAsync = ref.watch(
                    checkStatusControllerProvider(routineId),
                  );
                  return statusAsync.when(
                    data: (status) {
                      final activeStatus = status.activeStatus.toLowerCase();
                      if (status.isOwner ||
                          status.isCaptain ||
                          activeStatus == "joined") {
                        return ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () {},
                          icon: const Icon(
                            Icons.notifications_active_rounded,
                            size: 18,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Notify Me",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        );
                      } else if (activeStatus == "pending") {
                        return Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade700,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Text(
                            "Pending",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      } else {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () {
                            ref
                                .read(
                                  checkStatusControllerProvider(
                                    routineId,
                                  ).notifier,
                                )
                                .sendReqController(context);
                          },
                          child: const Text(
                            "Send Req",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }
                    },
                    error: (_, __) => const SizedBox(),
                    loading: () => Loaders.center(),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
