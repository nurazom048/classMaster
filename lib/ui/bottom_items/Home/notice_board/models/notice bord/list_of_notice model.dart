import 'package:table/ui/bottom_items/Home/notice_board/models/notice%20bord/recentNotice.dart';

class NoticesResponse {
  String message;
  List<Notice> notices;
  int currentPage;
  int totalPages;

  NoticesResponse({
    required this.message,
    required this.notices,
    required this.currentPage,
    required this.totalPages,
  });

  factory NoticesResponse.fromJson(Map<String, dynamic> json) {
    return NoticesResponse(
      message: json['message'],
      notices: List<Notice>.from(
          json['notices'].map((notice) => Notice.fromJson(notice))),
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
    );
  }
}
