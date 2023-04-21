import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Account/accounu_ui/save_screen.dart';
import 'package:table/ui/bottom_items/Home/home_req/home_req.dart';
import 'package:table/widgets/progress_indicator.dart';

import '../../../../core/dialogs/Alart_dialogs.dart';
import '../../../../widgets/appWidget/appText.dart';
import '../../../../widgets/heder/hederTitle.dart';

class joinedRutines extends StatelessWidget {
  const joinedRutines({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(builder: (context, ref, _) {
        final JoinedRutines = ref.watch(joined_rutin_provider(1));
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            HeaderTitle("", context),
            const SizedBox(height: 20),
            const AppText("  All Joined Rutines").title(),
            const SizedBox(height: 15),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: JoinedRutines.when(
                    data: (data) {
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.routines.length,
                        itemBuilder: (context, index) {
                          return MiniRutineCard(
                            rutinId: data.routines[index].id,
                            rutineName: data.routines[index].name,
                            owerName: data.routines[index].owner.name,
                            image: data.routines[index].owner.id,
                            username: data.routines[index].owner.username,
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
