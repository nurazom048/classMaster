import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/controller/chack_status_controller.dart';
import '../../../../../core/dialogs/Alart_dialogs.dart';
import '../../../../../widgets/appWidget/app_text.dart';
import '../../full_rutin/widgets/send_request_button.dart';
import '../notice controller/notice_boaed_satus_controller.dart';
import '../utils/notice_board_dilog.dart';

class MiniNoticeCard extends ConsumerWidget {
  const MiniNoticeCard({
    required this.noticeBoardId,
    required this.noticeBoarName,
    required this.ownerName,
    required this.image,
    required this.username,
    Key? key,
  }) : super(key: key);

  final String noticeBoardId;
  final String ownerName;
  final String image;
  final String username;
  final String noticeBoarName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // chack status
    final checkStatus = ref.watch(noticeBoardStatusProvider(noticeBoardId));
    // chack statusNotifier
    final checkStatusNotifier =
        ref.watch(noticeBoardStatusProvider(noticeBoardId).notifier);

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
              FittedBox(
                child: AppText(noticeBoarName, fontSize: 26).title(),
              ),
              checkStatus.when(
                data: (data) {
                  final status = data.activeStatus;
                  final bool notification_Off =
                      data.notificationOff == true ? true : false;
                  return SendReqButton(
                    isNotSendRequest: status == "not_joined",
                    isPending: status == "request_pending",
                    isMember: false,
                    notificationOff: notification_Off,
                    sendRequest: () {
                      checkStatusNotifier.sendReqController(context);
                    },
                    showPanel: () {
                      NoticeboardDilog.notficationSeleect(
                          context, noticeBoardId);
                    },
                  );
                },
                error: (error, stackTrace) => Alart.handleError(context, error),
                loading: () => const Text("Loading..."),
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
                  children: [
                    Text(
                      ownerName,
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(" @$username", style: const TextStyle(fontSize: 15)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
