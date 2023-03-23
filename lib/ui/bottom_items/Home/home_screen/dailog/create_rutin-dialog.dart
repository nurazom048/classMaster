//.... Create Rutin
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table/ui/bottom_items/Home/home_req/rutinReq.dart';

void createRutinDialog(context) {
  final rutinName = TextEditingController();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(" Create Rutin "),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: rutinName,
              decoration: const InputDecoration(hintText: "Enter Rutin name"),
            ),
            const SizedBox(height: 17),

            //... create rutin button .../
            Align(
              alignment: Alignment.bottomRight,
              child: CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                color: Colors.blue,
                child: const Text("Create"),
                onPressed: () {
                  RutinReqest().creatRutin(rutinName: rutinName);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
