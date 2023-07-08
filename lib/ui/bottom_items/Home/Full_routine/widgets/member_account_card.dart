// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../constant/app_color.dart';
import '../../../../../widgets/appWidget/app_text.dart';
import '../models/members_models.dart';
import 'custom_contaner_avater.dart';

class MemberAccountCard extends StatelessWidget {
  final Member member;
  final dynamic onPressed;
  final bool condition;
  const MemberAccountCard({
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5)
            .copyWith(right: 0),
        height: 70,
        color: Colors.white,
        child: Center(
          child: Row(
            children: [
              Stack(
                children: [
                  CustomContainerAvatar(image: member.image),
                  if (member.captain == true || member.owner == true)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: AppColor.nokiaBlue,
                        child: Center(
                          child: Text(
                            member.captain == true ? "C" : 'O',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    )
                ],
              ),
              const SizedBox(width: 10),

              FittedBox(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.50,
                  // color: Colors.red,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${member.name}',
                          maxLines: 2,
                          textScaleFactor: 1.1,
                          overflow: TextOverflow.ellipsis,
                          style: TS.opensensBlue(color: Colors.black),
                        ),
                        Text(
                          "@${member.username}",
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                      ]),
                ),
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
