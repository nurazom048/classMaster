import 'package:flutter/material.dart';

import '../../../widgets/appWidget/dottted_divider.dart';

class OR extends StatelessWidget {
  const OR({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 2 - 50,
            child: const MyDivider(),
          ),
          const Text(
            "   or ",
            style: TextStyle(fontSize: 17),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 2 - 50,
            child: const MyDivider(),
          ),
        ],
      ),
    );
  }
}
