import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classmate/services/firebase/firebase_analytics.service.dart';
import '../../../core/export_core.dart';
import '../../notice_fetures/presentation/widgets/static_widgets/simple_notice_card.dart';
import '../api/notification.api.dart';
import '../model/notification.model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();

    FirebaseAnalyticsServices.logEvent(
      name: "notificationscreen",
      parameters: {
        "content_type": "ontap",
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      // provider
      final notifications = ref.watch(notificationsProvider);
      return SafeArea(
        child: Scaffold(
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
                        (value) => Column(
                          children: List.generate(
                            value.notifications.length,
                            (i) => NotificationCard(
                              notification: value.notifications[i],
                              previousDateTime:
                                  value.notifications[i].createdAt,
                              isFirst: i == 0,
                            ),
                          ),
                        ),
                      );
                    },
                    error: (error, stackTrace) =>
                        Alert.handleError(context, error),
                    loading: () => Padding(
                      padding: const EdgeInsets.only(top: 200),
                      child: Loaders.center(),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}

class NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final bool isFirst;
  final DateTime previousDateTime;

  const NotificationCard({
    Key? key,
    required this.notification,
    required this.previousDateTime,
    this.isFirst = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (notification.createdAt != previousDateTime || isFirst)
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
