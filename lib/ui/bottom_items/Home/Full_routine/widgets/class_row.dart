import 'package:flutter/material.dart';

import '../../../../../widgets/appWidget/app_text.dart';

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
        width: MediaQuery.of(context).size.width - 10,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: InkWell(
          onTap: ontap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(className, color: Colors.black).heeding(),
              const Icon(Icons.arrow_forward)
            ],
          ),
        ),
      ),
    );
  }
}
