import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/search/search_screen/search_page.dart';
import 'package:table/widgets/error/error.widget.dart';

import '../../../../core/component/Loaders.dart';
import '../../../../core/dialogs/alart_dialogs.dart';
import '../../Home/full_rutin/widgets/rutin_box/rutin_box_by_id.dart';
import '../search controller/search_rutine_controllers.dart';

class SearchRutineScreen extends ConsumerWidget {
  const SearchRutineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //! provider
    final searchText = ref.watch(Serarch_String_Provider);
    final searchRoutine = ref.watch(searchRutineController(searchText));

    //
    return SizedBox(
        height: 500,
        width: MediaQuery.of(context).size.width,
        child: searchRoutine.when(
          data: (data) {
            return ListView.builder(
              itemCount: data.routine.length,
              itemBuilder: (context, index) {
                return RutinBoxById(
                    margin: EdgeInsets.zero,
                    rutinName: data.routine[index].name,
                    onTapMore: () {},
                    rutinId: data.routine[index].id);
              },
            );
          },
          error: (error, stackTrace) {
            Alart.handleError(context, error);
            return ErrorScreen(error: error.toString());
          },
          loading: () => Loaders.center(),
        ));
  }
}
