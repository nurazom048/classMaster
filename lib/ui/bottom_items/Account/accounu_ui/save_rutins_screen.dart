import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/home_req/home_req.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/widgets/rutin_box/rutin_box_by_id.dart';

import '../../../../core/component/Loaders.dart';
import '../../../../core/dialogs/alart_dialogs.dart';
import '../../../../widgets/heder/heder_title.dart';

class SaveRoutinesScreen extends ConsumerWidget {
  const SaveRoutinesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //! provider
    final saveRoutines = ref.watch(save_rutins_provider(1));

    return Scaffold(
      body: Column(
        children: [
          HeaderTitle("All Save Routines", context),
          const SizedBox(height: 25),
          Expanded(
            child: Container(
              child: saveRoutines.when(
                data: (data) {
                  return ListView.builder(
                    itemCount: data.savedRoutines.length,
                    // physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return RutinBoxById(
                        rutinId: data.savedRoutines[index].id,
                        rutinName: data.savedRoutines[index].name,
                        onTapMore: () {},
                      );
                    },
                  );
                },
                error: (error, stackTrace) => Alart.handleError(context, error),
                loading: () => Loaders.center(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
