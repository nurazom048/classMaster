import 'package:flutter/material.dart';
import 'package:table/widgets/appWidget/app_text.dart';

import '../ui/bottom_items/Home/utils/utils.dart';

class AccountCard extends StatelessWidget {
  final dynamic onTap;
  final String name, username;
  final String? profilepicture;
  const AccountCard({
    super.key,
    required this.name,
    required this.username,
    required this.profilepicture,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 42).copyWith(top: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: Utils.isOnlineMethode(),
              builder: (context, snapshot) {
                bool isOffline = snapshot.data ?? false;

                if (isOffline == false && profilepicture != null) {
                  return CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.red,
                    backgroundImage: NetworkImage(profilepicture!),
                  );
                }
                {
                  return const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.red,
                  );
                }
              },
            ),
            const SizedBox(width: 17),
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  TextSpan(
                      text: name,
                      style:
                          TS.opensensBlue(fontSize: 24, color: Colors.black)),
                  TextSpan(
                    text: '\n$username',
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
