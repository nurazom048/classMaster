// ignore_for_file: non_constant_identifier_names, must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table/models/Account_models.dart';
import 'package:table/ui/bottom_items/Account/account_request/account_request.dart';
import 'package:table/ui/bottom_items/Account/accounu_ui/eddit_account.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/screen/full_rutin_view.dart';
import 'package:table/widgets/AccountCard.dart';
import 'package:table/widgets/AppBarCustom.dart';
import 'package:table/widgets/custom_rutin_card.dart';
import 'package:table/widgets/progress_indicator.dart';
import 'package:table/widgets/text%20and%20buttons/mytext.dart';

class AccountScreen extends StatefulWidget {
  final String? accountUsername;
  const AccountScreen({
    super.key,
    this.accountUsername = "",
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //... AppBar.....//
              AppbarCustom(
                title: "Account",
                actionIcon: IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      accountBottomSheet(context);
                    }),
              ),

              FutureBuilder(
                  future: AccountReq().accountData(
                    widget.accountUsername,
                  ),
                  builder: (context, snapshoot) {
                    if (snapshoot.connectionState == ConnectionState.waiting) {
                      // print(snapshoot.data);

                      return const Center(child: Progressindicator());
                    } else {
                      var accountData = snapshoot.data;
                      var loginAccount = AccountModels.fromJson(accountData);
                      // print(snapshoot.data);

                      //
                      var myRutins = accountData["routines"];
                      var save_rutin = accountData["Saved_routines"];

                      //    print(save_rutin);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Image.network(imageUrl),
                            //... Accoumt Info ..//
                            AccountCard(
                              ProfilePicture: loginAccount.image ?? "",
                              name: loginAccount.name!,
                              username: loginAccount.username!,
                              ontapLogOut: () =>
                                  _showConfirmationDialog(context),
                            ),

                            //...My Rutiners...//
                            MyText("my Rutin"),

                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(
                                  myRutins.length,
                                  (index) => InkWell(
                                    child: CustomRutinCard(
                                      rutinname: myRutins[index]["name"],
                                      username: myRutins[index]["ownerid"]
                                          ["username"],
                                      name: myRutins[index]["ownerid"]["name"],
                                      profilePicture: myRutins[index]["ownerid"]
                                          ["image"],

                                      //.. On tap...//
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FullRutineView(
                                            rutinName: myRutins[index]["name"],
                                            rutinId: myRutins[index]["_id"],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            //

                            //... Saved Rutin...///

                            MyText("Saved Rutin"),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(
                                  save_rutin.length,
                                  (index) => InkWell(
                                    child: save_rutin.length == 0
                                        ? Container()
                                        : CustomRutinCard(
                                            rutinname: save_rutin[index]
                                                ["name"],
                                            username: save_rutin[index]
                                                ["ownerid"]["username"],
                                            name: save_rutin[index]["ownerid"]
                                                ["name"],
                                            profilePicture: save_rutin[index]
                                                ["ownerid"]["image"],

                                            //.. On tap...//
                                            onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    FullRutineView(
                                                  rutinName: save_rutin[index]
                                                      ["name"],
                                                  rutinId: save_rutin[index]
                                                      ["_id"],
                                                ),
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

//... Account Bottom Sheet....//
  Future<dynamic> accountBottomSheet(BuildContext context) {
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
                          builder: (context) => EdditAccount()));
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
