// ignore_for_file: file_names

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:table/widgets/appWidget/app_text.dart';

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
    this.marlines = 5,
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
  final int? marlines;
  bool? obscureText;

  // Multiline
  multiline() {
    return Container(
      margin: margin ??
          const EdgeInsets.symmetric(horizontal: 24).copyWith(top: 34),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(hint, style: TS.opensensBlue()),
          const SizedBox(height: 15),
          DottedBorder(
            borderType: BorderType.RRect,
            radius: const Radius.circular(8),
            padding:
                const EdgeInsets.symmetric(horizontal: 10).copyWith(top: 0),
            color: AppColor.nokiaBlue,
            dashPattern: const [6, 6], // set the dash pattern
            strokeWidth: 1,
            child: TextFormField(
              validator: validator,
              controller: controller,
              maxLines: marlines,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: labelText ?? "Enter your $hint ",
                errorStyle: const TextStyle(
                    fontSize: 17,
                    letterSpacing: 1,
                    decorationStyle: TextDecorationStyle.solid),
                hintStyle: const TextStyle(
                  fontFamily: 'Open Sans',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w300,
                  fontSize: 20,
                  height: 1.27,
                  color: Color(0xFF333333),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
          Text(widget.hint, style: TS.opensensBlue()),
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
