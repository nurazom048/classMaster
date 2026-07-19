import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constant/constant.dart';
import '../../../data/models/recent_notice_model.dart';

class PremiumNoticeCard extends StatelessWidget {
  final Notice notice;
  final String? academyID;
  final onTap;
  final VoidCallback onLongPress;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const PremiumNoticeCard({
    super.key,
    required this.notice,
    required this.academyID,
    required this.onTap,
    required this.onLongPress,
    this.margin,
    this.padding,
  });

  // ক্যাটাগরি ভিত্তিক রেন্ডারিং টেক্সট এবং কালার ম্যাপ
  Map<String, dynamic> _getCategoryStyle(String category) {
    switch (category) {
      case 'job_circular':
        return {
          'label': 'Job Circular',
          'bgColor': const Color(0xFFFCE8E6), // লাইট রেড
          'textColor': const Color(0xFFD93025),
        };
      case 'result':
        return {
          'label': 'Result',
          'bgColor': const Color(0xFFE6F4EA), // লাইট গ্রিন
          'textColor': const Color(0xFF137333),
        };
      case 'notice':
        return {
          'label': 'Notice',
          'bgColor': const Color(0xFFE8F0FE), // লাইট ব্লু
          'textColor': const Color(0xFF1A73E8),
        };
      default:
        return {
          'label': 'Other',
          'bgColor': const Color(0xFFF1F3F4), // লাইট গ্রে
          'textColor': const Color(0xFF5F6368),
        };
    }
  }

  /// 🔗 বিল্ড ফুল ইমেজ ইউআরএল
  String? _getImageUrl() {
    // AccountModels এর imageUrl getter ব্যবহার করুন যা স্বয়ংক্রিয়ভাবে BASE_URL যোগ করে
    return notice.account.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    // 🔍 ডিবাগিং প্রিন্ট স্টেটমেন্ট
    final imageUrl = _getImageUrl();
    debugPrint('📸 Notice Publisher: ${notice.account.name}');
    debugPrint('🖼️ Image Path: ${notice.account.image}');
    debugPrint('🔗 Full Image URL: $imageUrl');

    final catStyle = _getCategoryStyle(notice.category);
    final day = DateFormat('dd').format(notice.createdAt);
    final month = DateFormat('MMM').format(notice.createdAt).toUpperCase();
    final year = DateFormat('yyyy').format(notice.createdAt);

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: margin ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📅 ক্যালেন্ডার টাইপ লেআউট (রেফারেন্স ইমেজ অনুযায়ী)
            Container(
              width: 58,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    day,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    month,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0052CC), // Blue Theme
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    year,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // 📝 নোটিশের বডি এবং ইনফো সেকশন
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // টাইটেল (সর্বোচ্চ ২ লাইনে সুন্দরভাবে শো করবে)
                  Text(
                    notice.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // পাবলিশার অ্যাকাউন্ট ও ক্যাটাগরি ব্যাজ
                  Row(
                    children: [
                      // প্রোফাইল অ্যাভাটার (ইমেজ বা ফলব্যাক আইকন)
                      CircleAvatar(
                        radius: 11,
                        backgroundColor: Colors.blue.shade100,
                        backgroundImage:
                            imageUrl != null && imageUrl.isNotEmpty
                                ? CachedNetworkImageProvider(imageUrl)
                                : null,
                        child:
                            imageUrl == null || imageUrl.isEmpty
                                ? const Icon(
                                  Icons.school,
                                  size: 10,
                                  color: Colors.blueAccent,
                                )
                                : null,
                      ),
                      const SizedBox(width: 6),

                      // নাম এবং ভেরিফাইড টিক ব্যাজ
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                notice.account.name ?? 'Job News',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            // নীল ভেরিফাইড টিক চিহ্ন
                            const Icon(
                              Icons.verified,
                              size: 14,
                              color: Color(0xFF0052CC), // Royal Blue Verified
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // ডাইনামিক কাস্টম ক্যাটাগরি চিপ
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: catStyle['bgColor'],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          catStyle['label'],
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: catStyle['textColor'],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // অ্যারো বাটন
            const Align(
              alignment: Alignment.center,
              child: Icon(Icons.chevron_right, color: Colors.grey, size: 24),
            ),
          ],
        ),
      ),
    );
  }
}
