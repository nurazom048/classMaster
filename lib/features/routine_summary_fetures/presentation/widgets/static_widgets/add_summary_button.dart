import 'package:flutter/material.dart';

class AddSummaryButton extends StatelessWidget {
  final dynamic onTap;
  const AddSummaryButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white70,
          border: Border.all(color: Colors.white, width: 1.0),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(' Add Summary', style: TextStyle(fontWeight: FontWeight.bold)),
            Icon(Icons.add),
          ],
        ),
      ),
    );
  }
}
