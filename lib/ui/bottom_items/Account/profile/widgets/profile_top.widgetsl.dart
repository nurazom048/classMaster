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
          height: 240,
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
