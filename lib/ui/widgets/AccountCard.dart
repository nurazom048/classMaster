import 'package:flutter/material.dart';

class AccountCard extends StatelessWidget {
  dynamic ontapLogOut;
  String name, username, ProfilePicture;
  AccountCard(
      {super.key,
      required this.name,
      required this.username,
      required this.ProfilePicture,
      this.ontapLogOut});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      width: double.infinity,
      //   decoration: const BoxDecoration(color: Colors.black12),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(flex: 8),
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.red,
              backgroundImage: NetworkImage(ProfilePicture),
            ),
            //
            const Spacer(flex: 4),
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
            IconButton(
                onPressed: ontapLogOut ?? () {},
                icon: const Icon(Icons.login_outlined, size: 42)),
            const Spacer(flex: 10),
          ],
        ),
      ),
    );
  }
}
