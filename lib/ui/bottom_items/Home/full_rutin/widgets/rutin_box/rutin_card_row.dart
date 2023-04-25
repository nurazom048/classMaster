import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table/widgets/appWidget/dottted_divider.dart';
import '../../../../../../models/ClsassDetailsModel.dart';

class RutineCardInfoRow extends StatelessWidget {
  final Day? day;
  final bool? isFrist;
  final dynamic onTap;
  const RutineCardInfoRow({super.key, this.isFrist, this.onTap, this.day});
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
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.1,
                      child: Text(
                        day?.name ?? "subject Name ",
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
                    ),
                    //

                    Text(
                      '\n- ${day?.instuctorName ?? "instuctorName"}',
                      textScaleFactor: 1.2,
                      maxLines: 2,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        height: 1.1,
                        color: Color(0xFF0168FF),
                      ),
                    ),
                  ],
                ),
                const Spacer(),

                //
                InkWell(
                    onTap: onTap ?? () {},
                    child: Container(
                        padding: const EdgeInsets.only(right: 2),
                        alignment: AlignmentDirectional.center,
                        child: const Icon(Icons.arrow_forward_ios)))
              ],
            ),
          ),
          const DotedDivider(),
        ],
      ),
    );
  }
}
