// ignore_for_file: prefer_const_constructors_in_immutables, unused_local_variable, camel_case_types

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/helper/constant/AppColor.dart';
import 'firebase_options.dart';
import 'ui/auth_Section/new Auuth_Screen/LogIn_Screen.dart';

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
        scaffoldBackgroundColor: AppColor.background,
        primarySwatch: Colors.blue,
      ),
      home: LogingScreen(),
    );
  }
}

// class RutinCardWidget extends StatelessWidget {
//   const RutinCardWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       //backgroundColor: Colors.black,
//       body: SingleChildScrollView(
//         child: Column(
//             children: List.generate(
//           3,
//           (index) => const RutinBox(rutinNmae: "Rutin Name"),
//         )),
//       ),
//     );
//   }
// }

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
