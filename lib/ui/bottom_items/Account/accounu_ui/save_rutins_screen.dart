import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Account/accounu_ui/save_screen.dart';
import 'package:table/ui/bottom_items/Home/home_req/home_req.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/widgets/rutin_box/rutin_box_by_id.dart';
import 'package:table/widgets/progress_indicator.dart';

import '../../../../core/dialogs/alart_dialogs.dart';
import '../../../../widgets/appWidget/appText.dart';
import '../../../../widgets/heder/heder_title.dart';

class SaveRutinsScreen extends StatelessWidget {
  const SaveRutinsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final saveRutine = ref.watch(save_rutins_provider(1));
      return NestedScrollView(
        physics: NeverScrollableScrollPhysics(),
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: Container(
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  HeaderTitle("", context),
                  const SizedBox(height: 10),
                  const AppText("  All Save Rutines").title(),
                ],
              ),
            ),
          )
        ],
        body: saveRutine.when(
            data: (data) {
              return Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 100),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.savedRoutines.length,
                  itemBuilder: (context, index) {
                    return RutinBoxById(
                      rutinId: data.savedRoutines[index].id,
                      rutinName: data.savedRoutines[index].name,
                      onTapMore: () {},
                    );
                  },
                ),
              );
            },
            error: (error, stackTrace) => Alart.handleError(context, error),
            loading: () => const SizedBox(
                  height: 30,
                  width: 30,
                  child: Progressindicator(),
                )),
      );
    });
  }
}
