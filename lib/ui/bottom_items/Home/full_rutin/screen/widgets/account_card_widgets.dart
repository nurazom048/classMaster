import 'package:flutter/material.dart';
import 'package:table/core/component/heder%20component/crossBar.dart';
import 'package:table/helper/constant/AppColor.dart';
import 'package:table/widgets/appWidget/appText.dart';
import 'package:table/widgets/appWidget/buttons/capsule_button.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      height: 130,
      width: 130,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black12)),
      child: Column(
        children: [
          CrossBar(context, color: Colors.red),
          const CircleAvatar(
            radius: 24,
            backgroundColor: Colors.red,
          ),
          Spacer(flex: 1),
          AppText("dataindex").heding(),
          Text("dataindex"),
          Spacer(flex: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CapsuleButton(
              "Accept",
              colorBG: AppColor.nokiaBlue,
              color: Colors.white,
              onTap: () {},
            ),
          ),
          Spacer(flex: 20),
        ],
      ),
    );
  }
}
