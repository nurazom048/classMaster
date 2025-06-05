import 'package:flutter/material.dart';

class ConfirmAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final Function(bool) onConfirm;

  const ConfirmAlertDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm(false); // False indicates the user chose not to delete
          },
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () {
            //  Navigator.of(context).pop();
            onConfirm(true); // True indicates the user chose to delete
          },
          child: const Text('Yes'),
        ),
      ],
    );
  }
}
