import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/appWidget/app_text.dart';

abstract class Alert {
//... Error AlertDialog...//

  static void errorAlertDialog(context, dynamic message, {String? title}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title ?? 'Error',
          ),
          content: Text(message.toString(), style: TS.heading(fontSize: 18)),
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

  static conformAlert(BuildContext context, dynamic message,
      {Function? onTapYes}) {
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

  //.... show snackbar ...//
  static showSnackBar(BuildContext context, dynamic text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text.toString()),
        ),
      );
  }

  static Widget handleError(BuildContext context, dynamic error) {
    Future.delayed(const Duration(seconds: 4), () {
      // showSnackBar(context, error.toString());
      Get.showSnackbar(GetSnackBar(message: '$error'));
    });
    return Center(
        child: Text(
      error.toString(),
      style: TS.heading(),
    ));
  }

  //
  static upcoming(context, {String? header, dynamic message}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        const String demyMessage =
            "We are working on this feature. It will be available very soon...";
        return AlertDialog(
          title: Text(header ?? 'Upcoming'),
          content: Text(message == null ? demyMessage : message.toString()),
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
