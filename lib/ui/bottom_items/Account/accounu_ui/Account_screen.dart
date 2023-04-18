// ignore_for_file: non_constant_identifier_names, must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Account/account_request/account_request.dart';
import 'package:table/ui/bottom_items/Account/accounu_ui/eddit_account.dart';
import 'package:table/ui/bottom_items/Account/widgets/my_container_button.dart';
import 'package:table/ui/bottom_items/Account/widgets/my_divider.dart';
import 'package:table/ui/bottom_items/Account/widgets/tiled_boutton.dart';
import 'package:table/widgets/AccountCard.dart';
import '../../../../core/dialogs/Alart_dialogs.dart';
import '../../../../core/component/component_improts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AccountScreen extends StatefulWidget {
  final String? accountUsername;
  const AccountScreen({
    super.key,
    this.accountUsername,
  });

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

//

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    // print("widget.username");
    // print(widget.accountUsername);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 40),
          child: Consumer(builder: (context, ref, _) {
            final accountData =
                ref.watch(accountDataProvider(widget.accountUsername));
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //... AppBar.....//
                AppbarCustom(
                  title: "Account",
                  actionIcon: IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {
                        accountBottomSheet(
                            context, widget.accountUsername ?? '');
                      }),
                ),
                accountData.when(
                  data: (data) {
                    print(data);

                    if (data == null) {
                      return const Text("null");
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
                  loading: () => const Text("loding"),
                ),
                /////////////////////
                // ignore: prefer_const_constructors
                SizedBox(height: 10),
                MyContainerButton(
                    const FaIcon(FontAwesomeIcons.pen), "Eddit Profile"),
                MyDividerr(thickness: 1.0, height: 1.0),
                //*********************** Tilesbutton*****************************/
                Container(
                  alignment: Alignment.center,
                  child: Wrap(alignment: WrapAlignment.start, children: [
                    Tilesbutton(
                        "Hystory", const FaIcon(FontAwesomeIcons.history)),
                    Tilesbutton(
                        "Dowenloads", const FaIcon(FontAwesomeIcons.arrowDown)),
                    Tilesbutton(
                        "Saved", const FaIcon(FontAwesomeIcons.bookmark)),

                    //
                  ]),
                ),
                MyDividerr(thickness: 1.0, height: 1.0),

                /// ********Sattings ******//
                MyContainerButton(
                    const Icon(Icons.settings_outlined), "Sattings"),
                MyContainerButton(
                  const Icon(Icons.logout_outlined),
                  "Sign out",
                  onTap: () => _showConfirmationDialog(context),
                ),

                MyDividerr(thickness: 1.0, height: 1.0),
                MyContainerButton(const Icon(Icons.help_rounded), "About"),
              ],
            );
          }),
        ),
      ),
    );
  }

//... Account Bottom Sheet....//
  Future<dynamic> accountBottomSheet(
      BuildContext context, String accountUsername) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: const BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.0))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),

              //
              CupertinoButton(
                child: const Text(
                  'Edit Account',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => EdditAccount(
                                accountUsername: accountUsername,
                              )));
                  // Navigator.of(context).pop();
                },
              ),
              const Divider(thickness: 2),

              CupertinoButton(
                child: const Text(
                  'Delete Account',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const Divider(thickness: 2),
              const SizedBox(height: 20),
              CupertinoButton(
                color: Colors.blue,
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }
}

Future<void> _showConfirmationDialog(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: const Text(
          "Are you sure to log out?",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          CupertinoButton(
            child: const Text("Yes",
                style: TextStyle(fontSize: 18, color: Colors.red)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoButton(
            child: const Text("No",
                style: TextStyle(fontSize: 18, color: Colors.black)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

///

