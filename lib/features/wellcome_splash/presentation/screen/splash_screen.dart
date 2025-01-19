import 'package:flutter/material.dart';
import '../../../../core/constant/png_const.dart';
import '../../../../core/helper/helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    navigateBaseOnToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    navigateBaseOnToken();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 72),
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage(
                ConstPng.logoWithTittle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
