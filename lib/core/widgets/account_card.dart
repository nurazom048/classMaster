// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../features/account_fetures/data/models/account_models.dart';
import '../../features/home_fetures/presentation/utils/utils.dart';
import '../constant/constant.dart';
import '../constant/enum.dart';

class AccountCard extends StatelessWidget {
  final AccountModels account;
  final VoidCallback? onTap;

  const AccountCard({super.key, required this.account, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 40,
        ).copyWith(top: 30, right: 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder<bool>(
              future: Utils.isOnlineMethod(),
              builder: (context, snapshot) {
                final isOnline = snapshot.data ?? false;

                if (isOnline && account.imageUrl != null && account.imageUrl!.isNotEmpty) {
                  return SizedBox(
                    height: 70,
                    width: 70,
                    child: ClipOval(
                      child: Image.network(
                        account.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          return const CircleAvatar(radius: 35);
                        },
                      ),
                    ),
                  );
                }

                return const CircleAvatar(radius: 35);
              },
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    account.name ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text("@${account.username ?? ''}"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
