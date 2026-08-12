import 'package:flutter/material.dart';
import 'routine_theme.dart';

class RoutineOptionsCard extends StatefulWidget {
  final RoutineTheme theme;
  final String? routineDescription;
  final String routineId;
  final String displayTitle;
  final String ownerName;
  final dynamic about;
  final VoidCallback? onAboutTap;
  final VoidCallback? onInstructionsTap;
  final VoidCallback? onDiscussionTap;

  const RoutineOptionsCard({
    super.key,
    required this.theme,
    this.routineDescription,
    required this.routineId,
    required this.displayTitle,
    required this.ownerName,
    this.about,
    this.onAboutTap,
    this.onInstructionsTap,
    this.onDiscussionTap,
  });

  @override
  State<RoutineOptionsCard> createState() => _RoutineOptionsCardState();
}

class _RoutineOptionsCardState extends State<RoutineOptionsCard> {
  bool isAboutExpanded = false;
  bool isInstructionsExpanded = false;

  @override
  Widget build(BuildContext context) {
    final String discussionTitle =
        widget.theme.isExam ? "Exam Discussion" : "Class Discussion";
    final String discussionSub =
        widget.theme.isExam
            ? "Discuss with classmates about exam, seat plan, etc."
            : "Discuss with classmates about class, seat plan, etc.";

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // 1. ABOUT THIS ROUTINE
          _buildOptionTile(
            icon: Icons.info_outline_rounded,
            title: "About This Routine",
            subtitle: "Important information about this routine",
            isExpanded: isAboutExpanded,
            onTap: () {
              setState(() {
                isAboutExpanded = !isAboutExpanded;
              });
              if (widget.onAboutTap != null) widget.onAboutTap!();
            },
            expandedChild: _buildAboutDetailsContent(),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9), indent: 56),

          // 2. DISCUSSION (Opens Chat/Summary)
          _buildOptionTile(
            icon: Icons.chat_bubble_outline_rounded,
            title: discussionTitle,
            subtitle: discussionSub,
            isExpanded: false,
            onTap: widget.onDiscussionTap,
            expandedChild: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isExpanded,
    required VoidCallback? onTap,
    required Widget expandedChild,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Icon in theme circle
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: widget.theme.lightBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 20, color: widget.theme.primaryColor),
                ),
                const SizedBox(width: 14),

                // Text Titles
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),

                // Right Chevron / Expand Arrow Icon
                AnimatedRotation(
                  turns: isExpanded ? 0.25 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF94A3B8),
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Animated Expanded Details Box
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: expandedChild,
          ),
          crossFadeState:
              isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 220),
        ),
      ],
    );
  }

  Widget _buildAboutDetailsContent() {
    String? aboutText;
    final List<Widget> customAboutWidgets = [];

    if (widget.about != null) {
      if (widget.about is String) {
        aboutText = widget.about as String;
      } else if (widget.about is Map) {
        final Map map = widget.about as Map;
        map.forEach((key, val) {
          customAboutWidgets.add(
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: _buildDetailRow(key.toString(), val.toString()),
            ),
          );
        });
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: widget.theme.lightBgColor.withOpacity(0.6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: widget.theme.borderTileColor.withOpacity(0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow("Routine Name", widget.displayTitle),
          const SizedBox(height: 6),
          _buildDetailRow(
            "Type",
            widget.theme.isExam ? "Exam Routine" : "Class Routine",
          ),
          const SizedBox(height: 6),
          _buildDetailRow("Owner / Creator", widget.ownerName),
          const SizedBox(height: 6),
          _buildDetailRow("Routine ID", widget.routineId),
          if (widget.routineDescription != null &&
              widget.routineDescription!.isNotEmpty) ...[
            const SizedBox(height: 6),
            _buildDetailRow("Description", widget.routineDescription!),
          ],
          if (aboutText != null && aboutText.isNotEmpty) ...[
            const SizedBox(height: 6),
            _buildDetailRow("About", aboutText),
          ],
          if (customAboutWidgets.isNotEmpty) ...[
            ...customAboutWidgets,
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
        ),
      ],
    );
  }
}
