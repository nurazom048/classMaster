import 'package:flutter/material.dart';

import '../../../../../core/widgets/appWidget/app_text.dart';

class ClassRow extends StatelessWidget {
  const ClassRow({
    super.key,
    required this.id,
    required this.className,
    required this.ontap,
    required this.onLongPress,
  });
  final String className;
  final String id;
  final dynamic ontap, onLongPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: onLongPress ?? () {},
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: InkWell(
          onTap: ontap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 10,
                child: Text(
                  className,
                  overflow: TextOverflow.ellipsis,
                  style: TS.heading(),
                ),
              ),
              const Expanded(flex: 1, child: Icon(Icons.arrow_forward))
            ],
          ),
        ),
      ),
    );
  }
}
