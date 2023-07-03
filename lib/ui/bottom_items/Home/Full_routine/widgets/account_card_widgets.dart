import 'package:flutter/material.dart';
import 'package:table/widgets/appWidget/app_text.dart';
import 'package:table/widgets/appWidget/buttons/capsule_button.dart';

import '../../../../../constant/app_color.dart';
import '../../../../../core/component/heder component/cross_bar.dart';
import '../../../Collection Fetures/models/account_models.dart';

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
      child: Column(
        children: [
          CrossBar(
            context,
            color: Colors.red,
            ontap: onRejectUsername,
          ),
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.red,
            child: accountData.image == null
                ? null
                : Image.network(accountData.image!),
          ),
          const Spacer(flex: 1),
          AppText(accountData.name ?? '').heeding(),
          Text(accountData.username ?? ''),
          const Spacer(flex: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CapsuleButton(
              "Accept",
              colorBG: AppColor.nokiaBlue,
              color: Colors.white,
              onTap: acceptUsername,
            ),
          ),
          const Spacer(flex: 20),
        ],
      ),
    );
  }
}
