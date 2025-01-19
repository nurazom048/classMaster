import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:classmate/widgets/appWidget/app_text.dart';
import 'package:classmate/widgets/appWidget/buttons/capsule_button.dart';

import '../../../../../core/constant/app_color.dart';
import '../../../Collection Fetures/models/account_models.dart';
import 'package:badges/badges.dart' as badges;

class AccountCard extends StatelessWidget {
  const AccountCard({
    required this.accountData,
    required this.acceptUsername,
    required this.onRejectUsername,
    super.key,
  });
  final AccountModels accountData;
  final dynamic onRejectUsername;
  final dynamic acceptUsername;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      height: 130,
      width: 130,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black12)),
      child: badges.Badge(
        onTap: onRejectUsername,
        badgeStyle: const BadgeStyle(badgeColor: Colors.transparent),
        badgeContent: const Icon(Icons.close, color: Colors.red),
        position: BadgePosition.topStart(top: -1, start: -1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.red,
              child: accountData.image == null
                  ? null
                  : Image.network(accountData.image!),
            ),

            FittedBox(
              child: SizedBox(
                  width: 120,
                  child: Column(
                    children: [
                      Text(accountData.name ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TS.opensensBlue(
                              fontSize: 18, color: Colors.black)),
                      Text('@${accountData.username}'),
                    ],
                  )),
            ),
            // const Spacer(flex: 1),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: CapsuleButton(
                "Accept",
                colorBG: AppColor.nokiaBlue,
                color: Colors.white,
                onTap: acceptUsername,
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
