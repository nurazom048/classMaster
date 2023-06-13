import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table/widgets/appWidget/dottted_divider.dart';
import '../../../../../../models/class_details_model.dart';

class RutineCardInfoRow extends StatelessWidget {
  final Day? day;
  final bool? isFrist;
  final dynamic onTap;
  final Widget? taill;
  const RutineCardInfoRow(
      {super.key, this.isFrist, this.onTap, this.day, this.taill});
  String formatTime(DateTime? time) {
    return DateFormat.jm().format(time ?? DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          if (isFrist == true) const DotedDivider(),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // if (taill == null)
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
                  title: day?.classId.instuctorName ?? " instuctorName ",
                  subtitle: day?.classId.subjectcode ?? "instuctorName",
                ),

                const Spacer(),
                if (taill != null) SizedBox.shrink(),
                // const VerticalDivider(thickness: 4, color: Colors.red),

                //
                taill ??
                    InkWell(
                      onTap: onTap ?? () {},
                      child: Container(
                        padding: const EdgeInsets.only(right: 2),
                        alignment: AlignmentDirectional.center,
                        child: const Icon(Icons.arrow_forward_ios),
                      ),
                    )
              ],
            ),
          ),
          const DotedDivider(),
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
    this.crossAxisAlignment,
    this.sbtitleSize,
    this.textScaleFactor,
  });

  final String title;
  final String subtitle;
  final CrossAxisAlignment? crossAxisAlignment;
  final double? sbtitleSize, textScaleFactor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
      children: [
        Text(
          " $title",
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
          textScaleFactor == null ? '\n- $subtitle' : subtitle,
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
