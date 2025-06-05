import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constant/app_color.dart';
import '../../../../routine_Fetures/presentation/widgets/static_widgets/notification_buton.dart';

class NoticeBoardJoinButton extends StatelessWidget {
  final bool isJoin;
  final bool notificationOn;
  final VoidCallback showPanel;
  final VoidCallback onTapForJoin;
  final Color? color;
  final Color? colorBG;
  final IconData? icon;
  final EdgeInsetsGeometry? padding;

  const NoticeBoardJoinButton({
    super.key,
    required this.isJoin,
    required this.notificationOn,
    required this.showPanel,
    required this.onTapForJoin,
    this.color,
    this.icon,
    this.colorBG,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    IconData nIcon =
        notificationOn == true
            ? Icons.notifications_active
            : Icons.notifications_off;
    String text = isJoin == false ? "Join" : "Joined";

    return Column(
      children: [
        if (isJoin == false)
          CupertinoButton(
            onPressed: onTapForJoin,
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
                  Icon(icon, size: 20, color: color ?? AppColor.nokiaBlue),
              ],
            ),
          )
        else
          NotificationButton(icon: nIcon, onTap: showPanel),
      ],
    );
  }
}
