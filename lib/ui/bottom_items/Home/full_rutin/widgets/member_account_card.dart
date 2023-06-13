import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../constant/app_color.dart';
import '../../../../../widgets/appWidget/app_text.dart';
import '../models/members_models.dart';
import 'custom_contaner_avater.dart';

class MeberAccountCard extends StatelessWidget {
  final Member member;
  final dynamic onPressed;
  final bool condition;
  const MeberAccountCard({
    super.key,
    required this.member,
    required this.onPressed,
    required this.condition,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5)
            .copyWith(right: 0),
        height: 65,
        color: Colors.white,
        child: Center(
          child: Row(
            children: [
              Stack(
                children: [
                  CustomContainerAvater(image: member.image),
                  if (member.captain == true)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: AppColor.nokiaBlue,
                        child: const Center(
                          child: Text(
                            "C",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    )
                ],
              ),
              const SizedBox(width: 15),
              //
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    member.name,
                    style: TS.opensensBlue(color: Colors.black),
                  ),
                  Text(
                    '@${member.username}',
                    style: TS.opensensBlue(color: Colors.black, fontSize: 11),
                  ),
                ],
              ),
              const Spacer(),
              //
              if (condition == true)
                IconButton(
                  onPressed: onPressed,
                  icon: const Icon(
                    Icons.more_vert,
                    color: CupertinoColors.black,
                  ),
                )
              else
                const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
