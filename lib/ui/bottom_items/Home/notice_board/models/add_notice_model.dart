import 'package:classmate/ui/bottom_items/Home/notice_board/models/recent_notice_model.dart';

class AddNoticeMessage {
  String message;
  Notice notice;

  AddNoticeMessage({required this.message, required this.notice});

  factory AddNoticeMessage.fromJson(Map<String, dynamic> json) {
    return AddNoticeMessage(
      message: json['message'] as String,
      notice: Notice.fromJson(json['notice'] as Map<String, dynamic>),
    );
  }
}
