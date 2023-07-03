// // ignore_for_file: must_be_immutable

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:table/core/dialogs/alert_dialogs.dart';
// import 'package:table/ui/bottom_items/Account/models/account_models.dart';
// import 'package:table/models/class_details_model.dart';
// import 'package:table/ui/bottom_items/Home/Full_routine/Summary/summat_screens/summary_screen.dart';
// import 'package:table/widgets/appWidget/app_text.dart';
// import 'package:table/widgets/appWidget/buttons/expended_button.dart';
// import 'package:table/widgets/appWidget/buttons/capsule_button.dart';
// import 'package:table/ui/bottom_items/Home/Full_routine/widgets/routine_box/rutin_card_row.dart';
// import 'package:table/widgets/mini_account_row.dart';
// import 'package:flutter/material.dart' as ma;

// // ignore: unused_import
// import '../../controller/chack_status_controller.dart';
// import '../../../../../../widgets/appWidget/dotted_divider.dart';
// import '../../../../../../widgets/appWidget/select_day_row.dart';

// class RutinBox extends StatefulWidget {
//   final dynamic onTap;

//   List<Day?> sun;
//   List<Day?> mon;
//   List<Day?> tue;
//   List<Day?> wed;
//   List<Day?> thu;
//   List<Day?> fri;
//   List<Day?> sat;
//   final String rutinNmae;
//   final String rutinId;
//   final AccountModels accountData;
//   final dynamic onTapMore;
//   RutinBox({
//     super.key,
//     this.onTap,
//     required this.rutinNmae,
//     required this.onTapMore,
//     required this.rutinId,
//     required this.accountData,
//     required this.sun,
//     required this.mon,
//     required this.tue,
//     required this.wed,
//     required this.thu,
//     required this.fri,
//     required this.sat,
//   });

//   @override
//   State<RutinBox> createState() => _RutinBoxState();
// }

// class _RutinBoxState extends State<RutinBox> {
//   List<Day?> listOfDays = [];
//   late int lenght = 0;
//   @override
//   Widget build(BuildContext context) {
//     return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
//       const MyDivider(),

//       Container(
//         margin: const EdgeInsets.symmetric(horizontal: 10),
//         padding: const EdgeInsets.symmetric(vertical: 20),
//         child: Consumer(builder: (context, ref, _) {
//           //! providers
//           final chackStatus =
//               ref.watch(chackStatusControllerProvider(widget.rutinId));

//           //! notifier
//           final chackStatusNotifier =
//               ref.watch(chackStatusControllerProvider(widget.rutinId).notifier);

//           String status = chackStatus.value?.activeStatus ?? '';
//           return Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               AppText(widget.rutinNmae).heding(),
//               //

//               chackStatus.when(
//                   data: (data) {
//                     if (status == "joined") {
//                       return CapsuleButton(
//                         "Leave",
//                         color: Colors.red,
//                         icon: Icons.logout,
//                         onTap: () {
//                           return Alert.errorAlertDialogCallBack(
//                             context,
//                             "are you sure you want to leave",
//                             onConfirm: (bool isYes) {
//                               //  Navigator.pop(context);

//                               chackStatusNotifier.leaveMember(context);
//                             },
//                           );
//                         },
//                       );
//                     } else {
//                       return CapsuleButton(
//                         status == "not_joined" ? "send request" : status,
//                         icon:
//                             status == "request_pending" ? null : Icons.telegram,
//                         onTap: () {
//                           chackStatusNotifier.sendReqController(context);
//                         },
//                       );
//                     }
//                   },
//                   error: (error, stackTrace) =>
//                       Alert.handleError(context, error),
//                   loading: () => const ma.Text("data")),
//             ],
//           );
//         }),
//       ),

//       //
//       SelectDayRow(selectedDay: (selectedDay) {
//         switch (selectedDay) {
//           case 0:
//             setState(() {
//               listOfDays = widget.sun;
//             });
//             break;
//           case 1:
//             setState(() {
//               listOfDays = widget.mon;
//             });
//             break;
//           case 2:
//             setState(() {
//               listOfDays = widget.tue;
//             });
//             break;
//           case 3:
//             setState(() {
//               listOfDays = widget.wed;
//             });
//             break;
//           case 4:
//             setState(() {
//               listOfDays = widget.thu;
//             });
//             break;
//           case 5:
//             setState(() {
//               listOfDays = widget.fri;
//             });
//             break;
//           case 6:
//             setState(() {
//               listOfDays = widget.sat;
//             });
//             break;
//         }
//       }),
//       const SizedBox(height: 20),
//       Center(
//         child: Column(
//           children: List.generate(
//             listOfDays.length,
//             (index) {
//               return listOfDays.isNotEmpty
//                   ? RutineCardInfoRow(
//                       isfrist: index == 0,
//                       day: listOfDays[index],
//                       onTap: () => ontap(listOfDays[index]),
//                     )
//                   : const ma.Text("No Class");
//             },
//           ),
//         ),
//       ),

//       //
//       ExpendedButton(onTap: () {
//         setState(() {
//           if (lenght == listOfDays.length) {
//             lenght = 2;
//           } else {
//             lenght = listOfDays.length;
//           }
//         });
//       }),
//       MiniAccountInfo(
//           accountData: widget.accountData, onTapMore: widget.onTapMore),
//       const SizedBox(height: 15)
//     ]);
//   }

//   ontap(Day? day) {
//     Navigator.push(
//       context,
//       CupertinoPageRoute(
//           builder: (context) => SummaryScreen(
//                 classId: day?.classId.id ?? "",
//                 day: day,
//               )),
//     );
//   }
// }
