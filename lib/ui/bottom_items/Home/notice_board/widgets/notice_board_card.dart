import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../widgets/appWidget/app_text.dart';
import '../../full_rutin/widgets/send_request_button.dart';

class MiniNoticeCard extends StatelessWidget {
  const MiniNoticeCard({
    required this.rutineName,
    required this.owerName,
    required this.image,
    required this.username,
    required this.rutinId,
    super.key,
  });
  final String rutineName;
  final String owerName;
  final String image;
  final String username, rutinId;
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      // ignore: avoid_print
      print("Notice Id : $rutinId");
      //! providers
      // final chackStatus = ref.watch(chackStatusControllerProvider(rutinId));
      // final chackStatusNotifier =
      //     ref.watch(chackStatusControllerProvider(rutinId).notifier);
      //? Provider
      // final rutinDetals = ref.watch(rutins_detalis_provider(rutinId));
      // String status = chackStatus.value?.activeStatus ?? '';
      return Container(
        height: 120,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(rutineName, fontSize: 26).title(),
                SendReqButton(
                  isNotSendRequest: true,
                  isPending: true,
                  isMember: true,
                  notificationOff: true,
                  sendRequest: () {},
                  showPanel: () {},
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(radius: 17, backgroundImage: NetworkImage(image)),
                const SizedBox(width: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    //  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(owerName,
                          style: const TextStyle(
                              fontSize: 23, fontWeight: FontWeight.w400)),
                      Text(" @$username", style: const TextStyle(fontSize: 15)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
