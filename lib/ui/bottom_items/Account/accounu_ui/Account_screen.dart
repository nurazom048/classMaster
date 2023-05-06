import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as ma;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Account/account_request/account_request.dart';
import 'package:table/ui/bottom_items/Account/accounu_ui/all_uploadeade_rutines.dart';
import 'package:table/ui/bottom_items/Account/accounu_ui/eddit_account.dart';
import 'package:table/ui/bottom_items/Account/accounu_ui/joined_rutines.dart';
import 'package:table/ui/bottom_items/Account/accounu_ui/save_screen.dart';
import 'package:table/ui/bottom_items/Account/utils/account_utils.dart';
import 'package:table/ui/bottom_items/Account/widgets/my_container_button.dart';
import 'package:table/ui/bottom_items/Account/widgets/my_divider.dart';
import 'package:table/ui/bottom_items/Account/widgets/tiled_boutton.dart';
import 'package:table/ui/bottom_items/Home/notice/screens/view_more_noticeBord.dart';
import 'package:table/widgets/AccountCard.dart';
import '../../../../core/component/heder component/appbaar_custom.dart';
import '../../../../core/dialogs/alart_dialogs.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../Home/notice/screens/notice Board/uploadedNoticeBord_bord _screen.dart';
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
                print("Scroll Started");

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ref
                      .watch(hideNevBarOnScrooingProvider.notifier)
                      .update((state) => true);
                });
              } else if (scrollNotification is ScrollUpdateNotification) {
                String message = 'Scroll Updated';
                // print(message);
              } else if (scrollNotification is ScrollEndNotification) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ref
                      .watch(hideNevBarOnScrooingProvider.notifier)
                      .update((state) => false);
                });

                String message = 'Scroll Ended';
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
                return GestureDetector(
                  onTapUp: (t) {
                    print('scrolling has stopped $t');
                  },
                  onTapDown: (b) {
                    print('scrolling has started $b');
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //... AppBar.....//
                      const AppbarCustom(title: "    Account"),
                      accountData.when(
                        data: (data) {
                          print(data);

                          if (data == null) {
                            return const ma.Text("null");
                          } else {
                            return AccountCard(
                              ProfilePicture: data.image ?? '',
                              name: data.name ?? '',
                              username: data.username ?? '',
                            );
                          }
                        },
                        error: (error, stackTrace) =>
                            Alart.handleError(context, error),
                        loading: () => const ma.Text("loding"),
                      ),
                      /////////////////////

                      const SizedBox(height: 10),
                      MyContainerButton(
                        const FaIcon(FontAwesomeIcons.pen),
                        "Eddit Profile",
                        onTap: () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => EdditAccount(
                              accountUsername: accountUsername ?? "",
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      MyContainerButton(
                        const Icon(Icons.person_add_alt_1_outlined),
                        "invitation",
                        onTap: () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => EdditAccount(
                              accountUsername: accountUsername ?? "",
                            ),
                          ),
                        ),
                      ),
                      MyDividerr(thickness: 1.0, height: 1.0),
                      //*********************** Tilesbutton*****************************/
                      Container(
                        alignment: Alignment.center,
                        child: Wrap(alignment: WrapAlignment.start, children: [
                          Tilesbutton(
                            "\nJoined Rutines",
                            const FaIcon(FontAwesomeIcons.history),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const joinedRutines()),
                              );
                            },
                          ),
                          Tilesbutton(
                            "Uploades Rutines",
                            const FaIcon(FontAwesomeIcons.cableCar),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AllUploadesRutinesMini()),
                              );
                            },
                          ),
                          Tilesbutton(
                            "Saved",
                            const FaIcon(
                              FontAwesomeIcons.bookmark,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const UploadedNoticeBordScreen()),
                              );
                            },
                          ),

                          Tilesbutton(
                            "Notice Board",
                            const FaIcon(
                              FontAwesomeIcons.bookmark,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SaveScreen()),
                              );
                            },
                          ),

                          //
                        ]),
                      ),
                      MyDividerr(thickness: 1.0, height: 1.0),

                      /// ********Sattings ******//
                      MyContainerButton(
                        const Icon(Icons.settings_outlined),
                        "Sattings",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ViewMoreNoticeBord(
                                  noticeBoardName: "noticeBoardName", id: "id"),
                            ),
                          );
                        },
                      ),

                      MyContainerButton(
                        const Icon(Icons.settings_outlined),
                        "Sattings",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SettingsPage(),
                            ),
                          );
                        },
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
                    ],
                  ),
                );
              }),
            ),
          ),
        );
      }),
    );
  }
}
