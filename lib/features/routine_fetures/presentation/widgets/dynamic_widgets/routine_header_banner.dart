import 'package:flutter/material.dart';
import 'routine_theme.dart';

class RoutineHeaderBanner extends StatelessWidget {
  final RoutineTheme theme;
  final String title;
  final String subtitle;
  final String ownerName;
  final String? ownerAvatarUrl;
  final String description;

  const RoutineHeaderBanner({
    super.key,
    required this.theme,
    required this.title,
    required this.subtitle,
    required this.ownerName,
    this.ownerAvatarUrl,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: theme.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Content Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon + Type Badge Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon White Box
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      theme.typeIcon,
                      color: theme.primaryColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Type Badge Pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.22),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.35),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      theme.typeBadgeText,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Title
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.55,
                child: Text(
                  title.isNotEmpty
                      ? title
                      : (theme.isExam ? "PGCB Model Test" : "PGCB"),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.15,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Subtitle
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.95),
                  ),
                ),
              ],

              const SizedBox(height: 10),

              // Owner Info Row
              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.white24,
                    backgroundImage: (ownerAvatarUrl != null && ownerAvatarUrl!.isNotEmpty)
                        ? NetworkImage(ownerAvatarUrl!)
                        : const AssetImage("assets/png/noor_azom.jpg") as ImageProvider,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "Uploaded by ${ownerName.isNotEmpty ? ownerName : 'MD Nur Azom'}",
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.verified,
                    size: 14,
                    color: Colors.white,
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Description Subtext
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.65,
                child: Text(
                  description.isNotEmpty
                      ? description
                      : (theme.isExam
                          ? "This is the routine for PCCB Model Test – Model 1."
                          : "This is the class routine for PCCB – Session 2026."),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.88),
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          // 3D Clipboard & Clock Artwork on Top Right
          Positioned(
            right: -6,
            top: -4,
            child: SizedBox(
              width: 100,
              height: 110,
              child: Stack(
                children: [
                  // Clipboard white paper
                  Positioned(
                    right: 8,
                    top: 0,
                    child: Transform.rotate(
                      angle: 0.08,
                      child: Container(
                        width: 72,
                        height: 88,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.18),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top Clip Bar
                            Center(
                              child: Container(
                                width: 28,
                                height: 7,
                                decoration: BoxDecoration(
                                  color: theme.primaryColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Check items
                            _buildCheckLine(true),
                            const SizedBox(height: 5),
                            _buildCheckLine(true),
                            const SizedBox(height: 5),
                            _buildCheckLine(false),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Floating 3D Clock Icon on bottom right
                  Positioned(
                    right: 0,
                    bottom: 4,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.access_time_filled_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckLine(bool checked) {
    return Row(
      children: [
        Container(
          width: 11,
          height: 11,
          decoration: BoxDecoration(
            color: checked ? const Color(0xFF22C55E) : const Color(0xFFCBD5E1),
            shape: BoxShape.circle,
          ),
          child: checked
              ? const Icon(Icons.check, size: 8, color: Colors.white)
              : null,
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ],
    );
  }
}
