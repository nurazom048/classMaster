//***********************   MiniAccountInfo*******************/
import 'package:flutter/material.dart';
import 'package:table/models/Account_models.dart';
import 'package:table/widgets/appWidget/appText.dart';

class MiniAccountInfo extends StatelessWidget {
  final AccountModels? accountData;
  final dynamic onTapMore;

  const MiniAccountInfo({Key? key, this.accountData, this.onTapMore})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(flex: 1),
        CircleAvatar(
            backgroundImage: NetworkImage(accountData?.image ?? "N"),
            radius: 22),
        const Spacer(flex: 1),
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // name ad user name
              AppText(accountData?.name ?? "", fontSize: 17).heding(),
              AppText(accountData?.username ?? '', fontSize: 16).heding()
            ]),
        const Spacer(flex: 8),
        IconButton(
            onPressed: onTapMore ?? () {}, icon: const Icon(Icons.more_vert))
      ],
    );
  }
}
