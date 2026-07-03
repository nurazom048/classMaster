// 🎯 টাইম ডিউরেশন (গ্রুপিং) বের করার হেল্পার ফাংশন
String getTimeGroupLabel(DateTime dateTime) {
  final now = DateTime.now();
  // রাত ১২টা পার হলে যাতে সঠিকভাবে দিন ক্যালকুলেট হয়, তাই শুধু Year, Month, Day নেওয়া হলো
  final today = DateTime(now.year, now.month, now.day);
  final date = DateTime(dateTime.year, dateTime.month, dateTime.day);
  final difference = today.difference(date).inDays;

  if (difference == 0) {
    return 'Today';
  } else if (difference == 1) {
    return 'Yesterday';
  } else if (difference <= 7) {
    return 'Last week';
  } else {
    return 'Older notices';
  }
}
