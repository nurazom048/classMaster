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

  static errorAlertDialogCallBack(BuildContext context, dynamic message,
      {Function? onConfirm}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alart',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content:
              Text(message.toString(), style: const TextStyle(fontSize: 16)),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                if (onConfirm != null) {
                  onConfirm(true);
                }
              },
              child: const Text('Yes',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  static confriomAlart(BuildContext context, dynamic message,
      {Function? onTapYes}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alart',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content:
              Text(message.toString(), style: const TextStyle(fontSize: 16)),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () => onTapYes,
              child: const Text('Yes',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No',
                  style: TextStyle(fontWeight: FontWeight.bold)),
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
