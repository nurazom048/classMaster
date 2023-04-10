// ignore_for_file: prefer_const_constructors_in_immutables, unused_local_variable, camel_case_types

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: unused_import
import 'package:file_picker/file_picker.dart';

import 'package:table/helper/constant/AppColor.dart';
import 'package:table/helper/picker.dart';
import 'package:table/ui/auth_Section/new%20Auuth_Screen/LogIn_Screen.dart';
import 'package:table/widgets/appWidget/TextFromFild.dart';
import 'package:table/widgets/appWidget/appText.dart';
import 'firebase_options.dart';
import 'widgets/appWidget/buttons/cupertinoButttons.dart';

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
      home: AddNoticeScreen(),
      //  home: const MyHomePage(),
    );
  }
}

class AddNoticeScreen extends ConsumerWidget {
  AddNoticeScreen({super.key});
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderTitle("Back to Home", context),
              //const SizedBox(height: 100),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0)
                    .copyWith(top: 25),
                child: const Text(
                  "Add A New \nNotice",
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w300,
                    fontSize: 48.0,
                    height: 65 / 48, // This sets the line height to 65px
                    color: Colors.black,
                    // text-edge and leading-trim are not currently supported in Flutter
                  ),
                ),
              ),

              ///
              ///
              ///
              ///
              MyDropdownButton(),

              AppTextFromField(
                controller: descriptionController,
                hint: "Notice Title",
                labelText: "Emter Your notice title",
              ),

              AppTextFromField(
                controller: descriptionController,
                hint: "Notice Description",
                labelText: "Describe what the notice is about.",
              ),
              const SizedBox(height: 60),

              UploadPDFB_Button(),

              //
              const SizedBox(height: 60),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: CupertinoButtonCustom(
                  color: AppColor.nokiaBlue,
                  textt: "Add Notice",
                  onPressed: () {},
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class UploadPDFB_Button extends StatefulWidget {
  const UploadPDFB_Button({
    super.key,
  });

  @override
  State<UploadPDFB_Button> createState() => _UploadPDFB_ButtonState();
}

class _UploadPDFB_ButtonState extends State<UploadPDFB_Button> {
  //import 'package:pdf/pdf.dart';

// Define a method that compresses the PDF and returns the compressed PDF path

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEEF4FC),
        border: Border.all(color: const Color(0xFF0168FF)),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: CupertinoButton(
        onPressed: () async {
          String? PAth = await picker.pickPDFFile();
          print("The apth is ");
          print(PAth);
        },
        color: const Color(0xFFEEF4FC),
        borderRadius: BorderRadius.circular(8),
        pressedOpacity: 0.8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Upload Notice File (PDF)',
              style: TextStyle(
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                height: 1.36,
                color: Color(0xFF0168FF),
              ),
            ),
            const SizedBox(width: 20),
            Icon(Icons.file_upload_outlined, color: AppColor.nokiaBlue)
          ],
        ),
      ),
    );
  }
}

class MyDropdownButton extends StatefulWidget {
  @override
  _MyDropdownButtonState createState() => _MyDropdownButtonState();
}

class _MyDropdownButtonState extends State<MyDropdownButton> {
  String _selectedItem = 'Item 1';
  List<String> _items = ['Item 1', 'Item 2', 'Item 3'];

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 340,
        height: 46,
        margin: const EdgeInsets.symmetric(horizontal: 17).copyWith(top: 20),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFEEF4FC),
          border: Border.all(color: const Color(0xFF0168FF)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: _selectedItem == null
            ? DropdownButton<String>(
                value: _selectedItem,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedItem = newValue!;
                  });
                },
                items: _items.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: AppText(
                      title: value,
                      color: Colors.black,
                    ),
                  );
                }).toList(),
              )
            : InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const AppText(title: "Select Board"),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: AppColor.nokiaBlue,
                    ),
                  ],
                ),

                //

                onTap: () {},
              ));
  }
}
