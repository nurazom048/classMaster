import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table/ui/bottom_items/Home/notice/models/notice%20bord/recentNotice.dart';
import 'package:table/ui/bottom_items/Home/notice/screens/viewNotice.dart';
import 'package:table/widgets/appWidget/dottted_divider.dart';

class NoticeRow extends StatelessWidget {
  const NoticeRow(
      {super.key,
      required this.date,
      required this.title,
      required this.notice});
  final String title;
  final String date;
  final Notice notice;

  @override
  Widget build(BuildContext context) {
    DateTime dt = DateTime.parse(date);
    return SizedBox(
      height: 60,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  title,
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
                              )),
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
