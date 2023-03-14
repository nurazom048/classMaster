import 'package:flutter/material.dart';

class ListAccontView extends StatelessWidget {
  const ListAccontView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
                height: 60,
                alignment: Alignment.topLeft,
                child: const CloseButton()),

            //
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: MediaQuery.of(context).size.height - 100,
              child: ListView.builder(
                itemCount: 100,
                itemBuilder: (context, index) {
                  return const Text("data");
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
