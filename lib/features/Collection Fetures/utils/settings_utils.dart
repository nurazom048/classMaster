import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsUtils {
  // ... select theme
  static void showThemeSelectionSheet(BuildContext context, themeChanger) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text('Select Theme'),
          actions: [
            CupertinoActionSheetAction(
              child: const Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(CupertinoIcons.check_mark),
                  ),
                  Text('Light Mood'),
                ],
              ),
              onPressed: () {
                themeChanger.setTheme(ThemeMode.light);
                Navigator.of(context).pop();
              },
            ),
            CupertinoActionSheetAction(
              child: const Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(CupertinoIcons.check_mark),
                  ),
                  Text('Dark Mood'),
                ],
              ),
              onPressed: () {
                themeChanger.setTheme(ThemeMode.dark);
                Navigator.of(context).pop();
              },
            ),
            CupertinoActionSheetAction(
              child: const Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(CupertinoIcons.check_mark),
                  ),
                  Text('System Mood'),
                ],
              ),
              onPressed: () {
                themeChanger.setTheme(ThemeMode.system);
                Navigator.of(context).pop();
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.red)),
          ),
        );
      },
    );
  }
}
