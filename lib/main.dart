// ignore_for_file: prefer_const_constructors_in_immutables, unused_local_variable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/ui/auth_Section/auth_ui/login_sceen.dart';
import 'package:table/widgets/Alart.dart';
import 'package:table/widgets/TopBar.dart';
import 'package:table/widgets/progress_indicator.dart';
import 'ui/bottom_items/Home/full_rutin/controller/Rutin_controller.dart';
import 'ui/bottom_items/Home/full_rutin/screen/view_more_details.dart';
import 'widgets/text and buttons/squareButton.dart';

void main() => runApp(ProviderScope(child: MyApp()));

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(),
      //home: MyWidget(),
    );
  }
}

class MyWidget extends ConsumerWidget {
  MyWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //...... Appbar.......!!

                CustomTopBar("",
                    acction: IconButton(
                        icon: Icon(Icons.abc),
                        onPressed: () => showModalBottomSheet(
                            context, "63f457f960818d8f5c4ce70f", ref))),
              ]),
        ),
      ),
    );
  }

  //

  showModalBottomSheet(BuildContext context, rutinId, ref) {
    return Container(
      color: Colors.grey[200],
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 30),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
        ),
        child: Consumer(builder: (context, ref, _) {
          final chackStatus = ref.read(chackStatusUser_provider(rutinId));

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              chackStatus.when(
                  data: (data) {
                    print(data.isCaptain.toString());
                    bool isSave = data.isSave;
                    bool isOwner = data.isOwner;
                    bool isCapten = data.isCaptain;
                    return data != null
                        ? Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SqureButton(
                                    icon: Icons.people_rounded,
                                    inActiveIcon: Icons.telegram,
                                    inActiveText: "Send Join request",
                                    text: 'Members',
                                    status: false,
                                  ),
                                  SqureButton(
                                    icon: Icons.bookmark_added,
                                    inActiveIcon: Icons.bookmark_add_sharp,
                                    text: 'Save',
                                    inActiveText: "add to save",
                                    status: isSave,
                                  ),
                                  SqureButton(
                                    icon: Icons.more_horiz,
                                    //  inActiveIcon: Icons.more_vert,
                                    text: 'view more',

                                    ontap: () => Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        fullscreenDialog: true,
                                        builder: (context) =>
                                            ViewMorepage(rutinId),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              isOwner || isCapten
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SqureButton(
                                          icon: Icons.person_remove,
                                          text: "remove members",
                                          color: Colors.redAccent,
                                        ),
                                        SqureButton(
                                          icon: Icons.person_remove,
                                          color: Colors.redAccent,
                                          text: "remove captens",
                                        ),
                                        SqureButton(
                                          icon: Icons.delete,
                                          text: "Delete",
                                          color: Colors.red,
                                        ),
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          )
                        : Text("Login requaind ");
                  },
                  loading: () => const Progressindicator(),
                  error: (error, stackTrace) =>
                      Alart.handleError(context, error)),
            ],
          );
        }),
      ),
    );
  }
}
