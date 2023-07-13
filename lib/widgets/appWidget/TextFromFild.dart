// ignore_for_file: file_names

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/widgets/appWidget/app_text.dart';

import '../../constant/app_color.dart';

final errorTextProvider = StateProvider.autoDispose<String?>((ref) {
  return null;
});

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
    this.errorText,
  });

  //
  final TextEditingController controller;
  final String hint;
  final String? labelText;
  final String? Function(String?)? validator;
  final dynamic onFieldSubmitted, keyboardType;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? margin;
  final String? showOfftext;
  final int? marlines;
  final String? errorText;
  bool? obscureText;
  // Multiline
  multiline() {
    return Consumer(builder: (context, ref, _) {
      // provider
      final errorText = ref.watch(errorTextProvider);
      final errorTextNotifier = ref.watch(errorTextProvider.notifier);
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
                validator: (value) {
                  if (validator == null) {
                    return null;
                  }
                  errorTextNotifier.update((state) {
                    return validator!(value);
                  });
                  return validator!(value);
                },
                controller: controller,
                maxLines: marlines,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: labelText ?? "Enter your $hint ",
                  errorStyle: const TextStyle(
                      color: Colors.red,
                      fontSize: 0,
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
            const SizedBox(height: 10),
            Text(
              errorText ?? '',
              style: TS.opensensBlue(color: Colors.redAccent),
            ),
          ],
        ),
      );
    });
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
                prefixStyle: const TextStyle(color: Colors.amber),
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
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    widget.showOfftext!,
                    style: TS.opensensBlue(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }
}
