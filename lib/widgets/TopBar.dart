import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTopBar extends StatelessWidget {
  String title;
  IconData? icon;
  double elevation;
  var ontap;

  CustomTopBar(
    this.title, {
    required this.ontap,
    this.icon,
    this.elevation = 4.0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.black12,
      padding: const EdgeInsets.all(9.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 22),
            onPressed: () => Navigator.pop(context),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          InkWell(
            child: IconButton(
              icon: Icon(icon ?? Icons.edit, size: 22),
              onPressed: ontap,
            ),
            onTap: ontap,
          ),
        ],
      ),
    );
  }
}
