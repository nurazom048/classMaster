import 'package:flutter/material.dart';

class CornerBox extends StatelessWidget {
  bool? mini = false;
  CornerBox({Key? key, this.mini}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mini == true ? 50 : 100,
      width: mini == true ? 50 : 100,
      decoration: const BoxDecoration(
          color: Color.fromRGBO(68, 114, 196, 40),
          border: Border(right: BorderSide(color: Colors.black45, width: 1))),
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
    );
  }
}
