import 'package:flutter/material.dart';

class AccountCard extends StatelessWidget {
  final dynamic ontapLogOut;
  final String name, username, profilepicture;
  const AccountCard(
      {super.key,
      required this.name,
      required this.username,
      required this.profilepicture,
      this.ontapLogOut});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 26),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(flex: 4),
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.red,
            backgroundImage: NetworkImage(profilepicture),
          ),
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
          if (ontapLogOut != null)
            IconButton(
                onPressed: ontapLogOut ?? () {},
                icon: const Icon(Icons.login_outlined, size: 42)),
          const Spacer(flex: 10),
        ],
      ),
    );
  }
}
