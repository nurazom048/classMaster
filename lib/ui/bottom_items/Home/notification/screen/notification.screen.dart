import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/core/component/loaders.dart';
import 'package:table/core/dialogs/alert_dialogs.dart';
import 'package:table/widgets/appWidget/app_text.dart';
import 'package:table/widgets/error/error.widget.dart';
import 'package:table/widgets/heder/heder_title.dart';

import '../../notice_board/widgets/simple_notice_card.dart';
import '../api/notification.api.dart';
import '../model/notification.model.dart';

class NotificatioScreen extends StatefulWidget {
  const NotificatioScreen({super.key});

  @override
  State<NotificatioScreen> createState() => _NotificatioScreenState();
}

class _NotificatioScreenState extends State<NotificatioScreen> {
  @override
  void initState() {
    super.initState();
    event();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      // provider
      final notifications = ref.watch(notificationsProvider);
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              HeaderTitle('Notifications', context),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 26)
                        .copyWith(top: 0),
                child: notifications.when(
                  data: (data) {
                    return data.fold(
                      (error) => ErrorScreen(error: error.message),
                      (valu) => Column(
                        children: List.generate(
                          valu.notifications.length,
                          (i) => NotificationCard(
                            notification: valu.notifications[i],
                            previousDateTime: valu.notifications[i].createdAt,
                            isFrist: i == 0,
                          ),
                        ),
                      ),
                    );
                  },
                  error: (error, stackTrace) =>
                      Alert.handleError(context, error),
                  loading: () => Loaders.center(),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  void event() async {
    await FirebaseAnalytics.instance.logEvent(
      name: "notificationscreen",
      parameters: {
        "content_type": "ontap",
      },
    );
    print('notificationscreen event');
  }
}

class NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final bool isFrist;
  final DateTime previousDateTime;

  const NotificationCard({
    Key? key,
    required this.notification,
    required this.previousDateTime,
    this.isFrist = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (notification.createdAt != previousDateTime || isFrist)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(getTimeDuration(notification.createdAt),
                style: TS.opensensBlue(color: Colors.black)),
          ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 5,
                offset: const Offset(0, 0),
              ),
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (notification.imageUrl != null)
                Container(
                  height: 173,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(notification.imageUrl!),
                      fit: BoxFit.cover,
                    ),
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        notification.title,
                        style: const TextStyle(
                          fontFamily: "Open Sans",
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    expendedText(context, notification.body),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget expendedText(BuildContext context, String longText) {
    return ExpandableText(
      longText,
      expandText: 'show more....',
      collapseText: 'show less',
      maxLines: 3,
      textAlign: TextAlign.justify,
      linkColor: Colors.blue,
      style: const TextStyle(
        fontFamily: "Open Sans",
        fontSize: 15,
        color: Colors.black,
      ),
    );
  }
}
