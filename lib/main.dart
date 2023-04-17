// ignore_for_file: prefer_const_constructors_in_immutables, unused_local_variable, camel_case_types

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/helper/constant/AppColor.dart';
import 'package:table/widgets/appWidget/appText.dart';
import 'package:table/widgets/appWidget/buttons/Expende_button.dart';
import 'firebase_options.dart';
import 'ui/auth_Section/new Auuth_Screen/Login_Screen.dart';
import 'widgets/appWidget/dottted_divider.dart';

//

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        //  scaffoldBackgroundColor: AppColor.background,
        primarySwatch: Colors.blue,
      ),
      home: LogingScreen(),
    );
  }
}

class RecentNotice extends StatelessWidget {
  const RecentNotice({Key? key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppText("Recent Notices", fontSize: 24)
                  .heding(fontWeight: FontWeight.normal),
              const ExpendedButton(
                  text: "View More ", icon: Icons.arrow_forward_ios),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              children: [
                noticeRow("2/4/23", "The upcoming Eid vacation"),
                noticeRow("1/4/23", "Labor Day holiday"),
                noticeRow("1/4/23", "Company meeting"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget noticeRow(String date, String title) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 20,
                height: 1.86,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  height: 1.86,
                  color: Color(0xFF333333),
                ),
              ),
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_forward)),
          ],
        ),
        const SizedBox(height: 5),
        const DotedDivider(),
      ],
    );
  }
}
