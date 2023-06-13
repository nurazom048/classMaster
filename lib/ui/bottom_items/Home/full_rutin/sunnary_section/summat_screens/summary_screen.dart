// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/core/component/loaders.dart';
import 'package:table/core/dialogs/alart_dialogs.dart';
import 'package:table/models/class_details_model.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/sunnary_section/summat_screens/add_summary.dart';
import '../sunnary Controller/summary_controller.dart';
import '../widgets/add_summary_button.dart';
import '../widgets/chats.dribles .dart';
import '../widgets/summary_header.dart';

// ignore: constant_identifier_names
const String DEMO_PROFILE_IMAGE =
    "https://icon-library.com/images/person-icon-png/person-icon-png-1.jpg";

class SummaryScreen extends StatefulWidget {
  final String classId;
  final Day? day;

  const SummaryScreen({
    super.key,
    required this.classId,
    this.day,
  });

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    print("ClassId : ${widget.classId}");

    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            const SliverToBoxAdapter(child: SummaryHeader()),
          ],
          body: Container(
            color: Colors.black12,
            height: MediaQuery.of(context).size.height,
            child: Consumer(builder: (context, ref, _) {
              //! provider
              final allSummary =
                  ref.watch(sunnaryControllerProvider(widget.classId));
              return Column(
                children: [
                  Expanded(
                    flex: 10,
                    child: allSummary.when(
                      data: (data) {
                        if (data.summaries.isEmpty) {
                          return const Center(
                              child: Text("There is no Summarys"));
                        }
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          // reverse: true,
                          itemCount: data.summaries.length,
                          itemBuilder: (context, i) {
                            return ChatsDribles(
                              summary: data.summaries[i],
                            );
                          },
                        );
                      },
                      error: (error, stackTrace) =>
                          Alart.handleError(context, error),
                      loading: () => Loaders.center(),
                    ),
                  ),
                ],
              );
            }),
          ),

          ///
        ),

        //... Add summary icon.....//
        floatingActionButton: AddSummaryButton(
          onTap: () {
            print("onTAp");

            return Navigator.push(
              context,
              CupertinoPageRoute(
                  fullscreenDialog: true,
                  builder: (context) =>
                      AddSummaryScreen(classId: widget.classId)),
            );
          },
        ),
      ),
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
