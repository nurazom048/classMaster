import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table/ui/bottom_items/Account/models/account_models.dart';
import 'package:table/ui/bottom_items/Home/notice_board/models/recent_notice_model.dart';
import 'package:table/ui/bottom_items/Home/notice_board/screens/view_notice_screen.dart';
import 'package:table/widgets/appWidget/dottted_divider.dart';

class NoticeRow extends StatelessWidget {
  const NoticeRow({
    super.key,
    required this.notice,
    required this.accountModels,
  });

  final Notice notice;
  final AccountModels accountModels;

  @override
  Widget build(BuildContext context) {
    DateTime dt = notice.time;
    return SizedBox(
      height: 60,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                DateFormat('dd MMM yy').format(dt).toString(),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  height: 1.86,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  notice.contentName,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    height: 1.86,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => NoticeViewScreen(
                          notice: notice,
                          accountModel: accountModels,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward)),
            ],
          ),
          const SizedBox(height: 5),
          const DotedDivider(),
        ],
      ),
    );
  }
}
