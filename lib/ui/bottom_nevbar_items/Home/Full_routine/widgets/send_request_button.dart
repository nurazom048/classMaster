import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constant/app_color.dart';
import 'notification_buton.dart';

class SendReqButton extends StatelessWidget {
  final bool isNotSendRequest;
  final bool isPending;
  final bool isMember;
  final bool notificationOn;
  final VoidCallback sendRequest;
  final VoidCallback showPanel;
  final Color? color;
  final Color? colorBG;
  final IconData? icon;
  final EdgeInsetsGeometry? padding;

  const SendReqButton({
    Key? key,
    required this.isNotSendRequest,
    required this.isPending,
    required this.isMember,
    required this.notificationOn,
    required this.sendRequest,
    required this.showPanel,
    this.color,
    this.icon,
    this.colorBG,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData nIcon = notificationOn == false
        ? Icons.notifications_off
        : Icons.notifications_active;
    String text = isNotSendRequest
        ? "Send Request"
        : isPending
            ? "Request Pending"
            : "";

    return Column(
      children: [
        if (isNotSendRequest || isPending)
          CupertinoButton(
            onPressed: sendRequest,
            color: colorBG ?? const Color(0xFFE4F0FF),
            borderRadius: BorderRadius.circular(19),
            padding: padding ?? const EdgeInsets.all(8),
            minSize: 32,
            pressedOpacity: 0.5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
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
