// ignore_for_file: curly_braces_in_flow_control_structures, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/core/dialogs/Alart_dialogs.dart';
import 'package:table/helper/constant/AppColor.dart';
import 'package:table/widgets/heder/hederTitle.dart';

import '../../../../Account/accounu_ui/save_screen.dart';
import '../../request/noticeBoard_request.dart';

// class NoticeBoardScreen extends StatefulWidget {
//   const NoticeBoardScreen({
//     Key? key,
//   }) : super(key: key);

//   @override
//   _ViewMoreState createState() => _ViewMoreState();
// }

// class _ViewMoreState extends State<NoticeBoardScreen>
//     with TickerProviderStateMixin {
//   late TabController controller;

//   @override
//   void initState() {
//     super.initState();
//     controller = TabController(length: 2, vsync: this);
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: NestedScrollView(
//         headerSliverBuilder: (context, innerBoxIsScrolled) => [
//           SliverToBoxAdapter(
//             child: SizedBox(
//               height: 270,
//               width: 300,
//               child: Column(
//                 children: [
//                   HeaderTitle("NoticeBordScreen", context),
//                   const SizedBox(height: 10),
//                   SizedBox(
//                     height: 40,
//                     child: TabBar(
//                         controller: controller,
//                         labelColor: AppColor.nokiaBlue,
//                         unselectedLabelColor: Colors.black,
//                         tabs: const [
//                           Tab(child: Text("Uploded NoticeBord")),
//                           Tab(child: Text("Joined Notice Board")),
//                         ]),
//                   ),
//                 ],
//               ),
//             ),
//           )
//         ],
//         body: TabBarView(
//             controller: controller,
//             children: [UploadedNoticeBordScreen(), JoinedNoticeBoardScreen()]),
//       ),

//       //
//     );
//   }
// }

///
///
class UploadedNoticeBordScreen extends ConsumerWidget {
  const UploadedNoticeBordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //! provider
    final noticeBoardList = ref.watch(uploadedNoticeBoardProvider);

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
              height: 400,
              child: noticeBoardList.when(
                  data: (data) {
                    return ListView.builder(
                      itemCount: data.noticeBoard.length,
                      itemBuilder: (context, index) {
                        return MiniNoticeCard(
                          rutineName: data.noticeBoard[index].name,
                          owerName: data.noticeBoard[index].owner.name,
                          image: data.noticeBoard[index].owner.image,
                          username: data.noticeBoard[index].owner.username,
                          rutinId: data.noticeBoard[index].id,
                        );
                      },
                    );
                  },
                  error: (error, stackTrace) =>
                      Alart.handleError(context, error),
                  loading: () => const Text("loding"))),
        ],
      ),
    );
  }
}

////////////////////////////
///
///
class JoinedNoticeBoardScreen extends StatelessWidget {
  const JoinedNoticeBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
