// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/screen/widgets/seeAllCaotensList.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/screen/widgets/status_row.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/widgets/see_all_members.dart';
import 'package:table/ui/server/rutinReq.dart';
import 'package:table/widgets/TopBar.dart';
import 'package:table/widgets/hedding_row.dart';

class ViewMorepage extends ConsumerWidget {
  final String rutinId;
  const ViewMorepage(this.rutinId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    final rutinInfo = ref.watch(rutins_detalis_provider(rutinId));
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xfff8f9fa),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 50),
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              const CustomTopBar("title"),

              Container(
                height: 300,
                margin: const EdgeInsets.only(top: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                          "https://th.bing.com/th/id/OIP.OF59vsDmwxPP1tw7b_8clQHaE8?pid=ImgDet&rs=1"),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Owner name",
                      style: TextStyle(
                        fontSize: 27,
                        fontFamily: "Cupertino",
                      ),
                    ),
                    StatusRow(rutinId),
                  ],
                ),
              ),

              //... Members...//
              HeddingRow(
                hedding: "Captens",
                second_Hedding: "see more captens",
                paddingTop: 0,
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => seeAllcaptensList(
                                rutinId: rutinId,
                                onUsername: (p0, p1) {},
                              )));
                },
              ),

              // rutinInfo.when(
              //     data: (data) {
              //       List<AccountModels> cap10 = data?.cap10s ?? [];
              //       return Container(
              //         height: 210,
              //         child: ListView.builder(
              //             physics: const NeverScrollableScrollPhysics(),
              //             itemCount: 2,
              //             itemBuilder: (context, index) =>
              //                 AccountCardRow(accountData: cap10[index])),
              //       );
              //     },
              //     error: (error, stackTrace) =>
              //         Alart.handleError(context, error),
              //     loading: () => const Progressindicator()),

              //... Members...//
              HeddingRow(
                hedding: "Members",
                second_Hedding: "see more",
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          fullscreenDialog: true,
                          builder: (context) =>
                              SeeAllMembers(rutinId: rutinId)));
                },
              ),

              // rutinInfo.when(
              //     data: (data) {
              //       List<AccountModels> cap10 = data?.cap10s ?? [];
              //       return Container(
              //         height: 210,
              //         child: ListView.builder(
              //             physics: const NeverScrollableScrollPhysics(),
              //             itemCount: 2,
              //             itemBuilder: (context, index) =>
              //                 AccountCardRow(accountData: cap10[index])),
              //       );
              //     },
              //     error: (error, stackTrace) =>
              //         Alart.handleError(context, error),
              //     loading: () => const Progressindicator()),
            ],
          ),
        ),
      ),
    );
  }
}
