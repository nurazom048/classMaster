import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class Alart {
//... Error Alart Dilog...//

  static errorAlartDilog(context, dynamic mesage) {
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

  //.... show sncksbar ...//
  static showSnackBar(BuildContext context, dynamic text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text.toString()),
        ),
      );
  }

  static Text handleError(BuildContext context, dynamic error) {
    Future.delayed(Duration.zero, () {
      showSnackBar(context, error.toString());
    });
    return Text(error.toString());
  }
}
