// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../features/account_fetures/data/models/account_models.dart';
import '../../features/home_fetures/presentation/utils/utils.dart';
import '../constant/constant.dart';
import '../constant/enums.dart';

class AccountCard extends StatelessWidget {
  final AccountModels account;
  final VoidCallback? onTap;

  const AccountCard({super.key, required this.account, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder<bool>(
              future: Utils.isOnlineMethod(),
              builder: (context, snapshot) {
                final isOnline = snapshot.data ?? false;

                if (isOnline && account.imageUrl != null && account.imageUrl!.isNotEmpty) {
                  return Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.2),
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: account.imageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(child: CircularProgressIndicator(strokeWidth: 2)),
                        errorWidget: (context, url, error) {
                          return CircleAvatar(
                            radius: 30,
                            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                            child: Icon(Icons.person, color: theme.colorScheme.primary, size: 30),
                          );
                        },
                      ),
                    ),
                  );
                }

                return CircleAvatar(
                  radius: 30,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  child: Icon(Icons.person, color: theme.colorScheme.primary, size: 30),
                );
              },
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    account.name ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "@${account.username ?? ''}",
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.primary.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                    ),
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
