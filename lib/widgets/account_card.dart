import 'package:flutter/material.dart';

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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 26),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(flex: 4),
            FutureBuilder(
              future: Utils.isOnlineMethode(),
              builder: (context, snapshot) {
                bool isOnline = snapshot.data ?? false;

                if (isOnline == true && profilepicture != null) {
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
            const Spacer(flex: 1),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(
                      text: name,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    TextSpan(
                      text: '\n$username',
                      style: const TextStyle(fontSize: 15, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(flex: 10),
          ],
        ),
      ),
    );
  }
}
