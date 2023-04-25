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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 60,
      // color: Colors.black12,
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.red,
            backgroundImage: NetworkImage(accountData?.image ?? ""),
          ),
          const SizedBox(width: 10),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // name ad user name
                AppText(accountData?.name ?? "", fontSize: 17).heding(),
                AppText(accountData?.username ?? "", fontSize: 16).heding()
              ]),
          const Spacer(),
          IconButton(
              onPressed: onTapMore ?? () {}, icon: const Icon(Icons.more_vert))
        ],
      ),
    );
  }
}
