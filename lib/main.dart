// ignore_for_file: prefer_const_constructors_in_immutables, unused_local_variable, camel_case_types

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: unused_import
import 'package:file_picker/file_picker.dart';
import 'package:table/widgets/appWidget/appText.dart';
import 'package:table/widgets/appWidget/buttons/capsule_button.dart';
import 'package:table/widgets/appWidget/dottted_divider.dart';
import 'firebase_options.dart';

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
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const RutinCardWidget(),
      //  home: const MyHomePage(),
    );
  }
}

class RutinCardWidget extends StatelessWidget {
  const RutinCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BoldText("Hello").read_text(),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 35),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "CSE BATCH 23",
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    height: 1.36,
                    color: Colors.black,
                  ),
                ),
                //
                CapsuleButton(
                  "send request",
                  onTap: () {},
                )
              ],
            ),
          ),
          Center(
            child: Container(
              width: 340,
              height: 275,
              margin: const EdgeInsets.only(bottom: 224),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  width: 2,
                  color: const Color(0xFFE8E8DB),
                ),
              ),
              child: Column(
                children: const [
                  RutineCardInfoRow(
                    isFrist: true,
                  ),
                  RutineCardInfoRow(),
                  RutineCardInfoRow(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class RutineCardInfoRow extends StatelessWidget {
  final bool? isFrist;
  final dynamic onTap;
  const RutineCardInfoRow({
    super.key,
    this.isFrist,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          if (isFrist == true) const DotedDivider(),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  '09:30 AM\n-\n10:45 AM',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    height: 1.1,
                    color: Color(0xFF4F4F4F),
                  ),
                  textAlign: TextAlign.center,
                ),
                //
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.1,
                      child: Text(
                        'Introduction to Computer ds gfs ghd s hgf gdfg',
                        maxLines: 2,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          height: 1.1,
                          color: Color(0xFF4F4F4F),
                        ),
                      ),
                    ),
                    //

                    Text(
                      '- NlueTExt',
                      maxLines: 2,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        height: 1.1,
                        color: Color(0xFF0168FF),
                      ),
                    ),
                  ],
                ),

                //
                InkWell(
                    onTap: onTap ?? () {},
                    child: Container(
                        alignment: AlignmentDirectional.center,
                        child: Icon(Icons.arrow_forward_ios)))
              ],
            ),
          ),
          const DotedDivider(),
        ],
      ),
    );
  }
}















// class TestVarifi extends StatefulWidget {
//   const TestVarifi({super.key});

//   @override
//   State<TestVarifi> createState() => _TestVarifiState();
// }

// final emailController = TextEditingController();
// final otpController = TextEditingController();

// final formKey = GlobalKey<FormState>();

// class _TestVarifiState extends State<TestVarifi> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           padding: const EdgeInsets.only(bottom: 400),
//           child: Column(
//             children: [
//               HeaderTitle("Log In", context),
//               const SizedBox(height: 10),

//               ///
//               ///

//               Form(
//                 key: formKey,
//                 child: Column(
//                   children: [
//                     AppTextFromField(
//                       controller: emailController,
//                       hint: "Email",
//                       labelText: "Enter email address",
//                     ),
//                     AppTextFromField(
//                       controller: otpController,
//                       keyboardType: TextInputType.number,
//                       hint: "otp",
//                       labelText: "enter otp",
//                       validator: (value) =>
//                           SignUpValidation.validateUsername(value),
//                     ),
//                   ],
//                 ),
//               ),
//               //

//               TextButton(onPressed: () {}, child: const Text("Send Otp")),
//               const SizedBox(height: 30),
//               CupertinoButtonCustom(
//                 color: AppColor.nokiaBlue,
//                 textt: "Sign up",
//                 onPressed: () {
//                   if (formKey.currentState?.validate() ?? false) {
//                     print("validate");
//                   }
//                 },
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
