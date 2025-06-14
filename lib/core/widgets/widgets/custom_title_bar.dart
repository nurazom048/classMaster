import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../route/route_constant.dart';
import '../../component/heder component/transition/right_to_left_transition.dart';
import '../../constant/app_color.dart';
import '../../../features/notification/screen/notification.screen.dart';

class CustomTitleBar extends StatelessWidget {
  final String title;
  final IconData? icon;
  final double elevation;
  final Widget? action;

  const CustomTitleBar(
    this.title, {
    this.icon,
    this.elevation = 5.0,
    this.action,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    String dayOfWeek = DateFormat('EEEE').format(now);
    String date = DateFormat('MM/dd/yy').format(now);

    return Column(
      children: [
        Material(
          elevation: elevation,
          child: Container(
            height: 64,
            color: Colors.white,
            padding: const EdgeInsets.all(9.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(flex: 1),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dayOfWeek,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const Spacer(flex: 18),
                InkWell(
                  onTap: () {
                    GoRouter.of(context).pushNamed(RouteConst.searchPage);
                  },
                  child: Icon(
                    icon ?? Icons.search,
                    size: 22,
                    color: AppColor.nokiaBlue,
                  ),
                ),
                const SizedBox(width: 5),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      RightToLeftTransition(page: const NotificationScreen()),
                    );
                  },
                  child: Icon(
                    icon ?? Icons.notifications_outlined,
                    size: 22,
                    color: AppColor.nokiaBlue,
                  ),
                ),
                action ?? const SizedBox(width: 0),
                const Spacer(flex: 1),
              ],
            ),
          ),
        ),
        Divider(color: AppColor.nokiaBlue, thickness: 1, height: 1),
      ],
    );
  }
}
