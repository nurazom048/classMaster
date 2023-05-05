import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/search/search_screen/search_page.dart';
import 'package:table/widgets/progress_indicator.dart';
import 'package:flutter/material.dart' as ma;

import '../../../../core/dialogs/Alart_dialogs.dart';
import '../../Home/full_rutin/widgets/rutin_box/rutin_box_by_id.dart';
import '../search_request/search_request.dart';

class SearchRutineScreen extends ConsumerWidget {
  const SearchRutineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //! provider
    final searchText = ref.watch(Serarch_String_Provider);
    final searchRoutine = ref.watch(searchRoutineProvider(searchText));

    //
    return SizedBox(
        height: 500,
        width: MediaQuery.of(context).size.width,
        child: searchRoutine.when(
          data: (eitherData) {
            return eitherData.fold(
                (error) => Alart.handleError(context, error.message),
                (data) => data != null
                    ? ListView.builder(
                        itemCount: data.routine.length,
                        itemBuilder: (context, index) {
                          return RutinBoxById(
                              rutinName: data.routine[index].name,
                              onTapMore: () {},
                              rutinId: data.routine[index].id);
                        },
                      )
                    : const ma.Text("no Rutin Found"));
          },
          error: (error, stackTrace) => Alart.handleError(context, error),
          loading: () => const Progressindicator(),
        ));
  }
}
