import 'package:flutter/material.dart';

import '../../helper/constant/AppColor.dart';

class AppTextFromField extends StatelessWidget {
  const AppTextFromField({
    super.key,
    required this.controller,
    required this.hint,
    this.labelText,
    this.validator,
    this.onFieldSubmitted,
    this.focusNode,
  });

  //
  final TextEditingController controller;
  final String hint;
  final String? labelText;
  final dynamic validator;
  final dynamic onFieldSubmitted;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24).copyWith(top: 34),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hint,
            style: TextStyle(
                fontFamily: 'Open Sans',
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
                height: 1.3,
                color: AppColor.nokiaBlue),
          ),
          //
          TextFormField(
            controller: controller,
            focusNode: focusNode,
            onFieldSubmitted: onFieldSubmitted,
            validator: validator,
            decoration: InputDecoration(
              labelText: labelText ?? "Enter your full $hint ",
              errorStyle: TextStyle(
                  fontSize: 17,
                  letterSpacing: 1,
                  decorationStyle: TextDecorationStyle.solid),
              border: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue, // Set the underline color here
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
