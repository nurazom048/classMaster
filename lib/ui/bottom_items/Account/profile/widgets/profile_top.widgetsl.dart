import 'package:flutter/material.dart';

import '../../../../../widgets/appWidget/app_text.dart';
import '../../../../../widgets/pick_image.dart';
import '../../models/account_models.dart';

class ProfileTop extends StatelessWidget {
  final AccountModels? accountData;
  const ProfileTop({
    Key? key,
    required this.accountData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (accountData == null) {
      return const Text("Data Null");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 230,
          child: Stack(
            children: [
              PickImage(
                onImagePathSelected: (onImagePathSelected) {},
                onCoverImagePath: (onCoverImagePath) {},
                netWorkIamge: accountData!.image,
                netWorkCoverImage: accountData!.coverImage,
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  accountData!.name ?? '',
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '@${accountData!.username}',
                  style: TS.opensensBlue(color: Colors.black),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("About", style: TS.heading()),
              const SizedBox(height: 10),
              Text("${accountData!.about}"),
            ],
          ),
        ),
      ],
    );
  }
}
