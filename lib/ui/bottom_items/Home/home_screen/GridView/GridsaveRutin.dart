// ignore_for_file: unused_local_variable, non_constant_identifier_names, avoid_print, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/home_req/home_req.dart';
import 'package:table/widgets/Alart.dart';
import 'package:table/widgets/custom_rutin_card.dart';

final _SaveRutinPageProvider = StateProvider((ref) => 1);

class Grid_save_rutin extends StatefulWidget {
  const Grid_save_rutin({super.key});

  @override
  State<Grid_save_rutin> createState() => _GridViewRutinState();
}

class _GridViewRutinState extends State<Grid_save_rutin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer(builder: (context, ref, _) {
        final page = ref.read(_SaveRutinPageProvider);

        final _SaveRutins =
            ref.watch(save_rutins_provider(ref.watch(_SaveRutinPageProvider)));

        return _SaveRutins.when(
          data: (data) {
            bool noNextPage =
                data.totalPages == ref.read(_SaveRutinPageProvider);
            bool noPreviusPage = 1 >= ref.read(_SaveRutinPageProvider);
            return Column(
              children: [
                Expanded(
                  flex: 20,
                  child: GridView.builder(
                    itemCount: data.savedRoutines.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, mainAxisExtent: 272),
                    itemBuilder: (context, index) {
                      bool isNotlast = index - 1 != data.savedRoutines.length;
                      return CustomRutinCard(
                        rutinname: data.savedRoutines[index].name,
                      );
                    },
                  ),
                ),

                //
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    alignment: Alignment.center,
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: noPreviusPage
                              ? () {}
                              : () {
                                  print(ref.watch(_SaveRutinPageProvider));
                                  ref
                                      .read(_SaveRutinPageProvider.notifier)
                                      .state--;
                                },
                          child: Text("previus",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: noPreviusPage
                                      ? Colors.black12
                                      : Colors.blue)),
                        ),
                        Text(data.currentPage.toString()),
                        TextButton(
                          onPressed: noNextPage
                              ? () {}
                              : () {
                                  print(ref.read(_SaveRutinPageProvider));
                                  ref
                                      .read(_SaveRutinPageProvider.notifier)
                                      .state++;
                                },
                          child: Text("next",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: noNextPage
                                      ? Colors.black12
                                      : Colors.blue)),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
          error: (error, stackTrace) => Alart.handleError(context, error),
          loading: () => const Text("loading"),

          //
        );
      }),
    );
  }
}
