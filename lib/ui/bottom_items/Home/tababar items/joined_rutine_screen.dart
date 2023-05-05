import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/utils/rutin_dialog.dart';

import 'package:flutter/material.dart' as ma;

import '../../../../core/dialogs/alart_dialogs.dart';
import '../../../../helper/constant/app_color.dart';
import '../full_rutin/widgets/rutin_box/rutin_box_by_id.dart';
import '../../../../widgets/progress_indicator.dart';
import '../home_req/uploaded_rutine_controller.dart';

final currentPageProvider = StateProvider((ref) => 1);

class JoinedRutineScreen extends StatelessWidget {
  const JoinedRutineScreen({super.key});

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

            final uploaded_rutin = ref.watch(uploadedRutinsControllerProvider);

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
                                      rutinName: data.rutins[index].name,
                                      onTapMore: () => RutinDialog
                                          .ChackStatusUser_BottomSheet(
                                              context,
                                              data.rutins[index].id,
                                              data.rutins[index].name),
                                    );
                                  } else {
                                    return const ma.Text(
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
