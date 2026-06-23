import 'package:classmate/features/notice_fetures/data/models/recent_notice_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';

Future<void> shareNotice({required Notice notice}) async {
  final shareUrl = "https://classmaster.top/notice/${notice.id}";

  final shareText = '''
📢 ${notice.title}

${notice.description ?? ''}

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
