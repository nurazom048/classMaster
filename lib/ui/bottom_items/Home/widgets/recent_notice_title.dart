import 'package:flutter/material.dart';
import 'package:table/widgets/appWidget/appText.dart';

import '../../../../widgets/appWidget/buttons/Expende_button.dart';

class RecentNoticeTitle extends StatelessWidget {
  const RecentNoticeTitle({Key? key, required this.onTap});

  final dynamic onTap;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const AppText("Recent Notices", fontSize: 24)
                    .heding(fontWeight: FontWeight.normal),
                ExpendedButton(
                  text: "View More ",
                  icon: Icons.arrow_forward_ios,
                  onTap: onTap,
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
