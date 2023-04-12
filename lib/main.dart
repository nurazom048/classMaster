// ignore_for_file: prefer_const_constructors_in_immutables, unused_local_variable, camel_case_types

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: unused_import
import 'package:file_picker/file_picker.dart';
import 'package:table/helper/constant/AppColor.dart';
import 'package:table/widgets/appWidget/appText.dart';
import 'package:table/widgets/appWidget/buttons/Expende_button.dart';
// ignore: unused_import
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
      body: SingleChildScrollView(
        child: Column(
            children: List.generate(
          10,
          (index) => RutinBox(rutinNmae: "Rutin Name"),
        )),
      ),
    );
  }
}

class RutinBox extends StatelessWidget {
  final dynamic onTap;
  final String rutinNmae;
  const RutinBox({
    super.key,
    this.onTap,
    required this.rutinNmae,
  });

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      const MyDivider(),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(rutinNmae).heding(),
            //
            CapsuleButton(
              "send request",
              onTap: () {},
            )
          ],
        ),
      ),

      //

      Center(
        child: Column(
          children: const [
            RutineCardInfoRow(isFrist: true),
            RutineCardInfoRow(),
            RutineCardInfoRow(),
          ],
        ),
      ),

      //
      const ExpendedButton(),
      MiniAccountInfo(name: "Md Nur Azom", username: "nurazom049"),
      SizedBox(height: 15)
    ]);
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
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          if (isFrist == true) const DotedDivider(),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  '09:30 AM\n-\n10:45 AM',
                  textScaleFactor: 1.2,
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
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.1,
                      child: const Text(
                        'Introduction to Computer ds gfs ghd s hgf gdfg',
                        maxLines: 1,
                        textScaleFactor: 1.2,
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

                    const Text(
                      '\n- NlueTExt',
                      textScaleFactor: 1.2,
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
                const Spacer(),

                //
                InkWell(
                    onTap: onTap ?? () {},
                    child: Container(
                        padding: const EdgeInsets.only(right: 2),
                        alignment: AlignmentDirectional.center,
                        child: const Icon(Icons.arrow_forward_ios)))
              ],
            ),
          ),
          const DotedDivider(),
        ],
      ),
    );
  }
}

//***********************   MiniAccountInfo*******************/
class MiniAccountInfo extends StatelessWidget {
  final String name, username;

  MiniAccountInfo({Key? key, required this.name, required this.username})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(flex: 1),
        CircleAvatar(backgroundImage: NetworkImage("N"), radius: 22),
        const Spacer(flex: 1),
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // name ad user name
              AppText(name, fontSize: 17).heding(),
              AppText(username, fontSize: 16).heding()
            ]),
        const Spacer(flex: 8),
        IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
      ],
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
