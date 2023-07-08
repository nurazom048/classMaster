// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../widgets/appWidget/app_text.dart';

String getTimeDuration(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inDays == 0) {
    return 'Today';
  } else if (difference.inDays == 1) {
    return 'Yesterday';
  } else if (difference.inDays <= 7) {
    return 'Last week';
  } else {
    return 'A long time ago';
  }
}

class SimpleNoticeCard extends StatelessWidget {
  const SimpleNoticeCard({
    super.key,
    required this.id,
    required this.noticeName,
    required this.ontap,
    required this.onLongPress,
    required this.dateTime,
    required this.previousDateTime,
    this.isFirst,
  });

  final DateTime dateTime;
  final DateTime previousDateTime;
  final String noticeName;
  final String id;
  final dynamic ontap, onLongPress;
  final bool? isFirst;

  @override
  Widget build(BuildContext context) {
    String time = DateFormat('dd/MMM/yy ').format(dateTime).toString();
    return InkWell(
      onLongPress: onLongPress ?? () {},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //

            if (dateTime.day != previousDateTime.day || isFirst == true)
              Text(
                "  ${getTimeDuration(dateTime)}",
                style: TS.opensensBlue(
                    color: Colors.black, fontWeight: FontWeight.w400),
              ),

            //
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: InkWell(
                onTap: ontap,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 7,
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            width: MediaQuery.of(context).size.width * 0.61,
                            // color: Colors.red,
                            child: Row(
                              children: [
                                Text(
                                  '  $time',
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 18,
                                    height: 1.86,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                                Text(
                                  noticeName,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TS.opensensBlue(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(flex: 1, child: const Icon(Icons.arrow_forward))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
