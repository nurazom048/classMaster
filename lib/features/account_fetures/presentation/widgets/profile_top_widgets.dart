// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../../core/export_core.dart';
import '../../data/models/account_models.dart';

class ProfileTop extends StatelessWidget {
  final AccountModels? accountData;
  const ProfileTop({super.key, required this.accountData});

  @override
  Widget build(BuildContext context) {
    if (accountData == null) {
      return const Text("Data Null");
    }

    return Container(
      constraints: const BoxConstraints(minHeight: 350),
      // color: Colors.black12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 225,
            child: Stack(
              children: [
                PickImage(
                  onImagePathSelected: (onImagePathSelected) {},
                  onCoverImagePath: (onCoverImagePath) {},
                  netWorkImage: accountData!.image,
                  netWorkCoverImage: accountData!.coverImage,
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            // color: Colors.red,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 60,
                  child: Text(
                    accountData!.name ?? '',
                    textScaleFactor: 1.3,
                    maxLines: 2,
                    style: const TextStyle(
                      // fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '@${accountData!.username}',
                  style: TS.opensensBlue(color: Colors.black),
                ),
              ],
            ),
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
      ),
    );
  }
}
