// ignore_for_file: non_constant_identifier_names, use_key_in_widget_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/screen/dailog/rutin_dialog.dart';
import 'package:table/ui/bottom_items/Home/home_req/home_req.dart';
import 'package:table/ui/bottom_items/Home/notice/noticeRequest.dart';
import 'package:table/ui/bottom_items/Home/notice/viewAllRecentNotice.dart';
import 'package:table/widgets/appWidget/rutin_box/rutin_box_by_id.dart';
import 'package:table/widgets/progress_indicator.dart';
import '../../../../core/dialogs/Alart_dialogs.dart';
import '../../../../main.dart';
import '../widgets/custom_title_bar.dart';

final currentPageProvider = StateProvider((ref) => 1);

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F2F2),
        body: SingleChildScrollView(
          //padding: const EdgeInsets.only(bottom: 60),
          physics: const BouncingScrollPhysics(),
          child: Consumer(builder: (context, ref, _) {
            //! provider
            final pages = ref.watch(currentPageProvider);
            //final saveRutin = ref.watch(save_rutins_provider(1));
            final uploaded_rutin = ref.watch(uploaded_rutin_provider(pages));
            final recentNoticeList = ref.watch(recentNoticeProvider);
            // final joined_rutin = ref.watch(joined_rutin_provider(pages));

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ChustomTitleBar("title"),
                RecentNotice(
                  child: recentNoticeList.when(
                      data: (data) {
                        return data.fold(
                            (error) => Alart.handleError(context, error),
                            (r) => Column(
                                  children: List.generate(
                                    r.notices.length >= 3
                                        ? 3
                                        : r.notices.length,
                                    (index) => NoticeRow(
                                      notice: r.notices[index],
                                      date: r.notices[index].time.toString(),
                                      title: r.notices[index].contentName,
                                    ),
                                  ),
                                ));
                      },
                      error: (error, stackTrace) =>
                          Alart.handleError(context, error),
                      loading: () => const Text("loding")),

                  //
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const ViewAllRecentNotice()),
                    );
                  },
                ),
                uploaded_rutin.when(
                  data: (data) {
                    // data
                    var lenght = data.rutins;

                    return Column(
                        children: List.generate(
                      data.rutins.length,
                      (index) {
                        if (lenght.isNotEmpty) {
                          return RutinBoxById(
                            rutinId: data.rutins[index].id,
                            rutinNmae: data.rutins[index].name,
                            onTapMore: () =>
                                RutinDialog.ChackStatusUser_BottomSheet(
                                    context,
                                    data.rutins[index].id,
                                    data.rutins[index].name),
                          );
                        } else {
                          return const Text("You Dont Have any Rutin created");
                        }
                      },
                    ));
                  },
                  loading: () => const Progressindicator(),
                  error: (error, stackTrace) =>
                      Alart.handleError(context, error),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
