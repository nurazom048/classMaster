import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccoutUtils {
  static Future<void> showConfirmationDialog(context,
      {Function? onTapYes}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: const Text(
            "Are you sure to log out?",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            CupertinoButton(
              child: const Text("Yes",
                  style: TextStyle(fontSize: 18, color: Colors.red)),
              onPressed: () => onTapYes,
            ),
            CupertinoButton(
              child: const Text("No",
                  style: TextStyle(fontSize: 18, color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
///














