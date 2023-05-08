import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:table/ui/bottom_items/Account/account_request/account_request.dart';
import 'package:table/ui/bottom_items/Account/accounu_ui/all_uploadeade_rutines.dart';
import 'package:table/ui/bottom_items/Account/accounu_ui/joined_rutines.dart';
import 'package:table/ui/bottom_items/Account/accounu_ui/save_screen.dart';
import 'package:table/ui/bottom_items/Account/utils/account_utils.dart';
import 'package:table/ui/bottom_items/Account/widgets/my_container_button.dart';
import 'package:table/ui/bottom_items/Account/widgets/my_divider.dart';
import 'package:table/ui/bottom_items/Account/widgets/tiled_boutton.dart';
import 'package:table/ui/bottom_items/Home/notice_board/screens/notice%20Board/uploaded_notice_bord%20_screen.dart';
import 'package:table/widgets/account_card.dart';
import '../../../../core/component/heder component/appbaar_custom.dart';
import '../../../../core/dialogs/alart_dialogs.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Settings/setting_screen.dart';

//! hiddeBotom nev on scroll
final hideNevBarOnScrooingProvider =
    StateProvider.autoDispose<bool>((ref) => false);

class AccountScreen extends StatelessWidget {
  final String? accountUsername;
  const AccountScreen({
    super.key,
    this.accountUsername,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer(builder: (context, ref, _) {
        return Scaffold(
          body: NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              // Logic of scrollNotification
              if (scrollNotification is ScrollStartNotification) {
                // ignore: avoid_print
                print("Scroll Started");

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ref
                      .watch(hideNevBarOnScrooingProvider.notifier)
                      .update((state) => true);
                });
              } else if (scrollNotification is ScrollUpdateNotification) {
                // print(message);
              } else if (scrollNotification is ScrollEndNotification) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ref
                      .watch(hideNevBarOnScrooingProvider.notifier)
                      .update((state) => false);
                });

                String message = 'Scroll Ended';
                // ignore: avoid_print
                print(message);
              }
              return true;
            },
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 40),
              child: Consumer(builder: (context, ref, _) {
                final accountData =
                    ref.watch(accountDataProvider(accountUsername));
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //... AppBar.....//
                    const AppbarCustom(title: "    Account"),
                    accountData.when(
                      data: (data) {
                        if (data == null) {
                          return const Text("null");
                        } else {
                          return AccountCard(
                            profilepicture: data.image ?? '',
                            name: data.name ?? '',
                            username: data.username ?? '',
                          );
                        }
                      },
                      error: (error, stackTrace) =>
                          Alart.handleError(context, error),
                      loading: () => const Text("loding"),
                    ),
                    /////////////////////

                    const SizedBox(height: 10),
                    MyContainerButton(
                      const FaIcon(FontAwesomeIcons.pen),
                      "Eddit Profile",
                      onTap: () => Get.to(const JoinedRutinesScreen()),
                    ),
                    const SizedBox(height: 10),
                    MyContainerButton(
                      const Icon(Icons.person_add_alt_1_outlined),
                      "invitation",
                      onTap: () => Get.to(const JoinedRutinesScreen()),
                    ),
                    MyDividerr(thickness: 1.0, height: 1.0),
                    //*********************** Tilesbutton*****************************/
                    Container(
                      alignment: Alignment.center,
                      child: Wrap(alignment: WrapAlignment.start, children: [
                        Tilesbutton(
                          "\nJoined Rutines",
                          // ignore: deprecated_member_use
                          const FaIcon(FontAwesomeIcons.history),
                          onTap: () => Get.to(const JoinedRutinesScreen()),
                        ),
                        Tilesbutton(
                          "My Uploades Rutines",
                          const FaIcon(FontAwesomeIcons.cableCar),
                          onTap: () => Get.to(const AllUploadesRutinesMini()),
                        ),
                        Tilesbutton(
                          "Saved",
                          const FaIcon(FontAwesomeIcons.bookmark),
                          onTap: () => Get.to(const SaveScreen()),
                        ),

                        Tilesbutton(
                          " My uploaded Notice Board",
                          const FaIcon(FontAwesomeIcons.calendar),
                          onTap: () => Get.to(const UploadedNoticeBordScreen()),
                        ),

                        //
                      ]),
                    ),
                    MyDividerr(thickness: 1.0, height: 1.0),

                    /// ********Sattings ******//

                    MyContainerButton(
                      const Icon(Icons.settings_outlined),
                      "Sattings",
                      onTap: () => Get.to(SettingsPage()),
                    ),
                    MyContainerButton(
                        const Icon(Icons.logout_outlined), "Sign out",
                        color: Colors.red,
                        onTap: () =>
                            AccoutUtils.showConfirmationDialog(context)),

                    MyDividerr(thickness: 1.0, height: 1.0),
                    MyContainerButton(
                      const Icon(Icons.help_rounded),
                      "About",
                      onTap: () {},
                    ),

                    const SizedBox(height: 100),
                  ],
                );
              }),
            ),
          ),
        );
      }),
    );
  }
}
