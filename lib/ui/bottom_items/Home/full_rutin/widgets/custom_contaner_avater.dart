import 'package:flutter/material.dart';

import '../../../../../constant/constant.dart';

class CustomContainerAvater extends StatelessWidget {
  final String? image;
  const CustomContainerAvater({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Color(0xFF0168FF),
            Color(0xFF630584),
          ],
          stops: [1.0, 0.0],
          center: Alignment.center,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x25000000),
            offset: Offset(0, 4),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(image == null ? Const.accountimage : image!)),
          shape: BoxShape.circle,
          color: const Color(0xFFFCFCFC),
          border: Border.all(
            width: 3,
            style: BorderStyle.solid,
            color: Colors.transparent,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x40000000),
              offset: Offset(0, 2),
              blurRadius: 5,
              spreadRadius: 4,
            ),
          ],
        ),
      ),
    );
  }
}
