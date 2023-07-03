import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:table/core/component/loaders.dart';
import 'package:table/ui/auth_Section/auth_controller/auth_controller.dart';

import 'package:table/ui/bottom_items/Collection%20Fetures/Ui/save_rutins_screen.dart';
import 'package:table/ui/bottom_items/Collection%20Fetures/Ui/save_summarysscreen.dart';
import 'package:table/widgets/account_card.dart';
import '../../../../core/dialogs/alert_dialogs.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../sevices/firebase/firebase_analytics.service.dart';
import '../../../../sevices/notification services/awn_package.dart';
import '../../../../sevices/notification services/local_notifications.dart';
import '../../../../sevices/notification services/notification.dart';
import '../../../../widgets/heder/heder_title.dart';
import '../../Home/notice_board/screens/view_all_recent_notice.dart';
import '../Api/account_request.dart';
import '../Profie Fetures/profile_screen.dart';
import '../Settings/setting_screen.dart';
import '../widgets/my_container_button.dart';
import '../widgets/my_divider.dart';
import '../widgets/tiled_boutton.dart';
import 'eddit_account.dart';

//! hiddeBottom nev on scroll
final hideNevBarOnScrooingProvider =
    StateProvider.autoDispose<bool>((ref) => false);

//
class CollectionScreen extends ConsumerStatefulWidget {
  final String? accountUsername;

  const CollectionScreen({super.key, this.accountUsername});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CollectionScreenState();
}

class _CollectionScreenState extends ConsumerState<CollectionScreen> {
  @override
  void initState() {
    super.initState();
    AwsomNotificationSetup.takePermiton(context);

    FirebaseAnalyticsServices.logEvent(
      name: 'collectionsceen',
      parameters: {
        "content_type": "ontap",
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //! providers
    final classNotification = ref.watch(classNotificationProvider);
    final accountData = ref.watch(accountDataProvider(widget.accountUsername));
    return SafeArea(
      child: Scaffold(
        body: NotificationListener<ScrollNotification>(
          // hide bottom nev bar on scroll
          onNotification: (scrollNotification) =>
              hideNevBarOnScroll(scrollNotification, ref),

          //
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //... AppBar.....//
                HeaderTitle(
                  '   Collections',
                  context,
                  onTap: () {},
                  hideArrow: true,
                  margin:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 20)
                          .copyWith(top: 34),
                ),
                SizedBox(
                  height: 129,
                  child: accountData.when(
                    data: (data) {
                      if (data == null) {
                        return const Text("null");
                      } else {
                        return AccountCard(
                          profilepicture: data.image,
                          name: '${data.name}',
                          username: '@${data.username}',
                          onTap: () => Get.to(ProfileSCreen(academyID: null)),
                        );
                      }
                    },
                    error: (error, stackTrace) =>
                        Alert.handleError(context, error),
                    loading: () => SizedBox(
                        height: 100, child: Center(child: Loaders.center())),
                  ),
                ),

                ///

                const SizedBox(height: 10),

                classNotification.when(
                    data: (data) {
                      if (data == null) {}
                      if (!kIsWeb) {
                        LocalNotification.scheduleNotifications(data!);
                      }
                      return const SizedBox();
                    },
                    error: (error, stackTrace) {
                      Alert.handleError(context, error);
                      return const SizedBox();
                    },
                    loading: () => const SizedBox()),

                //
                MyContainerButton(
                  const FaIcon(FontAwesomeIcons.pen),
                  "Eddit Profile",
                  onTap: () => Get.to(const EdditAccount()),
                ),
                const SizedBox(height: 10),

                // My NoticeBoard

                FutureBuilder(
                  future: AuthController.getAccountType(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const SizedBox.shrink();
                    } else if (snapshot.hasData && snapshot.data != 'academy') {
                      return MyContainerButton(
                        const Icon(Icons.calendar_month),
                        "My NoticeBoard",
                        onTap: () => Get.to(() => ViewAllRecentNotice(),
                            transition: Transition.rightToLeftWithFade),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),

                const MyDividerr(thickness: 1.0, height: 1.0),
                //*********************** Tilesbutton*****************************/
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Tilesbutton(
                    "Saved\nRoutines",
                    const FaIcon(FontAwesomeIcons.bookmark),
                    svgpath: 'assets/svg/undraw_personal_file_re_5joy.svg',
                    imageMargine: const EdgeInsets.only(left: 10),
                    onTap: () => Get.to(SaveRoutinesScreen()),
                  ),

                  const SizedBox(width: 20),
                  //
                  Tilesbutton(
                    "Saved Summaries",
                    const FaIcon(FontAwesomeIcons.bookmark),
                    svgpath: 'assets/svg/undraw_my_documents_re_13dc.svg',
                    onTap: () => Get.to(SaveSummarysScreen()),
                  ),

                  //
                ]),
                const MyDividerr(thickness: 1.0, height: 1.0),

                /// ********Sattings ******//

                MyContainerButton(
                  const Icon(Icons.settings_outlined),
                  "Sattings",
                  onTap: () => Get.to(SettingsPage()),
                ),
                MyContainerButton(
                  const Icon(Icons.logout_outlined),
                  "Sign out",
                  color: Colors.red,
                  onTap: () => AuthController.logOut(context),
                ),

                const MyDividerr(thickness: 1.0, height: 1.0),
                MyContainerButton(
                  const Icon(Icons.help_rounded),
                  "About",
                  onTap: () {},
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

bool hideNevBarOnScroll(ScrollNotification? scrollNotification, WidgetRef ref) {
  // Logic of scrollNotification
  if (scrollNotification is ScrollStartNotification) {
    // ignore: avoid_print
    print("Scroll Started");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.watch(hideNevBarOnScrooingProvider.notifier).update((state) => true);
    });
  } else if (scrollNotification is ScrollUpdateNotification) {
    // print(message);
  } else if (scrollNotification is ScrollEndNotification) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.watch(hideNevBarOnScrooingProvider.notifier).update((state) => false);
    });

    String message = 'Scroll Ended';
    print(message);
  }
  return true;
}
