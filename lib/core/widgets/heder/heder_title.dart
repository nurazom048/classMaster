// ignore_for_file: avoid_renaming_method_parameters

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../export_core.dart';
import '../../../ui/bottom_nevbar_items/bottom_navbar.dart';
import '../../constant/enums.dart';

class HeaderTitle extends ConsumerWidget {
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
  Widget build(BuildContext contextt, WidgetRef ref) {
    return Container(
      margin: margin ?? EdgeInsets.only(left: 25.5, top: KtopPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (hideArrow == false)
                InkWell(
                  onTap: onTap != null
                      ? () => onTap!()
                      : () {
                          final navigator = Navigator.of(contextt);
                          if (navigator.canPop()) {
                            navigator.pop();
                            if (!navigator.canPop()) {
                              ref.read(bottomNavBarIndexProvider.notifier).state = 0;
                              ref.read(drawerActiveItemProvider.notifier).state = DrawerItem.home;
                            }
                          }
                        },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    size: 25,
                    color: Colors.black,
                  ),
                ),
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
