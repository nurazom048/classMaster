import 'dart:convert';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:classmate/features/notice_fetures/data/models/recent_notice_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';

String _getPlainText(String? content) {
  if (content == null || content.trim().isEmpty) return '';
  try {
    var parsed = jsonDecode(content);
    if (parsed is String && parsed.trim().isNotEmpty) {
      try {
        parsed = jsonDecode(parsed);
      } catch (_) {}
    }
    if (parsed is List) {
      return Document.fromJson(parsed).toPlainText().trim();
    } else if (parsed is Map &&
        parsed.containsKey('ops') &&
        parsed['ops'] is List) {
      return Document.fromJson(parsed['ops']).toPlainText().trim();
    }
  } catch (_) {}
  return content;
}

Future<void> shareNotice({required Notice notice}) async {
  final shareUrl = "https://classmaster.top/notice/${notice.id}";
  final descriptionText = _getPlainText(notice.description);

  final shareText = '''
📢 ${notice.title}

$descriptionText

Open Notice:
$shareUrl
''';

  try {
    await Share.share(shareText, subject: notice.title);
  } catch (e) {
    await Clipboard.setData(ClipboardData(text: shareUrl));

    print("Link copied: $shareUrl");
  }
}
