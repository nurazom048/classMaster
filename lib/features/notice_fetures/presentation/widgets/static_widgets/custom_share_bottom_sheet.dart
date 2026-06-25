import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomShareBottomSheet extends StatelessWidget {
  final String shareableUrl;

  const CustomShareBottomSheet({super.key, required this.shareableUrl});

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: shareableUrl)).then((_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.greenAccent, size: 20),
                const SizedBox(width: 10),
                const Text(
                  'Link copied to clipboard!',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFF2D2D2D),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 2),
          ),
        );
      }
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
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E), // Premium sleek dark background
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.only(top: 12, bottom: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Sharing Link',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Clickable Link Container with Copy Button inside
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: InkWell(
              onTap: () => _copyToClipboard(context),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D2D2D),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10, width: 1),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        shareableUrl,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.content_copy_rounded,
                      color: Colors.white70,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
          const Divider(color: Colors.white12, height: 1),
          const SizedBox(height: 24),

          // Horizontally Scrollable Social Media Icons Row
          SizedBox(
            height: 90,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  _buildShareIcon(
                    icon: FontAwesomeIcons.whatsapp,
                    bgColor: const Color(0xFFB5C9BC), // Light Sage Green
                    iconColor: const Color(0xFF1E3A27),
                    label: 'WhatsApp',
                    onTap: () => _launchUrl(
                      'https://api.whatsapp.com/send?text=${Uri.encodeComponent(shareableUrl)}',
                    ),
                  ),
                  const SizedBox(width: 20),
                  _buildShareIcon(
                    icon: FontAwesomeIcons.facebookF,
                    bgColor: const Color(0xFFB1C4D6), // Light Slate Blue
                    iconColor: const Color(0xFF1A365D),
                    label: 'Facebook',
                    onTap: () => _launchUrl(
                      'https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(shareableUrl)}',
                    ),
                  ),
                  const SizedBox(width: 20),
                  _buildShareIcon(
                    icon: FontAwesomeIcons.facebookMessenger,
                    bgColor: const Color(0xFFB5D3E3), // Soft Sky Blue
                    iconColor: const Color(0xFF1E3E54),
                    label: 'Messenger',
                    onTap: () => _launchUrl(
                      'https://www.facebook.com/dialog/send?link=${Uri.encodeComponent(shareableUrl)}&app_id=123456789&redirect_uri=${Uri.encodeComponent(shareableUrl)}',
                    ),
                  ),
                  const SizedBox(width: 20),
                  _buildShareIcon(
                    icon: FontAwesomeIcons.telegram,
                    bgColor: const Color(0xFFB8C7D2), // Soft Blue-Grey
                    iconColor: const Color(0xFF2C3E50),
                    label: 'Telegram',
                    onTap: () => _launchUrl(
                      'https://t.me/share/url?url=${Uri.encodeComponent(shareableUrl)}',
                    ),
                  ),
                  const SizedBox(width: 20),
                  _buildShareIcon(
                    icon: FontAwesomeIcons.twitter,
                    bgColor: const Color(0xFFB8C7D2), // Soft Blue-Grey
                    iconColor: const Color(0xFF2C3E50),
                    label: 'Twitter',
                    onTap: () => _launchUrl(
                      'https://twitter.com/intent/tweet?url=${Uri.encodeComponent(shareableUrl)}',
                    ),
                  ),
                  const SizedBox(width: 20),
                  _buildShareIcon(
                    icon: Icons.email,
                    bgColor: const Color(0xFFFF005B), // Vibrant Hot Pink Circle
                    iconColor: Colors.white,
                    label: 'Email',
                    isMaterial: true,
                    isCircle: true,
                    onTap: () => _launchUrl(
                      'mailto:?subject=ClassMaster Notice&body=${Uri.encodeComponent(shareableUrl)}',
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

  Widget _buildShareIcon({
    required dynamic icon,
    required Color bgColor,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
    bool isMaterial = false,
    bool isCircle = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: bgColor,
              shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
              borderRadius: isCircle ? null : BorderRadius.circular(14),
            ),
            child: Center(
              child: isMaterial
                  ? Icon(icon as IconData, color: iconColor, size: 24)
                  : FaIcon(icon, color: iconColor, size: 24),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
