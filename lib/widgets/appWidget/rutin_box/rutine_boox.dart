// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table/models/Account_models.dart';
import 'package:table/models/ClsassDetailsModel.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/sunnary/summat_screens/summary_screen.dart';
import 'package:table/widgets/appWidget/appText.dart';
import 'package:table/widgets/appWidget/buttons/Expende_button.dart';
import 'package:table/widgets/appWidget/buttons/capsule_button.dart';
import 'package:table/widgets/mini_account_row.dart';
import '../dottted_divider.dart';
import '../selectDayRow.dart';

class RutinBox extends StatefulWidget {
  final dynamic onTap;

  List<Day?> sun;
  List<Day?> mon;
  List<Day?> tue;
  List<Day?> wed;
  List<Day?> thu;
  List<Day?> fri;
  List<Day?> sat;
  final String rutinNmae;
  final AccountModels accountData;
  RutinBox({
    super.key,
    this.onTap,
    required this.rutinNmae,
    required this.accountData,
    required this.sun,
    required this.mon,
    required this.tue,
    required this.wed,
    required this.thu,
    required this.fri,
    required this.sat,
  });

  @override
  State<RutinBox> createState() => _RutinBoxState();
}

class _RutinBoxState extends State<RutinBox> {
  List<Day?> listOfDays = [];
  late int lenght = 0;
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      const MyDivider(),

      Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(widget.rutinNmae).heding(),
            //
            CapsuleButton(
              "send request",
              onTap: () {},
            )
          ],
        ),
      ),

      //
      SelectDayRow(selectedDay: (selectedDay) {
        switch (selectedDay) {
          case 0:
            setState(() {
              listOfDays = widget.sun;
            });
            break;
          case 1:
            setState(() {
              listOfDays = widget.mon;
            });
            break;
          case 2:
            setState(() {
              listOfDays = widget.tue;
            });
            break;
          case 3:
            setState(() {
              listOfDays = widget.wed;
            });
            break;
          case 4:
            setState(() {
              listOfDays = widget.thu;
            });
            break;
          case 5:
            setState(() {
              listOfDays = widget.fri;
            });
            break;
          case 6:
            setState(() {
              listOfDays = widget.sat;
            });
            break;
        }
      }),
      const SizedBox(height: 20),
      Center(
        child: Column(
          children: List.generate(
            listOfDays.length,
            (index) {
              return listOfDays.isNotEmpty
                  ? RutineCardInfoRow(
                      isFrist: index == 0,
                      day: listOfDays[index],
                      onTap: () => ontap(listOfDays[index]),
                    )
                  : const Text("No Class");
            },
          ),
        ),
      ),

      //
      ExpendedButton(onTap: () {
        setState(() {
          if (lenght == listOfDays.length) {
            lenght = 2;
          } else {
            lenght = listOfDays.length;
          }
        });
      }),
      MiniAccountInfo(accountData: widget.accountData),
      const SizedBox(height: 15)
    ]);
  }

  ontap(Day? day) {
    Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => SummaryScreen(classId: day?.id ?? "")),
    );
  }
}

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
