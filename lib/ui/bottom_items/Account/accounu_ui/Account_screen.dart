import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:table/core/component/loaders.dart';
import 'package:table/ui/auth_Section/auth_controller/auth_controller.dart';
import 'package:table/ui/bottom_items/Account/account_request/account_request.dart';
import 'package:table/ui/bottom_items/Account/accounu_ui/save_rutins_screen.dart';
import 'package:table/ui/bottom_items/Account/accounu_ui/save_summarysscreen.dart';
import 'package:table/ui/bottom_items/Account/profile/profile_screen.dart';
import 'package:table/ui/bottom_items/Account/widgets/my_container_button.dart';
import 'package:table/ui/bottom_items/Account/widgets/my_divider.dart';
import 'package:table/ui/bottom_items/Account/widgets/tiled_boutton.dart';
import 'package:table/widgets/account_card.dart';
import '../../../../core/dialogs/alart_dialogs.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../sevices/notification services/awn_package.dart';
import '../../../../sevices/notification services/local_notifications.dart';
import '../../../../sevices/notification services/notification.dart';
import '../../../../widgets/heder/heder_title.dart';
import '../../Home/notice_board/screens/view_all_recent_notice.dart';
import '../Settings/setting_screen.dart';
import 'eddit_account.dart';

//! hiddeBotom nev on scroll
final hideNevBarOnScrooingProvider =
    StateProvider.autoDispose<bool>((ref) => false);

class AccountScreen extends ConsumerWidget {
  final String? accountUsername;
  const AccountScreen({
    super.key,
    this.accountUsername,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //! PROVIDERS
    final classNotification = ref.watch(classNotificationProvider);
    final accountData = ref.watch(accountDataProvider(accountUsername));
    AwsomNotificationSetup.takePermiton(context);
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
                  'Collections',
                  context,
                  onTap: () {},
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20)
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
                        Alart.handleError(context, error),
                    loading: () => SizedBox(
                        height: 100, child: Center(child: Loaders.center())),
                  ),
                ),
                /////////////////////

                const SizedBox(height: 10),

                // FutureBuilder(
                //     future: NotificationClass().routineNotification(),
                //     builder: (ctx, snapshot) {
                //       // Checking if future is resolved
                //       if (snapshot.connectionState ==
                //           ConnectionState.done) {
                //         // If we got an error
                //         if (snapshot.hasError) {
                //           return Center(
                //             child: Text(
                //               '${snapshot.error} occurred',
                //               style: const TextStyle(fontSize: 18),
                //             ),
                //           );

                //           // if we got our data
                //         } else if (snapshot.hasData) {
                //           // Extracting data from snapshot object
                //           final data = snapshot.data;
                //           LocalNotification.scheduleNotifications(data!);
                //           return Center(
                //             child: Text(
                //               '$data',
                //               style: TextStyle(fontSize: 18),
                //             ),
                //           );
                //         } else {
                //           return Text('hisu pai ni');
                //         }
                //       } else {
                //         return Text('hisu pai ni');
                //       }
                //     }),
                classNotification.when(
                    data: (data) {
                      if (data == null) {}
                      LocalNotification.scheduleNotifications(data!);
                      return const SizedBox();
                    },
                    error: (error, stackTrace) {
                      Alart.handleError(context, error);
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
                    onTap: () => Get.to(const SaveRoutinesScreen()),
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
