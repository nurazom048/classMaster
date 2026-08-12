// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

final ROUTINE_BOX_SKELTON = ListView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  padding: const EdgeInsets.only(bottom: 100),
  itemCount: 5,
  itemBuilder: (context, index) {
    return const RoutineBoxByIdSkeleton();
  },
);

class RoutineBoxByIdSkeleton extends StatelessWidget {
  const RoutineBoxByIdSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      height: 450,
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        period: const Duration(seconds: 2),
        enabled: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 22,
                    width: width * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  JoinSkelton(width: width),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Divider(thickness: 2, color: Colors.black),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(7, (index) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  height: 20,
                  width: width * 0.07,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30),
                  ),
                );
              }),
            ),

            const SizedBox(height: 16),
            Container(
              alignment: Alignment.center,
              constraints: const BoxConstraints(minHeight: 200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    margin: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Divider(thickness: 2, color: Colors.black),
            ),
            // const SizedBox(height: 16),
            const AccountSkeleton(),
          ],
        ),
      ),
    );
  }
}

class JoinSkelton extends StatelessWidget {
  const JoinSkelton({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: width * 0.2,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }
}

class AccountSkeleton extends StatelessWidget {
  const AccountSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 10),
        const CircleAvatar(radius: 24, backgroundColor: Colors.black12),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // name ad user name
            Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              height: 15,
              width: MediaQuery.of(context).size.width / 3,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(6),
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              height: 15,
              width: MediaQuery.of(context).size.width / 3,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert, color: Colors.black12),
        ),
      ],
    );
  }
}
