// ignore_for_file: unused_local_variable, non_constant_identifier_names, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/home_req/home_req.dart';
import 'package:table/widgets/Alart.dart';
import 'package:table/widgets/custom_rutin_card.dart';

final pageProvider = StateProvider((ref) => 1);

class GridViewRutin extends StatefulWidget {
  const GridViewRutin({super.key});

  @override
  State<GridViewRutin> createState() => _GridViewRutinState();
}

int currentPage = 1;

class _GridViewRutinState extends State<GridViewRutin> {
  @override
  Widget build(BuildContext context) {
    print("object");
    return Scaffold(
      appBar: AppBar(),

      //
      body: Consumer(builder: (context, ref, _) {
        final page = ref.read(pageProvider);
        final uploaded_rutin = ref.watch(uploaded_rutin_provider(currentPage));
        return uploaded_rutin.when(
          data: (data) {
            return GridView.builder(
              itemCount: data.uploaded_rutin.length + 1,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisExtent: 272),
              itemBuilder: (context, index) {
                bool isNotlast = index - 1 != data.uploaded_rutin.length - 1;
                return isNotlast
                    ? CustomRutinCard(
                        rutinname: data.uploaded_rutin[index].name,
                      )
                    : SizedBox(
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            TextButton(
                              child: const Text("previus"),
                              onPressed: () {
                                print(currentPage);
                                setState(() {
                                  currentPage--;
                                });
                              },
                            ),
                            Text(data.currentPage.toString()),
                            TextButton(
                              child: const Text("next"),
                              onPressed: () {
                                print(currentPage);
                                setState(() {
                                  currentPage++;
                                });
                              },
                            ),
                          ],
                        ),
                      );
              },
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
