import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../constant/app_color.dart';
import '../../../Home/full_rutin/widgets/notification_buton.dart';

class NoticeBoardJoineButton extends StatelessWidget {
  final bool isJoine;
  final bool notificationOff;
  final VoidCallback showPanel;
  final VoidCallback onTapForJoine;
  final Color? color;
  final Color? colorBG;
  final IconData? icon;
  final EdgeInsetsGeometry? padding;

  const NoticeBoardJoineButton({
    Key? key,
    required this.isJoine,
    required this.notificationOff,
    required this.showPanel,
    required this.onTapForJoine,
    this.color,
    this.icon,
    this.colorBG,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData nIcon =
        notificationOff ? Icons.notifications_off : Icons.notifications_active;
    String text = isJoine == false ? "Join" : "Joined";

    return Column(
      children: [
        if (isJoine == false)
          CupertinoButton(
            onPressed: onTapForJoine,
            color: colorBG ?? const Color(0xFFE4F0FF),
            borderRadius: BorderRadius.circular(19),
            padding: padding ?? const EdgeInsets.all(8),
            minSize: 32,
            pressedOpacity: 0.5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "       $text       ",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 16,
                    color: color ?? AppColor.nokiaBlue,
                  ),
                ),
                const SizedBox(width: 5),
                if (icon != null)
                  Icon(
                    icon,
                    size: 20,
                    color: color ?? AppColor.nokiaBlue,
                  ),
              ],
            ),
          )
        else
          NotificationButton(icon: nIcon, onTap: showPanel),
      ],
    );
  }
}
