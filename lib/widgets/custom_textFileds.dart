// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  String labelText;
  TextEditingController controller;
  CustomTextField({
    super.key,
    required this.labelText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person),
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(
            color: Colors.black12,
          ),
        ),
      ),
    );
  }
}
