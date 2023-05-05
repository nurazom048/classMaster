// ignore_for_file: avoid_renaming_method_parameters

import 'package:flutter/material.dart';
import 'package:table/widgets/appWidget/appText.dart';

class HeaderTitle extends StatelessWidget {
  const HeaderTitle(
    this.title,
    this.context, {
    super.key,
    this.onTap,
    this.margin,
    this.widget,
  });
  final String title;
  final BuildContext context;
  final dynamic onTap;
  final EdgeInsetsGeometry? margin;
  final Widget? widget;
  @override
  Widget build(BuildContext contextt) {
    return Container(
      margin: margin ?? const EdgeInsets.only(left: 25.5, top: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                  onTap: () => onTap ?? Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: Colors.black,
                  )),
              AppText(title).heding(),
            ],
          ),
          //

          widget ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
