// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:classmate/core/component/loaders.dart';

// import '../../../../core/dialogs/alert_dialogs.dart';
// import '../../../../widgets/appWidget/app_text.dart';
// import '../../Home/notice_board/request/noticeboard_noticeRequest.dart';

// class SelectNoticeBoardDropDowen extends StatefulWidget {
//   final Function(String?) onSelected;

//   const SelectNoticeBoardDropDowen({
//     Key? key,
//     required this.onSelected,
//   }) : super(key: key);

//   @override
//   _MyDropdownButtonState createState() => _MyDropdownButtonState();
// }

// class _MyDropdownButtonState extends State<SelectNoticeBoardDropDowen> {
//   int? _selectedItemIndex;

//   @override
//   Widget build(BuildContext context) {
//     return Consumer(builder: (context, ref, _) {
//       final noticeBoardList = ref.watch(createdNoticeBoardNmae);

//       return Container(
//         width: 340,
//         height: 46,
//         margin: const EdgeInsets.symmetric(horizontal: 17).copyWith(top: 20),
//         padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
//         decoration: BoxDecoration(
//           color: const Color(0xFFEEF4FC),
//           border: Border.all(color: const Color(0xFF0168FF)),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: noticeBoardList.when(
//           data: (data) {
//             // ignore: unnecessary_null_comparison
//             if (data == null) {
//               return const Text("No Notice Board is not  created");
//             }

//             return DropdownButtonHideUnderline(
//               child: GestureDetector(
//                 onTap: () {
//                   setState(() {});
//                 },
//                 child: DropdownButton<int?>(
//                   value: _selectedItemIndex,
//                   onChanged: (int? newIndex) {
//                     setState(() {
//                       _selectedItemIndex = newIndex;
//                       if (_selectedItemIndex != null) {
//                         widget.onSelected(
//                             data.noticeBoards[_selectedItemIndex!].id);
//                       }
//                     });
//                   },
//                   items: [
//                     DropdownMenuItem(
//                       value: null,
//                       child: const AppText(
//                         'Select notice board',
//                         color: Colors.grey,
//                       ).heding(),
//                     ),
//                     ...data.noticeBoards
//                         .asMap()
//                         .map((index, notice) {
//                           return MapEntry(
//                             index,
//                             DropdownMenuItem<int>(
//                               value: index,
//                               child: AppText(
//                                 notice.name,
//                               ).heding(),
//                             ),
//                           );
//                         })
//                         .values
//                         .toList(),
//                   ],
//                 ),
//               ),
//             );
//           },
//           error: (error, stackTrace) => Alert.handleError(context, error),
//           loading: () => Loaders.button(),
//         ),
//       );
//     });
//   }
// }
