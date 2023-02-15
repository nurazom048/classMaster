// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table/ui/bottom_items/Account/eddit_account.dart';
import 'package:table/ui/server/account_req.dart';
import 'package:table/widgets/AccountCard.dart';
import 'package:table/widgets/AppBarCustom.dart';
import 'package:table/widgets/custom_rutin_card.dart';
import 'package:table/widgets/text%20and%20buttons/mytext.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({
    super.key,
  });

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
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
                future: AccountReq().accountData(),
                builder: (context, snapshoot) {
                  if (snapshoot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    var accountData = snapshoot.data;
                    var myRutins = accountData["routines"];
                    print(snapshoot.data);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //... Accoumt Info ..//
                          AccountCard(
                            ProfilePicture: "",
                            name: accountData["name"],
                            username: accountData["username"],
                            ontapLogOut: () => _showConfirmationDialog(context),
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
