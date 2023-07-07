// ignore_for_file: unused_result, use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:table/core/component/loaders.dart';
import 'package:table/ui/auth_Section/auth_controller/auth_controller.dart';

import 'package:table/ui/bottom_items/Collection%20Fetures/Ui/save_rutins_screen.dart';
import 'package:table/ui/bottom_items/Collection%20Fetures/Ui/save_summarysscreen.dart';
import 'package:table/widgets/account_card.dart';
import 'package:table/widgets/heder/appbar_custom.dart';
import '../../../../core/dialogs/alert_dialogs.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../services/firebase/firebase_analytics.service.dart';
import '../../../../services/notification services/awn_package.dart';
import '../../../../services/notification services/local_notifications.dart';
import '../../../../services/notification services/notification.dart';
import '../../Home/notice_board/screens/view_all_recent_notice.dart';
import '../../Home/utils/utils.dart';
import '../Api/account_request.dart';
import '../Profie Fetures/profile_screen.dart';
import '../Settings/setting_screen.dart';
import '../widgets/my_container_button.dart';
import '../widgets/my_divider.dart';
import '../widgets/tiled_boutton.dart';
import 'eddit_account.dart';

//! hidden Bottom nev on scroll
final hideNevBarOnScorningProvider =
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
    AwesomeNotificationSetup.takePermiton(context);

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
        backgroundColor: Colors.white10,
        appBar: const AppBarCustom('Collection', leadingIcon: false),
        body: NotificationListener<ScrollNotification>(
          // hide bottom nev bar on scroll
          onNotification: (scrollNotification) =>
              Utils.hideNevBarOnScroll(scrollNotification, ref),

          //
          child: RefreshIndicator(
            onRefresh: () async {
              final bool isOnline = await Utils.isOnlineMethod();
              if (!isOnline) {
                Alert.showSnackBar(context, 'You are in offline mood');
              } else {
                //! provider
                ref.refresh(accountDataProvider(widget.accountUsername));
                ref.refresh(classNotificationProvider);
              }
            },
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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

                  const SizedBox(height: 5),

                  classNotification.when(
                      data: (data) {
                        if (data == null) {}
                        // if (!kIsWeb) {
                        print('Asom nortification created');
                        LocalNotification.scheduleNotifications(data!);
                        //   }
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
                      } else if (snapshot.hasData &&
                          snapshot.data != 'academy') {
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
                      saxpath: 'assets/svg/undraw_personal_file_re_5joy.svg',
                      imageMargin: const EdgeInsets.only(left: 10),
                      onTap: () => Get.to(SaveRoutinesScreen()),
                    ),

                    const SizedBox(width: 20),
                    //
                    Tilesbutton(
                      "Saved Summaries",
                      const FaIcon(FontAwesomeIcons.bookmark),
                      saxpath: 'assets/svg/undraw_my_documents_re_13dc.svg',
                      onTap: () => Get.to(SaveSummeryScreen()),
                    ),

                    //
                  ]),
                  const MyDividerr(thickness: 1.0, height: 1.0),

                  /// ********Settings ******//

                  MyContainerButton(
                    const Icon(Icons.settings_outlined),
                    "Settings",
                    onTap: () => Get.to(SettingsPage()),
                  ),
                  MyContainerButton(
                    const Icon(Icons.logout_outlined),
                    "Sign out",
                    color: Colors.red,
                    onTap: () => AuthController.logOut(context, ref: ref),
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
      ),
    );
  }
}
