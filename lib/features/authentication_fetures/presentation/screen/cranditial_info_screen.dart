// ignore_for_file: unused_local_variable, avoid_print

import 'package:classmate/core/widgets/appWidget/text_form_field.dart';
import 'package:classmate/core/widgets/heder/heder_title.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constant/app_color.dart';
import '../../../../core/constant/constant.dart';
import '../../../../core/constant/enum.dart';
import '../../../../core/dialogs/alert_dialogs.dart';

import '../../../../core/widgets/appWidget/buttons/cupertino_buttons.dart';
import '../../domain/providers/auth_controller.dart';
import '../../domain/providers/google_auth_controller.dart';
import '../utils/validators/singUp_validation.dart';
import '../widgets/static_widget/who_are_you_button.dart';
import 'SignUp_Screen.dart';

class CredentialScreen extends StatefulWidget {
  const CredentialScreen({super.key});

  @override
  State<CredentialScreen> createState() => _CredentialScreenState();
}

class _CredentialScreenState extends State<CredentialScreen> {
  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final contractInfoController = TextEditingController();
    final googleFormKey = GlobalKey<FormState>();
    final academyFormKey = GlobalKey<FormState>();

    final nameFocusNode = FocusNode();
    final emailFocusNode = FocusNode();
    final passwordFocusNode = FocusNode();
    final confirmPasswordFocusNode = FocusNode();

    return SafeArea(
      child: Scaffold(
        body: Consumer(
          builder: (context, ref, _) {
            //! provider
            final isLoading = ref.watch(googleAuthControllerProvider).lodging;
            final googleUser =
                ref.watch(googleAuthControllerProvider).googleAccount;
            final String selectedAccountType = ref.watch(
              selectAccountTypeProvider,
            );
            bool? isAcademy = selectedAccountType == AccountTypeString.academy;
            print(selectedAccountType);
            //
            emailController.text = googleUser?.email ?? '';
            nameController.text = googleUser?.displayName ?? '';

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 25,
              ).copyWith(top: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  HeaderTitle("Google SignIn", context),
                  const SizedBox(height: 20),
                  if (googleUser != null && googleUser.photoUrl != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(googleUser.photoUrl!),
                      ),
                    ),
                  AppTextFromField(
                    controller: nameController,
                    hintText: googleUser?.displayName,
                    hint: isAcademy == true ? "Academy Name" : "Name",
                    validator: (value) => SignUpValidation.validateName(value),
                    focusNode: nameFocusNode,
                    onFieldSubmitted: (_) => emailFocusNode.requestFocus(),
                  ),
                  AppTextFromField(
                    hintText: '${googleUser?.email}',
                    controller: emailController,
                    hint: "Email",
                    labelText: "Enter email address",
                    validator: (value) {
                      if (selectedAccountType == AccountTypeString.academy) {
                        return SignUpValidation.validateAcademyEmail(value);
                      } else {
                        return SignUpValidation.validateEmail(value);
                      }
                    },
                    focusNode: emailFocusNode,
                  ),
                  AppTextFromField(
                    hintText: extractUsernameFromEmail('${googleUser?.email}'),
                    controller: emailController,
                    hint: "Username",
                    labelText: "Enter email address",
                    validator: (value) {
                      if (selectedAccountType == AccountTypeString.academy) {
                        return SignUpValidation.validateAcademyEmail(value);
                      } else {
                        return SignUpValidation.validateEmail(value);
                      }
                    },
                    focusNode: emailFocusNode,
                  ),
                  WhoAreYouButton(
                    onAccountType: (accountType) {
                      // handle selected account type
                    },
                  ),
                  if (isAcademy == true)
                    Form(
                      key: academyFormKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 26),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),

                            AppTextFromField(
                              marlines: 10,
                              margin: const EdgeInsets.symmetric(vertical: 15),
                              controller: contractInfoController,
                              hint: "Contact info",
                              labelText:
                                  "Please provide the contact information for your academy including the current location and phone number.",
                              errorText: SignUpValidation.validateContactInfo(
                                contractInfoController.text,
                              ),
                              validator:
                                  (value) =>
                                      SignUpValidation.validateContactInfo(
                                        value,
                                      ),
                              focusNode: confirmPasswordFocusNode,
                            ).multiline(),
                            const SizedBox(height: 16),
                            ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: Const.SignUpInfoText.length,
                              itemBuilder: (context, i) {
                                return BluetMarkInfoText(
                                  text: Const.SignUpInfoText[i],
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(height: 16);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 30),
                  CupertinoButtonCustom(
                    icon: isAcademy ? Icons.send : Icons.check,
                    isLoading: isLoading,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    color: AppColor.nokiaBlue,
                    text: isAcademy ? 'Send Create Request' : "Sign up",
                    onPressed: () async {
                      bool studentFormValid = isAcademy == false;
                      bool academyFormValid =
                          isAcademy &&
                          academyFormKey.currentState?.validate() == true;

                      if (academyFormValid) {
                        signUpWithGoogle(
                          ref,
                          context,
                          contractInfo: contractInfoController.text,
                        );
                      } else if (studentFormValid) {
                        signUpWithGoogle(
                          ref,
                          context,
                          contractInfo: contractInfoController.text,
                        );
                      } else {
                        Alert.showSnackBar(context, 'Invalid Form');
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

String extractUsernameFromEmail(String email) {
  List<String> emailParts = email.split('@');
  String username = emailParts[0];
  return username;
}

void signUpWithGoogle(
  WidgetRef ref,
  context, {
  required String? contractInfo,
}) async {
  final authLogin = ref.watch(authController_provider.notifier);

  User? user = FirebaseAuth.instance.currentUser;
  final currentUsersToken = await user?.getIdToken();

  // With google
  authLogin.continueWithGoogle(
    context,
    googleAuthToken: currentUsersToken ?? '',
    accountType: ref.watch(selectAccountTypeProvider),
    contractInfo: contractInfo,
  );
}
