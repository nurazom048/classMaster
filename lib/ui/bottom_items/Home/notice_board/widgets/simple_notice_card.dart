import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../widgets/appWidget/app_text.dart';

class SimpleNoticeCard extends StatelessWidget {
  const SimpleNoticeCard({
    super.key,
    required this.id,
    required this.noticeName,
    required this.ontap,
    required this.onLongPress,
    required this.dateTime,
  });

  final DateTime dateTime;
  final String noticeName;
  final String id;
  final dynamic ontap, onLongPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: onLongPress ?? () {},
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(vertical: 5),
        width: MediaQuery.of(context).size.width - 10,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: InkWell(
          onTap: ontap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    DateFormat('dd MMM yy').format(dateTime).toString(),
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      height: 1.86,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(width: 5),
                  AppText(noticeName, color: Colors.black).heding(),
                ],
              ),
              const Icon(Icons.arrow_forward)
            ],
          ),
        ),
      ),
    );
  }
}
