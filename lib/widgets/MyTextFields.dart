import 'package:flutter/material.dart';
import 'package:table/widgets/text%20and%20buttons/mytext.dart';

class MyTextField extends StatelessWidget {
  String name;
  var controller;

  MyTextField({
    required this.name,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(name),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: name,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(
                color: Colors.black12,
              ),
            ),
          ),
          validator: (value) {
            if (value!.isEmpty) return "$name is required";
            return null;
          },
        ),
      ],
    );
  }
}