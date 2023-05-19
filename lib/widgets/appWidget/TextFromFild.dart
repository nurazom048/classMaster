// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../constant/app_color.dart';

// ignore: must_be_immutable
class AppTextFromField extends StatefulWidget {
  AppTextFromField({
    super.key,
    required this.controller,
    required this.hint,
    this.labelText,
    this.validator,
    this.onFieldSubmitted,
    this.focusNode,
    this.keyboardType,
    this.margin,
    this.obscureText,
    this.showOfftext,
  });

  //
  final TextEditingController controller;
  final String hint;
  final String? labelText;
  final dynamic validator;
  final dynamic onFieldSubmitted, keyboardType;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? margin;
  final String? showOfftext;
  bool? obscureText;

  @override
  State<AppTextFromField> createState() => _AppTextFromFieldState();
}

class _AppTextFromFieldState extends State<AppTextFromField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ??
          const EdgeInsets.symmetric(horizontal: 24).copyWith(top: 34),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.hint,
            style: TextStyle(
                fontFamily: 'Open Sans',
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
                height: 1.3,
                color: AppColor.nokiaBlue),
          ),
          //

          if (widget.showOfftext == null)
            TextFormField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              onFieldSubmitted: widget.onFieldSubmitted,
              validator: widget.validator,
              keyboardType: widget.keyboardType,
              obscureText: widget.obscureText ?? false,
              decoration: InputDecoration(
                suffixIcon: widget.obscureText != null
                    ? InkWell(
                        onTap: () {
                          setState(() {
                            widget.obscureText = !widget.obscureText!;
                          });
                        },
                        child: widget.obscureText == false
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off))
                    : null,
                labelText: widget.labelText ?? "Enter your ${widget.hint} ",
                errorStyle: const TextStyle(
                    fontSize: 17,
                    letterSpacing: 1,
                    decorationStyle: TextDecorationStyle.solid),
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue, // Set the underline color here
                  ),
                ),
              ),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(widget.showOfftext!),
                ),
              ],
            )
        ],
      ),
    );
  }
}
