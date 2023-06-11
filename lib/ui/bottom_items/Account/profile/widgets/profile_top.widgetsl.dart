import 'package:flutter/material.dart';

import '../../../../../widgets/appWidget/app_text.dart';
import '../../models/account_models.dart';

class ProfileTop extends StatelessWidget {
  final AccountModels? accountData;
  const ProfileTop({
    Key? key,
    required this.accountData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String url =
        "https://th.bing.com/th/id/OIP.iSu2RcCcdm78xbxNDJMJSgHaEo?pid=ImgDet&rs=1";

    //
    if (accountData == null) {
      return const Text(" Data Null");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 240,
          child: Stack(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10).copyWith(top: 0),
                width: double.infinity,
                child: AspectRatio(
                  aspectRatio: 32 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(url),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(),
                  ),
                ),
              ),
              Positioned(
                top: 88,
                left: MediaQuery.of(context).size.width / 2.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.red,
                      backgroundImage: accountData!.image != null
                          ? NetworkImage(accountData!.image!)
                          : null,
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          TextSpan(
                            text: accountData!.name ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: '\n${accountData!.username}',
                            style: TS.opensensBlue(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("About", style: TS.heading()),
              const SizedBox(height: 10),
              Text("${accountData!.about}"),
            ],
          ),
        ),
      ],
    );
  }
}
