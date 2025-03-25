import 'package:flutter/material.dart';

/// ***** SeatingOption **** */
class SeatingOption extends StatelessWidget {
  final String title;
  final String? subtitle;
  final dynamic onTap;
  final IconData icon;
  const SeatingOption({
    required this.title,
    this.subtitle,
    required this.onTap,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle == null ? Container() : Text(subtitle!),
      onTap: onTap,
    );
  }
}
