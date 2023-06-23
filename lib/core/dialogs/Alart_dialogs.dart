import 'package:flutter/material.dart';

import '../../widgets/appWidget/app_text.dart';

abstract class Alart {
//... Error Alart Dilog...//

  static errorAlartDilog(context, dynamic mesage, {String? title}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title ?? 'Error',
          ),
          content: Text(mesage.toString(), style: TS.heading(fontSize: 18)),
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
      {required dynamic onConfirm}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content:
              Text(message.toString(), style: const TextStyle(fontSize: 16)),
          actions: <Widget>[
            ElevatedButton(
              onPressed: onConfirm, // Invoke the onConfirm callback
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

  //
  static upcoming(context, {String? header, dynamic message}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        const String demmyMessage =
            "We are working on this feature. It will be available very soon...";
        return AlertDialog(
          title: Text(header ?? 'Upcomming'),
          content: Text(message == null ? demmyMessage : message.toString()),
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
