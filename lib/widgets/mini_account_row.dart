//***********************   MiniAccountInfo*******************/
import 'package:flutter/material.dart';
import 'package:classmate/widgets/appWidget/app_text.dart';

import '../ui/bottom_nevbar_items/Collection Fetures/models/account_models.dart';
import '../ui/bottom_nevbar_items/Home/utils/utils.dart';

class MiniAccountInfo extends StatelessWidget {
  final AccountModels? accountData;
  final dynamic onTapMore;
  final dynamic onTap;
  final bool hideMore;

  const MiniAccountInfo({
    Key? key,
    this.accountData,
    this.onTapMore,
    this.onTap,
    this.hideMore = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4)
          .copyWith(top: 0),
      height: 70,
      // color: Colors.black12,
      child: GestureDetector(
        onTap: onTap ?? () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                FutureBuilder(
                  future: Utils.isOnlineMethod(),
                  builder: (context, snapshot) {
                    final bool isOnline = snapshot.data ?? false;

                    if (isOnline && accountData?.image != null) {
                      return CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.red,
                        backgroundImage: NetworkImage(accountData!.image!),
                      );
                    }
                    {
                      return const CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.red,
                      );
                    }
                  },
                ),
                const SizedBox(width: 10),
                Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.55),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // name ad user name
                        Text(
                          "${accountData?.name}",
                          maxLines: 2,
                          style: TS.opensensBlue(
                            color: Colors.black,
                          ),
                        ),
                        AppText("@${accountData?.username}", fontSize: 16)
                            .heeding()
                      ]),
                ),
              ],
            ),
            if (hideMore == false)
              IconButton(
                onPressed: onTapMore ?? () {},
                icon: const Icon(Icons.more_vert),
              )
            else
              const SizedBox()
          ],
        ),
      ),
    );
  }
}
