// ignore_for_file: library_private_types_in_public_api, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:classmate/features/wellcome_splash/presentation/Widgets/send_mini_button.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constant/image_const.dart';
import '../../../../core/export_core.dart';

class PendingScreen extends StatefulWidget {
  const PendingScreen({Key? key}) : super(key: key);

  @override
  _PendingScreenState createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
  final TextEditingController messageController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              HeaderTitle('Verification Pending', context),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25)
                    .copyWith(top: 20),
                child: Column(
                  children: [
                    Container(
                      height: size.height * 0.30,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 5,
                            offset: const Offset(0, 0),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SizedBox(
                        height: 200,
                        child: SvgPicture.asset(ImageConst.pending),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Your account is pending for verification',
                      style: TS.opensensBlue(fontSize: 17),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Our team is verifying the authenticity of your organization. Please give us some time or fill the form below to contact us. Thank you',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              Container(
                height: 370,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      AppTextFromField(
                        marlines: 8,
                        controller: messageController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your message';
                          }
                          return null;
                        },
                        hint: 'Type your message',
                        labelText:
                            'Please type your detailed message. Our team will contact you as soon as possible',
                      ).multiline(),
                      SendMiniButton(
                        text: 'Send',
                        onTap: () {
                          if (formKey.currentState?.validate() == true) {
                            // Form is valid, handle the form submission
                            // Do something with the message
                            final String message = messageController.text;
                            String? encodeQueryParameters(
                                Map<String, String> params) {
                              return params.entries
                                  .map((MapEntry<String, String> e) =>
                                      '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                  .join('&');
                            }

// ···
                            final Uri emailLaunchUri = Uri(
                              scheme: 'mailto',
                              path: Const.appEmail,
                              query: encodeQueryParameters(<String, String>{
                                'subject': 'Request For Pending Account',
                                'body': message,
                              }),
                            );

                            launchUrl(emailLaunchUri);
                          }
                        },
                      ),
                      const SizedBox(height: 20)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
