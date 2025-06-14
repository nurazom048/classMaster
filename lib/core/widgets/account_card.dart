// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../features/home_fetures/presentation/utils/utils.dart';

class AccountCard extends StatelessWidget {
  final dynamic onTap;
  final String name, username;
  final String? profilePicture;
  const AccountCard({
    super.key,
    required this.name,
    required this.username,
    required this.profilePicture,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 40,
        ).copyWith(top: 30, right: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: Utils.isOnlineMethod(),
              builder: (context, snapshot) {
                bool isOnline = snapshot.data ?? false;

                if (isOnline == true && profilePicture != null) {
                  return SizedBox(
                    height: 70,
                    width: 70,
                    child: ClipOval(
                      child: Image.network(
                        profilePicture!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox();
                        },
                      ),
                    ),
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
            const SizedBox(width: 10),
            FittedBox(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.55,
                // color: Colors.red,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 2,
                      textScaleFactor: 1.3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Open Sans',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      username,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
