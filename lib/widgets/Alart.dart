import 'package:flutter/material.dart';

class ALARTEE extends StatelessWidget {
  const ALARTEE({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  errorAlartDilog(context, dynamic mesage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(mesage.toString()),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class Alart {
//... Error Alart Dilog...//

  errorAlartDilog(context, dynamic mesage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(mesage.toString()),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
