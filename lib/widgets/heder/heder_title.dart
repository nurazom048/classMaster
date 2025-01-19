// ignore_for_file: avoid_renaming_method_parameters

import 'package:flutter/material.dart';
import 'package:classmate/widgets/appWidget/app_text.dart';

import '../../core/constant/constant.dart';

class HeaderTitle extends StatelessWidget {
  const HeaderTitle(
    this.title,
    this.context, {
    super.key,
    this.onTap,
    this.margin,
    this.widget,
    this.hideArrow = false,
  });
  final String title;
  final BuildContext context;
  final dynamic onTap;
  final EdgeInsetsGeometry? margin;
  final Widget? widget;
  final bool hideArrow;
  @override
  Widget build(BuildContext contextt) {
    return Container(
      margin: margin ?? EdgeInsets.only(left: 25.5, top: KTopPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (hideArrow == false)
                InkWell(
                    onTap: () => onTap ?? Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      size: 25,
                      color: Colors.black,
                    )),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TS.heading(),
                ),
              ),
            ],
          ),
          //

          widget ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
