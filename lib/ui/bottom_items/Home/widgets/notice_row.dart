import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table/ui/bottom_items/Home/notice_board/models/recent_notice_model.dart';
import 'package:table/ui/bottom_items/Home/notice_board/screens/view_notice_screen.dart';
import 'package:table/widgets/appWidget/dotted_divider.dart';

import '../../../../widgets/appWidget/app_text.dart';
import '../../Collection Fetures/models/account_models.dart';

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
    DateTime dateTime = notice.time;

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      DateFormat('dd/MMM/yy ').format(dateTime).toString(),
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        height: 1.86,
                        color: Color(0xFF333333),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width * 0.54,
                      // color: Colors.red,
                      child: Text(
                        notice.contentName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TS.opensensBlue(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                    onTap: () {
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
                    child: const Icon(Icons.arrow_forward))
              ],
            ),
          ),
          const DotedDivider(),
        ],
      ),
    );
  }
}
