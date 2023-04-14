// ignore_for_file: non_constant_identifier_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/helper/constant/AppColor.dart';
import 'package:table/ui/bottom_items/Add/create_new_rutine.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/screen/dailog/rutin_dialog.dart';
import 'package:table/ui/bottom_items/Home/home_req/home_req.dart';
import 'package:table/ui/bottom_items/search/search_screen/search_page.dart';
import 'package:table/widgets/TopBar.dart';
import 'package:table/widgets/appWidget/rutin_box/rutin_box_by_id.dart';
import 'package:table/widgets/progress_indicator.dart';
import '../../../../core/dialogs/Alart_dialogs.dart';

final currentPageProvider = StateProvider((ref) => 1);

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.background,
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 60),
          physics: const BouncingScrollPhysics(),
          child: Consumer(builder: (context, ref, _) {
            //! provider
            final pages = ref.watch(currentPageProvider);
            //final saveRutin = ref.watch(save_rutins_provider(1));
            final uploaded_rutin = ref.watch(uploaded_rutin_provider(pages));
            // final joined_rutin = ref.watch(joined_rutin_provider(pages));

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: uploaded_rutin.when(
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
                                      onTapMore: () => RutinDialog
                                          .ChackStatusUser_BottomSheet(
                                              context,
                                              data.rutins[index].id,
                                              data.rutins[index].name),
                                    );
                                  } else {
                                    return const Text(
                                        "You Dont Have any Rutin created");
                                  }
                                },
                              ));
                            },
                            loading: () => const Progressindicator(),
                            error: (error, stackTrace) =>
                                Alart.handleError(context, error),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}
