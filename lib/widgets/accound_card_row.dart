// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:classmate/ui/bottom_items/Home/utils/utils.dart';

import '../ui/bottom_items/Collection Fetures/Profie Fetures/profile_screen.dart';
import '../ui/bottom_items/Collection Fetures/models/account_models.dart';

class AccountCardRow extends ConsumerWidget {
  AccountCardRow({
    super.key,
    required this.accountData,
    this.suffix,
    this.removeCaptans,
    this.buttotext,
    this.color,
    this.addCapotes = false,
    this.onUsername = _defaultOnUsername,
    this.padding,
  });

  String? n;
  String? q;
  static void _defaultOnUsername(String? n, String? q) {}
  final AccountModels accountData;

  final String? buttotext;
  final Color? color;
  final bool? addCapotes;
  final Function(String?, String?) onUsername;
  final EdgeInsetsGeometry? padding;

  final Widget? suffix;
  dynamic removeCaptans;
  TextEditingController position = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: accountData.id != null
          ? () => Get.to(
                ProfileSCreen(
                  academyID: accountData.id,
                  username: accountData.username,
                ),
              )
          : () {},
      child: Container(
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        height: 80,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FutureBuilder(
                future: Utils.isOnlineMethod(),
                builder: (context, snapshot) {
                  bool isOffline = snapshot.data ?? false;

                  if (isOffline && accountData.image != null) {
                    return CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white54,
                      backgroundImage: NetworkImage(accountData.image!),
                    );
                  }
                  {
                    return const CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.black12,
                    );
                  }
                },
              ),

              //
              SizedBox(width: MediaQuery.of(context).size.width * 0.020),
              FittedBox(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.70,
                  // color: Colors.red,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(accountData.name ?? '',
                            maxLines: 2,
                            textScaleFactor: 1.3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Open Sans',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                              color: Colors.black,
                            )),
                        Text(
                          "@${accountData.username}",
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                      ]),
                ),
              ),
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     ma.Text.rich(
              //       TextSpan(
              //           text: "${accountData.name}",
              //           style: const TextStyle(
              //               fontWeight: FontWeight.bold,
              //               fontSize: 18,
              //               color: Colors.black),
              //           children: [
              //             TextSpan(
              //                 text: '\n@${accountData.username}',
              //                 style: const TextStyle(
              //                   fontWeight: FontWeight.w500,
              //                   color: Colors.black,
              //                   fontSize: 15,
              //                 )),
              //           ]),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.only(top: 3.0, left: 10),
              //       child: ma.Text(
              //           accountData.position != null
              //               ? '${accountData.position}'
              //               : "",
              //           style: TextStyle(
              //             fontWeight: FontWeight.w500,
              //             color: AppColor.nokiaBlue,
              //             fontSize: 14,
              //           )),
              //     ),
              //   ],
              // ),

              //const Spacer(flex: 18),
              const Spacer(flex: 1),

              suffix ?? const SizedBox.shrink(),

              if (removeCaptans != null)
                IconButton(
                  onPressed: removeCaptans,
                  icon: const Icon(Icons.delete_rounded,
                      color: CupertinoColors.systemRed),
                ),

              if (buttotext != null && suffix == null)
                TextButton(
                    onPressed: addCapotes == true
                        ? () => addCaptansAlart(context)
                        : () => onUsername(accountData.username, ""),
                    child: Text(buttotext ?? "",
                        style: TextStyle(color: color ?? Colors.blue))),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

//... add capotes with position .../

  addCaptansAlart(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Set a position"),
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
                  child: const Text("add as accept"),
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
