// ignore_for_file: unused_local_variable, non_constant_identifier_names, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/home_req/home_req.dart';
import 'package:table/widgets/custom_rutin_card.dart';
import '../../core/dialogs/Alart_dialogs.dart';

final pageProvider = StateProvider((ref) => 1);

class gridJoinRutins extends StatefulWidget {
  const gridJoinRutins({super.key});

  @override
  State<gridJoinRutins> createState() => _GridViewRutinState();
}

class _GridViewRutinState extends State<gridJoinRutins> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer(builder: (context, ref, _) {
        //! providers
        final page = ref.read(pageProvider);
        final joined_rutin =
            ref.watch(joined_rutin_provider(ref.watch(pageProvider)));

        return joined_rutin.when(
          data: (data) {
            bool noNextPage = data.totalPages == ref.read(pageProvider);
            bool noPreviusPage = 1 >= ref.read(pageProvider);
            return Column(
              children: [
                Expanded(
                  flex: 20,
                  child: GridView.builder(
                    itemCount: data.routines.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, mainAxisExtent: 272),
                    itemBuilder: (context, index) {
                      bool isNotlast = index - 1 != data.routines.length;
                      var indivisuRutin = data.routines[index];

                      //!
                      return CustomRutinCard(
                        rutinModel: data.routines[index],
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
                                  print(ref.watch(pageProvider));
                                  ref.read(pageProvider.notifier).state--;
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
                                  print(ref.read(pageProvider));
                                  ref.read(pageProvider.notifier).state++;
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
