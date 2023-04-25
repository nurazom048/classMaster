import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Account/accounu_ui/save_screen.dart';
import 'package:table/ui/bottom_items/Home/home_req/uploaded_rutine_controller.dart';
import 'package:table/widgets/progress_indicator.dart';

import '../../../../core/dialogs/Alart_dialogs.dart';
import '../../../../widgets/appWidget/appText.dart';
import '../../../../widgets/heder/hederTitle.dart';

class AllUploadesRutinesMini extends StatelessWidget {
  const AllUploadesRutinesMini({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(builder: (context, ref, _) {
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
                          return MiniRutineCard(
                            rutinId: data.rutins[index].id,
                            rutineName: data.rutins[index].name,
                            owerName: data.rutins[index].owner.name ?? "",
                            image: data.rutins[index].owner.id,
                            username: data.rutins[index].owner.username,
                          );
                        },
                      );
                    },
                    error: (error, stackTrace) =>
                        Alart.handleError(context, error),
                    loading: () => Container(
                          height: 30,
                          width: 30,
                          child: Progressindicator(),
                        )),
              ),
            )
          ],
        );
      }),
    );
  }
}
