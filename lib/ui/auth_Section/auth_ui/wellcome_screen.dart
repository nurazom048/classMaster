import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:classmate/widgets/appWidget/app_text.dart';

import '../../../constant/app_color.dart';
import '../../../constant/image_const.dart';
import '../../../widgets/appWidget/buttons/cupertino_buttons.dart';
import '../../../widgets/heder/heder_title.dart';

import 'logIn_screen.dart';

class WellComeScreen extends StatelessWidget {
  const WellComeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              HeaderTitle("Wellcome", context, hideArrow: true),
              const Spacer(flex: 2),
              SizedBox(
                height: 200,
                child: SvgPicture.asset(ImageConst.wellcome),
              ),
              const Spacer(flex: 4),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Welcome',
                      style: TS.opensensBlue(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: MediaQuery.of(context).size.width - 160,
                    alignment: Alignment.center,
                    child: const Text(
                      'Get all your routines and notices in one place!',
                      style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w300,
                        fontSize: 20,
                        height: 65.37 / 48,
                        color: Color(0xFF001D47),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              )
            ],
          ),
          bottomNavigationBar: Container(
            margin: const EdgeInsets.only(bottom: 40),
            child: CupertinoButtonCustom(
              text: "Let’s go",
              padding: const EdgeInsets.symmetric(horizontal: 25),
              color: AppColor.nokiaBlue,
              onPressed: () {
                Get.to(
                  () => const LoginScreen(),
                  transition: Transition.rightToLeft,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
