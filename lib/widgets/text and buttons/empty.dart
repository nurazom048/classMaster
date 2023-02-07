import 'package:flutter/material.dart';

class Empty extends StatelessWidget {
  bool corner;
  bool mini;
  Empty({super.key, this.corner = false, this.mini = false});

  @override
  Widget build(BuildContext context) {
    return corner == true
        ? Container(
            height: mini == true ? 50 : 100,
            width: mini == true ? 50 : 100,
            decoration: const BoxDecoration(
                color: Color.fromRGBO(68, 114, 196, 40),
                border:
                    Border(right: BorderSide(color: Colors.black45, width: 1))),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Column(
                children: [
                  Text(
                    "Priode",
                    style: mini == true
                        ? const TextStyle(fontSize: 10)
                        : const TextStyle(),
                  ),
                  Divider(
                      color: Colors.black87,
                      height: mini == true ? 2 : 10,
                      thickness: .5),
                  Column(
                    children: [
                      Text(
                        "Priode",
                        style: mini == true
                            ? const TextStyle(fontSize: 10)
                            : const TextStyle(),
                      ),
                      Text(
                        "Days",
                        style: mini == true
                            ? const TextStyle(fontSize: 10)
                            : const TextStyle(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        : const SizedBox(
            height: 100,
            width: 200,
            child: Center(
              child: Text("No Class yeat "),
            ),
          );
  }
}
