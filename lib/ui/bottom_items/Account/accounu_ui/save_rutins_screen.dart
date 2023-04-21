import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Account/accounu_ui/save_screen.dart';
import 'package:table/ui/bottom_items/Home/home_req/home_req.dart';
import 'package:table/widgets/progress_indicator.dart';

import '../../../../core/dialogs/Alart_dialogs.dart';
import '../../../../widgets/appWidget/appText.dart';
import '../../../../widgets/heder/hederTitle.dart';

class SaveRutinsScreen extends StatelessWidget {
  const SaveRutinsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final saveRutine = ref.watch(save_rutins_provider(1));
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          HeaderTitle("", context),
          const SizedBox(height: 10),
          const AppText("  All Save Rutines").title(),
          const SizedBox(height: 15),
          Expanded(
            child: Container(
              child: saveRutine.when(
                  data: (data) {
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.savedRoutines.length,
                      itemBuilder: (context, index) {
                        return MiniRutineCard(
                          rutinId: data.savedRoutines[index].id,
                          rutineName: data.savedRoutines[index].name,
                          owerName: data.savedRoutines[index].owner.name,
                          image: data.savedRoutines[index].owner.id,
                          username: data.savedRoutines[index].owner.username,
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
    });
  }
}
