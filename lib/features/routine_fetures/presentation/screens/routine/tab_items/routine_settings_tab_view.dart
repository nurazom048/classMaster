import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/routine_details.controller.dart';
import '../../../widgets/dynamic_widgets/routine_theme.dart';
import '../create_new_routine.dart';

class RoutineSettingsTabView extends ConsumerWidget {
  final RoutineTheme theme;
  final String routineId;
  final bool isOwnerOrCaptain;

  const RoutineSettingsTabView({
    super.key,
    required this.theme,
    required this.routineId,
    required this.isOwnerOrCaptain,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routineDetails = ref.watch(routineDetailsProvider(routineId));
    final routineData = routineDetails.value;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.settings_outlined,
                size: 20,
                color: theme.primaryColor,
              ),
              const SizedBox(width: 8),
              const Text(
                "Routine Settings",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSettingsTile(
            icon: Icons.notifications_active_outlined,
            title: "Routine Notifications",
            subtitle: "Receive alerts for class & exam updates",
            trailing: Switch.adaptive(
              value: true,
              activeColor: theme.primaryColor,
              onChanged: (val) {},
            ),
          ),
          const Divider(height: 24, color: Color(0xFFF1F5F9)),
          _buildSettingsTile(
            icon: Icons.lock_outline_rounded,
            title: "Privacy Settings",
            subtitle: "Only members can access routine details",
            trailing: const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF94A3B8),
            ),
            onTap: () {},
          ),
          if (isOwnerOrCaptain) ...[
            const Divider(height: 24, color: Color(0xFFF1F5F9)),
            _buildSettingsTile(
              icon: Icons.edit_note_rounded,
              title: "Edit Routine Details",
              subtitle: "Modify routine name, session, or description",
              trailing: const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF94A3B8),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => CreateNewRoutine(
                          isEditMode: true,
                          routineId: routineId,
                          initialRoutineName: routineData?.routineName,
                          initialRoutineType: routineData?.routineType,
                          initialAbout: routineData?.about,
                        ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: theme.lightBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: theme.primaryColor),
          ),
          const SizedBox(width: 14),
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
          if (trailing != null) trailing,
        ],
      ),
    );
  }
}
