import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../export_core.dart';

abstract class Alert {
  // Show Snackbar
  static void showSnackBar(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  // Handle error
  static Widget handleError(
    BuildContext context,
    dynamic error, {
    Widget? child,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        showSnackBar(context, error.toString());
      }
    });

    return child ?? Center(child: Text(error.toString(), style: TS.heading()));
  }

  // Error AlertDialog
  static Future<void> errorAlertDialog(
    BuildContext context,
    dynamic message, {
    String? title,
  }) async {
    if (!context.mounted) return;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title ?? 'Error'),
          content: Text(message.toString(), style: TS.heading(fontSize: 18)),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static Future<void> errorAlertDialogCallBack(
    BuildContext context,
    dynamic message, {
    required void Function(bool isConfirmed) onConfirm,
  }) async {
    if (!context.mounted) return;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: Text(message.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onConfirm(true); // User confirmed
              },
              child: const Text('YES'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onConfirm(false); // User cancelled
              },
              child: const Text('NO'),
            ),
          ],
        );
      },
    );
  }

  static conformAlert(
    BuildContext context,
    dynamic message, {
    Function? onTapYes,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Alert',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            message.toString(),
            style: const TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () => onTapYes,
              child: const Text(
                'Yes',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'No',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  // upcoming fetures informations
  static void upcoming(
    BuildContext context, {
    String? header,
    dynamic message,
  }) {
    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        const String demyMessage = "We are working on this feature...";
        return AlertDialog(
          title: Text(header ?? 'Upcoming'),
          content: Text(
            message?.toString() ?? demyMessage,
            style: TS.heading(fontSize: 18),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
