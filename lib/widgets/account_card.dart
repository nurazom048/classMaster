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
        margin: const EdgeInsets.symmetric(horizontal: 40)
            .copyWith(top: 30, right: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: Utils.isOnlineMethod(),
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
            const SizedBox(width: 10),
            FittedBox(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.55,
                // color: Colors.red,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
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
                        username,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
