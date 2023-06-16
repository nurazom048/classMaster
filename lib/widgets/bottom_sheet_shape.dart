import 'package:flutter/material.dart';

class MyBotomSheetCliper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path0 = Path();
    path0.moveTo(size.width * 0.0012500, size.height * 0.0040000);
    path0.cubicTo(
        size.width * 0.3703875,
        size.height * 0.1948800,
        size.width * 0.1590625,
        size.height * 0.9298800,
        size.width * 0.5043750,
        size.height * 0.9950000);
    path0.cubicTo(
        size.width * 0.8569500,
        size.height * 0.9238800,
        size.width * 0.6304750,
        size.height * 0.2046200,
        size.width * 0.9990625,
        0);
    path0.cubicTo(
        size.width * 0.7496094,
        size.height * 0.0010000,
        size.width * 0.7496094,
        size.height * 0.0010000,
        size.width * 0.0012500,
        size.height * 0.0040000);
    path0.close();

    return path0;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => false;
}

class BottomSheetShape extends StatelessWidget {
  final Widget child;
  final double size;
  const BottomSheetShape({super.key, required this.size, required this.child});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width - 20;
    return Container(
      alignment: Alignment.center,
      width: width,
      height: 122,
      // color: Colors.amberAccent,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: width * 0.39,
            child: ClipPath(
              clipper: MyBotomSheetCliper(),
              child: Container(
                width: 60,
                height: 30,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            child: Container(
              height: 90,
              width: width,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(63),
              ),
              child: Center(child: child),
            ),
          ),
        ],
      ),
    );
  }
}
