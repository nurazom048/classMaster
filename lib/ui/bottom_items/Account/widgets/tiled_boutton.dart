//*************TilesButton************************ */

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Tilesbutton extends StatelessWidget {
  final String text;
  final Widget icon;
  final dynamic onTap;
  final String svgpath;
  final EdgeInsetsGeometry? imageMargine;

  const Tilesbutton(this.text, this.icon,
      {Key? key, this.onTap, required this.svgpath, this.imageMargine})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        width: 138,
        height: 174,
        decoration: BoxDecoration(
            color: const Color.fromRGBO(1, 104, 255, 0.10),
            borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            children: [
              Stack(children: [
                const Positioned(right: 2, child: Icon(Icons.arrow_forward)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      margin: imageMargine,
                      height: 92,
                      child: Center(
                          child: SvgPicture.asset(
                        svgpath,
                        height: 92,
                        fit: BoxFit.cover,
                      ))),
                ),
                const SizedBox(height: 1),
              ]),
              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: "Open Sans",
                  fontSize: 16,
                  color: Color.fromRGBO(51, 51, 51, 1),
                ),
                softWrap: true,
                overflow: TextOverflow.clip,
                maxLines: 2,

                // Adjust the width and height values as per your requirement
                // or remove the 'frame' property if not needed
              ),
            ],
          ),
        ),
      ),
    );
  }
}
