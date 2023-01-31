import 'package:flutter/material.dart';

class CornerBox extends StatelessWidget {
  const CornerBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: const BoxDecoration(
          color: Color.fromRGBO(68, 114, 196, 40),
          border: Border(right: BorderSide(color: Colors.black45, width: 1))),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          children: [
            const Text("Priode"),
            const Divider(color: Colors.black87, height: 10, thickness: .5),
            Column(
              children: const [
                Text("Priode"),
                Text("Days"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
