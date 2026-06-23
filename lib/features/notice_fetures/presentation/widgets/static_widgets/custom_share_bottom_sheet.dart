import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

// ============================================================================
// SHARE BOTTOM SHEET COMPONENT
// ============================================================================

class CustomShareBottomSheet extends StatelessWidget {
  final String shareableUrl;

  const CustomShareBottomSheet({super.key, required this.shareableUrl});

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: shareableUrl)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Link copied to clipboard!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context); // Close sheet after copying
    });
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dark theme styling similar to the YouTube example
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF212121), // Dark grey background
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade600,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Sharing Link',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Link Container with Copy Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF303030),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      shareableUrl,
                      style: const TextStyle(color: Colors.white70),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.copy, color: Colors.white70),
                    onPressed: () => _copyToClipboard(context),
                    tooltip: 'Copy link',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 20),

          // Social Media Icons Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Wrap(
              spacing: 24,
              runSpacing: 24,
              alignment: WrapAlignment.start,
              children: [
                _buildShareIcon(
                  icon: FontAwesomeIcons.whatsapp,
                  color: const Color(0xFF25D366),
                  label: 'WhatsApp',
                  onTap:
                      () => _launchUrl(
                        'https://wa.me/?text=${Uri.encodeComponent(shareableUrl)}',
                      ),
                ),
                _buildShareIcon(
                  icon: FontAwesomeIcons.facebook,
                  color: const Color(0xFF1877F2),
                  label: 'Facebook',
                  onTap:
                      () => _launchUrl(
                        'https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(shareableUrl)}',
                      ),
                ),
                _buildShareIcon(
                  icon: FontAwesomeIcons.facebookMessenger,
                  color: const Color(0xFF00B2FF),
                  label: 'Messenger',
                  onTap:
                      () => _launchUrl(
                        'fb-messenger://share/?link=${Uri.encodeComponent(shareableUrl)}',
                      ),
                ),
                _buildShareIcon(
                  icon: FontAwesomeIcons.telegram,
                  color: const Color(0xFF0088cc),
                  label: 'Telegram',
                  onTap:
                      () => _launchUrl(
                        'https://t.me/share/url?url=${Uri.encodeComponent(shareableUrl)}',
                      ),
                ),
                _buildShareIcon(
                  icon: FontAwesomeIcons.twitter,
                  color: const Color(0xFF1DA1F2),
                  label: 'Twitter',
                  onTap:
                      () => _launchUrl(
                        'https://twitter.com/intent/tweet?url=${Uri.encodeComponent(shareableUrl)}',
                      ),
                ),
                _buildShareIcon(
                  icon: Icons.email,
                  color: Colors.redAccent,
                  label: 'Email',
                  isMaterial: true, // Flag to use standard Icon
                  onTap:
                      () => _launchUrl(
                        'mailto:?subject=Check out this Notice&body=${Uri.encodeComponent(shareableUrl)}',
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareIcon({
    required dynamic icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
    bool isMaterial = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            // Use FaIcon for FontAwesome, standard Icon for Material
            child:
                isMaterial
                    ? Icon(icon as IconData, color: Colors.white, size: 28)
                    : FaIcon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
