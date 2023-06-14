// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as ma;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:table/constant/app_color.dart';
import 'package:table/ui/bottom_items/Account/models/account_models.dart';

import '../ui/bottom_items/Account/profile/profile_screen.dart';

class AccountCardRow extends ConsumerWidget {
  AccountCardRow({
    super.key,
    required this.accountData,
    this.suffix,
    this.removeCapten,
    this.buttotext,
    this.color,
    this.addCaptem = false,
    this.onUsername = _defaultOnUsername,
    this.padding,
  });

  String? n;
  String? q;
  static void _defaultOnUsername(String? n, String? q) {}
  final AccountModels accountData;

  final String? buttotext;
  final Color? color;
  final bool? addCaptem;
  final Function(String?, String?) onUsername;
  final EdgeInsetsGeometry? padding;

  final Widget? suffix;
  dynamic removeCapten;
  TextEditingController position = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final bool isEdditingMood = ref.watch(isEditingModd);
    return InkWell(
      onTap: accountData.sId != null
          ? () => Get.to(
                ProfileSCreen(
                  academyID: accountData.sId,
                  username: accountData.username,
                ),
              )
          : () {},
      child: Container(
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        height: 70,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const CircleAvatar(
                radius: 23,
                backgroundColor: Colors.amber,
                backgroundImage: NetworkImage(
                    "https://th.bing.com/th/id/OIP.iSu2RcCcdm78xbxNDJMJSgHaEo?pid=ImgDet&rs=1"),
              ),
              //
              const Spacer(flex: 3),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ma.Text.rich(
                    TextSpan(
                        text: "${accountData.name}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black),
                        children: [
                          TextSpan(
                              text: '\n${accountData.username}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontSize: 15,
                              )),
                        ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0, left: 10),
                    child: ma.Text(
                        accountData.position != null
                            ? '${accountData.position}'
                            : "",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppColor.nokiaBlue,
                          fontSize: 14,
                        )),
                  ),
                ],
              ),

              const Spacer(flex: 24),
              // if (removeCapten != null && isEdditingMood == true)

              suffix ?? const SizedBox.shrink(),

              if (removeCapten != null)
                IconButton(
                  onPressed: removeCapten,
                  icon: const Icon(Icons.delete_rounded,
                      color: CupertinoColors.systemRed),
                ),

              if (buttotext != null && suffix == null)
                TextButton(
                    onPressed: addCaptem == true
                        ? () => addCaptenAlart(context)
                        : () => onUsername(accountData.username, ""),
                    child: ma.Text(buttotext ?? "",
                        style: TextStyle(color: color ?? Colors.blue))),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

//... add captem with position .../

  addCaptenAlart(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const ma.Text("Set a position"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: position,
                  decoration:
                      const InputDecoration(hintText: "enter position  name")),
              const SizedBox(height: 17),
              Align(
                alignment: Alignment.bottomRight,
                child: CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.blue,
                  child: const ma.Text("add as acpten"),
                  onPressed: () {
                    onUsername(accountData.username, position.text);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
