// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/constant/constant.dart';
import 'package:table/core/component/loaders.dart';
import 'package:table/core/dialogs/alart_dialogs.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/sunnary_section/summat_screens/add_summary.dart';
import 'package:table/widgets/error/error.widget.dart';
import '../../controller/chack_status_controller.dart';
import '../sunnary Controller/summary_controller.dart';
import '../widgets/add_summary_button.dart';
import '../widgets/chats.dribles .dart';
import '../widgets/summary_header.dart';

// ignore: constant_identifier_names
const String DEMO_PROFILE_IMAGE =
    "https://icon-library.com/images/person-icon-png/person-icon-png-1.jpg";

class SummaryScreen extends ConsumerWidget {
  final String classId;
  final String routineID;
  //Header
  final String? className;
  final String? subjectCode;
  final String? instructorName;
  //
  final DateTime? startTime;
  final DateTime? endTime;
  final int? start; //priode start
  final int? end; //priode end
  final String? room;

  SummaryScreen({
    super.key,
    required this.classId,
    required this.routineID,
    required this.className,
    required this.instructorName,
    required this.subjectCode,
    this.startTime,
    this.endTime,
    this.start,
    this.end,
    this.room,
  });

  final scrollController = ScrollController();

  // @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("ClassId : $classId");

    //! provider
    final allSummary = ref.watch(sunnaryControllerProvider(classId));
    final chackStatus = ref.watch(chackStatusControllerProvider(routineID));

    String status = chackStatus.value?.activeStatus ?? '';
    final bool isCaptain = chackStatus.value?.isCaptain ?? false;
    final bool isOwner = chackStatus.value?.isOwner ?? false;

    return SafeArea(
      child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(
                child: SummaryHeader(
                  classId: classId,
                  className: className,
                  instructorName: instructorName,

                  //
                  startTime: startTime,
                  endTime: endTime,
                  start: start,
                  end: end,
                  room: room,
                ),
              ),
            ],
            body: Container(
              color: Colors.black12,
              height: MediaQuery.of(context).size.height,
              child: Builder(builder: (context) {
                if (status != 'joined') {
                  return ErrorScreen(error: Const.CANT_SEE_SUMMARYS);
                }
                return Container(
                  child: allSummary.when(
                    data: (data) {
                      if (data.summaries.isEmpty) {
                        return const ErrorScreen(error: "There is no Summarys");
                      }

                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        scrollController
                            .jumpTo(scrollController.position.maxScrollExtent);
                      });

                      return ListView.builder(
                        controller: scrollController,
                        // reverse: true,
                        itemCount: data.summaries.length,
                        itemBuilder: (context, i) {
                          int lenght = data.summaries.length;
                          return Column(
                            children: [
                              ChatsDribles(summary: data.summaries[i]),
                              if (lenght > 2 && i == lenght - 1)
                                const SizedBox(height: 100)
                            ],
                          );
                        },
                      );
                    },
                    error: (error, stackTrace) =>
                        Alart.handleError(context, error),
                    loading: () => Loaders.center(),
                  ),
                );
              }),
            ),

            ///
          ),

          //... Add summary icon.....//
          floatingActionButton: isCaptain == true || isOwner
              ? AddSummaryButton(
                  onTap: () {
                    print("onTAp");

                    return Navigator.push(
                      context,
                      CupertinoPageRoute(
                          fullscreenDialog: true,
                          builder: (context) =>
                              AddSummaryScreen(classId: classId)),
                    );
                  },
                )
              : const SizedBox()),
    );
  }
}

// //////////////////////////////////////
// class ChatsDribles extends StatelessWidget {
//   final Summary summary;

//   const ChatsDribles({
//     Key? key,
//     required this.summary,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       color: Colors.blueAccent,
//       constraints: const BoxConstraints(
//           minHeight: 350, minWidth: double.infinity, maxHeight: 400),
//       child: Container(
//         width: 310,
//         height: 70,
//         margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 30)
//             .copyWith(bottom: 70),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: const Color(0xFFE4F0FF),
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: const Color(0xFFD9D9D9)),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(width: 8),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         CircleAvatar(
//                           backgroundColor: Colors.black,
//                           backgroundImage: NetworkImage(
//                             summary.owner?.image ?? DEMO_PROFILE_IMAGE,
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               summary.owner?.name ?? '',
//                               textScaleFactor: 1.4,
//                               style: const TextStyle(
//                                 fontFamily: 'Inter',
//                                 fontWeight: FontWeight.w400,
//                                 fontSize: 12,
//                                 color: Colors.black,
//                               ),
//                             ),
//                             Text(
//                               Utils.formatDate(summary.createdAt),
//                               style: const TextStyle(
//                                 fontFamily: 'Inter',
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 12,
//                                 color: Color(0xFF0168FF),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 12),
//                     const SizedBox(
//                         height: 8, width: 150, child: DotedDivider()),
//                     const SizedBox(height: 4),
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width - 80,
//                       child: Text(
//                         summary.text ?? '',
//                         textScaleFactor: 1.3,
//                         style: const TextStyle(
//                           fontFamily: 'Inter',
//                           fontWeight: FontWeight.w400,
//                           fontSize: 14,
//                           height: 1.43,
//                           color: Colors.black,
//                         ),
//                         maxLines: 4,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const Spacer(),
//                 IconButton(onPressed: (){}, icon:const Icon( Icons.more_vert)),

//             ///
//             ///
//             ///
//             const Spacer(),

//             Container(
//               // color: Colors.blueAccent,
//               constraints: const BoxConstraints(minHeight: 0, maxHeight: 100),
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: summary.imageLinks.length,
//                 itemBuilder: (context, i) => Container(
//                   alignment: Alignment.centerLeft,
//                   width: 100,
//                   height: 100,
//                   margin: const EdgeInsets.symmetric(horizontal: 10),
//                   decoration: const BoxDecoration(
//                     color: Colors.black12,
//                     shape: BoxShape.rectangle,
//                   ),
//                   child: Image(
//                     image: NetworkImage(summary.imageUrls[i]),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20)
//           ],
//         ),
      
//     )) ]);
//   }
// }
