// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/models/Account_models.dart';
import 'package:table/ui/bottom_items/Account/accounu_ui/Account_screen.dart';
import 'package:table/widgets/days_container.dart';

class AccountCardRow extends ConsumerWidget {
  AccountCardRow({
    super.key,
    required this.accountData,
    this.suffix,
    this.removeCapten,
    this.onUsername = _defaultOnUsername,
  });

  String? n;
  static void _defaultOnUsername(String? n) {}
  final AccountModels accountData;
  final Function(String?) onUsername;

  final Widget? suffix;
  dynamic removeCapten;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isEdditingMood = ref.watch(isEditingModd);
    return InkWell(
      onTap: () => onUsername(accountData.username),
      onLongPress: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AccountScreen(
            accountUsername: accountData.username ?? '',
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
        height: 100,
        width: MediaQuery.of(context).size.width,
        color: Colors.black12,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: Colors.amber,
              backgroundImage: NetworkImage(
                  "https://th.bing.com/th/id/OIP.iSu2RcCcdm78xbxNDJMJSgHaEo?pid=ImgDet&rs=1"),
            ),
            //
            const Spacer(flex: 3),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                      text: "${accountData.name}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black),
                      children: [
                        TextSpan(
                            text: '\n${accountData.username}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 16,
                            )),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0, left: 10),
                  child: Text(
                      accountData.position != null
                          ? '${accountData.position}'
                          : "",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.blue.shade600,
                        fontSize: 14,
                      )),
                ),
              ],
            ),

            const Spacer(flex: 24),
            removeCapten != null && isEdditingMood == true
                ? IconButton(
                    onPressed: removeCapten,
                    icon: const Icon(
                      Icons.delete_rounded,
                      color: CupertinoColors
                          .systemRed, // set the color to systemRed
                    ),
                  )
                : suffix ?? SizedBox.shrink(),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
