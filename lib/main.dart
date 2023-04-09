// ignore_for_file: prefer_const_constructors_in_immutables, unused_local_variable, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:table/helper/constant/AppColor.dart';
import 'package:table/widgets/appWidget/buttons/cupertinoButttons.dart';

import 'ui/auth_Section/new Auuth_Screen/LogIn_Screen.dart';
import 'ui/auth_Section/new Auuth_Screen/SiginUp_Screen.dart';

void main() => runApp(ProviderScope(child: MyApp()));

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SignUpScreen(),
      //  home: const MyHomePage(),
    );
  }
}

class SelectAccounType extends StatefulWidget {
  final void Function(String?)? onAccountType;
  const SelectAccounType({super.key, required this.onAccountType});

  @override
  State<SelectAccounType> createState() => _SelectAccounTypeState();
}

class _SelectAccounTypeState extends State<SelectAccounType> {
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              HeaderTitle("Log In", context),
              const SizedBox(height: 30),
              Column(
                children: [
                  SvgPicture.asset("assets/svg/man1.svg"),

                  Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'Almost there!',
                      style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w300,
                        fontSize: 48,
                        height: 65.37 / 48,
                        color: Color(0xFF001D47),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: const Text(
                      '   Select Account Type',
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
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 30),

                    //... Select Account Type ....//

                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: selectedRole == "Student"
                                  ? const Color(0xFF0168FF)
                                  : const Color(0xFFEEF4FC),
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: const Color(0xFF0168FF),
                                width: 1.0,
                              ),
                            ),
                            child: RadioListTile(
                              title: Text(
                                "Student",
                                style: TextStyle(
                                  color: selectedRole == "Student"
                                      ? Colors.white
                                      : const Color(0xFF0168FF),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              value: "Student",
                              groupValue: selectedRole,
                              onChanged: (value) {
                                setState(() {
                                  if (value != null) {
                                    selectedRole = value;
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: selectedRole == "Academy"
                                  ? const Color(0xFF0168FF)
                                  : const Color(0xFFEEF4FC),
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: const Color(0xFF0168FF),
                                width: 1.0,
                              ),
                            ),
                            child: RadioListTile(
                              title: Text(
                                "Academy",
                                style: TextStyle(
                                  color: selectedRole == "Academy"
                                      ? Colors.white
                                      : const Color(0xFF0168FF),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              value: "Academy",
                              groupValue: selectedRole,
                              onChanged: (value) {
                                setState(() {
                                  if (value != null) {
                                    selectedRole = value;
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  ////
                  ///
                  ///
                  if (selectedRole == null)
                    CupertinoButtonCustom(
                      textt: "Select Type",
                      onPressed: () {},
                    ),

                  if (selectedRole != null)
                    CupertinoButtonCustom(
                      textt: "Let’s go",
                      color: AppColor.nokiaBlue,
                      onPressed: () {
                        widget.onAccountType?.call(selectedRole);
                      },
                    )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
