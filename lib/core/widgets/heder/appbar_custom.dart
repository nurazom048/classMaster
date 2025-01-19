import 'package:flutter/material.dart';

import '../appWidget/app_text.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool leadingIcon;

  const AppBarCustom(this.title,
      {super.key, this.actions, this.leadingIcon = true});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leadingWidth: 0,
      // excludeHeaderSemantics: true,
      title: InkWell(
        onTap: leadingIcon == true ? () => Navigator.pop(context) : () {},
        child: Row(
          children: [
            if (leadingIcon == true)
              const Icon(
                Icons.arrow_back_ios,
                size: 26,
              ),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TS.heading(),
            ),
          ],
        ),
      ),

      actions: actions,
    );
  }
}
