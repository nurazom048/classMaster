import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/home_req/uploaded_rutine_controller.dart';
import 'package:table/widgets/progress_indicator.dart';

import '../../../../core/dialogs/alart_dialogs.dart';
import '../../../../widgets/appWidget/app_text.dart';
import '../../../../widgets/heder/heder_title.dart';
import '../../Home/full_rutin/widgets/rutin_box/rutin_box_by_id.dart';

class AllUploadesRutinesMini extends StatelessWidget {
  const AllUploadesRutinesMini({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(builder: (context, ref, _) {
        //!provider
        final allUploadesRutinesMini =
            ref.watch(uploadedRutinsControllerProvider);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            HeaderTitle("", context),
            const SizedBox(height: 20),
            const AppText("  All Uploades Rutines").title(),
            const SizedBox(height: 15),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: allUploadesRutinesMini.when(
                    data: (data) {
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.rutins.length,
                        itemBuilder: (context, index) {
                          return RutinBoxById(
                            rutinName: data.rutins[index].name,
                            rutinId: data.rutins[index].id,
                            //
                            onTapMore: () {},
                          );
                        },
                      );
                    },
                    error: (error, stackTrace) =>
                        Alart.handleError(context, error),
                    loading: () => const SizedBox(
                          height: 30,
                          width: 30,
                          child: Progressindicator(),
                        ),),
              ),
            )
          ],
        );
      }),
    );
  }
}
