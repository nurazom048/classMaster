import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:classmate/widgets/appWidget/dotted_divider.dart';
import '../../../../../../models/class_details_model.dart';

class RutineCardInfoRow extends StatelessWidget {
  final Day? day;
  final bool? isFirst;
  final bool? isThird;
  final dynamic onTap;
  final Widget? tail;
  const RutineCardInfoRow({
    super.key,
    this.isFirst,
    this.onTap,
    this.day,
    this.tail,
    this.isThird,
  });
  String formatTime(DateTime? time) {
    return DateFormat.jm().format(time ?? DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          if (isFirst == true) const DotedDivider(),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${formatTime(day?.startTime)}\n-\n${formatTime(day?.endTime)}',
                  textScaleFactor: 1.2,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    height: 1.1,
                    color: Color(0xFF4F4F4F),
                  ),
                  textAlign: TextAlign.center,
                ),
                //
                const SizedBox(width: 15),

                TitleAndSubtitle(
                  title: day?.name ?? " Subject Name ",
                  subtitle: day?.room ?? "room",
                ),

                const Spacer(),
                if (tail != null) const SizedBox.shrink(),
                // const VerticalDivider(thickness: 4, color: Colors.red),

                //
                tail ??
                    InkWell(
                      onTap: onTap ?? () {},
                      child: Container(
                        alignment: AlignmentDirectional.center,
                        child: const Icon(Icons.arrow_forward_ios),
                      ),
                    )
              ],
            ),
          ),
          if (isThird == true) const SizedBox() else const DotedDivider(),
        ],
      ),
    );
  }
}

class TitleAndSubtitle extends StatelessWidget {
  const TitleAndSubtitle({
    super.key,
    required this.title,
    required this.subtitle,
    this.subtitle3,
    this.crossAxisAlignment,
    this.sbtitleSize,
    this.textScaleFactor,
  });

  final String title;
  final String subtitle;
  final String? subtitle3;
  final CrossAxisAlignment? crossAxisAlignment;
  final double? sbtitleSize, textScaleFactor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          textScaleFactor: 1.2,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            fontSize: 12,
            height: 1.1,
            color: Color(0xFF4F4F4F),
          ),
        ),
        //
        Text(
          textScaleFactor == null ? '\n$subtitle' : subtitle,
          textScaleFactor: textScaleFactor ?? 1.2,
          maxLines: 2,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            fontSize: sbtitleSize ?? 12,
            height: 1.3,
            color: const Color(0xFF0168FF),
          ),
        ),

        if (subtitle3 != null)
          Text(
            textScaleFactor == null ? '\n$subtitle3' : subtitle,
            textScaleFactor: textScaleFactor ?? 1.2,
            maxLines: 2,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: sbtitleSize ?? 12,
              height: 1.3,
              color: const Color(0xFF0168FF),
            ),
          ),
      ],
    );
  }
}
