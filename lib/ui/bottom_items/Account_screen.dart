import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table/ui/widgets/AccountCard.dart';
import 'package:table/ui/widgets/AppBarCustom.dart';
import 'package:table/ui/widgets/custom_rutin_card.dart';
import 'package:table/ui/widgets/text%20and%20buttons/mytext.dart';

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
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppbarCustom(
              title: "Account", actionIcon: const Icon(Icons.more_vert)),
          AccountCard(
            ProfilePicture: "",
            name: 'Nur Azom ',
            username: "nurazom049",
            ontapLogOut: () {
              _showConfirmationDialog(context);
            },
          ),
          //
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText("my Rutin"),

                //... all rutins...//
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                        3, (index) => CustomRutinCard(rutinname: "ET / 7 /1")),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
              child: Text(
                "Yes",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoButton(
              child: Text(
                "No",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
