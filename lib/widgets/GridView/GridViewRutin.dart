// ignore_for_file: unused_local_variable, non_constant_identifier_names, avoid_print, no_leading_underscores_for_local_identifiers, prefer_const_constructors, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/core/component/component_improts.dart';
import 'package:table/ui/bottom_items/Home/home_req/home_req.dart';
import 'package:table/widgets/custom_rutin_card.dart';
import 'package:table/widgets/progress_indicator.dart';
import '../../core/dialogs/Alart_dialogs.dart';
import '../../models/rutins/listOfSaveRutin.dart';
import '../../models/rutins/rutins.dart';

//final pageProvider = StateProvider((ref) => 1);

class GridViewRutin extends StatelessWidget {
  const GridViewRutin({super.key});

  @override
  Widget build(BuildContext context) {
    ///
    final scrollController = ScrollController();

    return SafeArea(
      child: Scaffold(
        body: Consumer(builder: (context, ref, _) {
          final uploaded_ruti = ref.watch(UpRutinProvider);

          return uploaded_ruti.when(
            data: (data) {
              List<Routine> listtt = data.rutins;

              //
              _scrollLiser() {
                if (scrollController.position.pixels ==
                    scrollController.position.maxScrollExtent) {
                  //

                  print("liser call");
                  int page = data.currentPage ?? 1;
                  int totla = data.totalPages ?? 1;
                  print(data.rutins);
                  if (page != totla) {
                    ref.read(UpRutinProvider.notifier).loadMore(page++);
                  }
                } else {
                  print("call");
                }
              }

              scrollController.addListener(_scrollLiser);

              return Column(
                children: [
                  CrossBar(context),
                  Expanded(
                    flex: 20,
                    child: GridView.builder(
                      controller: scrollController,
                      itemCount: data.rutins.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, mainAxisExtent: 272),
                      itemBuilder: (context, index) {
                        bool isNotlast = index - 1 != data.rutins.length;

                        return CustomRutinCard(
                          rutinModel: data.rutins[index],
                        );
                      },
                    ),
                  ),
                ],
              );
            },
            error: (error, stackTrace) => Alart.handleError(context, error),
            loading: () => Container(
                alignment: Alignment.center, child: const Progressindicator()),

            //
          );
        }),
      ),
    );
  }
}

//_________________________
final UpRutinProvider =
    StateNotifierProvider.autoDispose<Uprutin, AsyncValue<ListOfUploedRutins>>(
        (ref) {
  return Uprutin(ref);
});

class Uprutin extends StateNotifier<AsyncValue<ListOfUploedRutins>> {
  var ref;
  Uprutin(this.ref) : super(AsyncLoading()) {
    _init();
  }

  _init() async {
    try {
      AsyncValue<ListOfUploedRutins> res =
          await ref.watch(uploaded_rutin_provider(1));

      res.when(
          data: (data) {
            state = AsyncData(data);
          },
          error: (error, stackTrace) {
            print(error.toString());
            state = AsyncError(error, stackTrace);
          },
          loading: () {});
    } catch (e) {
      print(e.toString());
      state = throw Exception(e);
    }
  }

  //
  void loadMore(page) async {
    try {
      AsyncValue<ListOfUploedRutins> res =
          await ref.watch(uploaded_rutin_provider(page + 1));

      res.when(
          data: (data) {
            print("tota ${data.totalPages} : giver page ${page + 1}");
            print(data.rutins.length);

            if (state.value?.totalPages != page) {
              List<Routine> rutins = List.from(state.value!.rutins)
                ..addAll(data.rutins);
              state = AsyncData(state.value!.copyWith(rutins: rutins));
            }
          },
          error: (error, stackTrace) {
            print(error.toString());
            state = AsyncError(error, stackTrace);
          },
          loading: () {});
    } catch (e) {
      print(e.toString());
      state = throw Exception(e);
    }
  }
}
