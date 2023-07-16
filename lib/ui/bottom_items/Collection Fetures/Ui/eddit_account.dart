// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:classmate/core/dialogs/alert_dialogs.dart';
import 'package:classmate/models/message_model.dart';

import 'package:classmate/widgets/appWidget/TextFromFild.dart';
import 'package:classmate/widgets/heder/appbar_custom.dart';
import 'package:classmate/widgets/pick_image.dart';
import '../../../../constant/app_color.dart';
import '../../../../widgets/appWidget/buttons/cupertino_buttons.dart';
import '../Api/account_request.dart';
import '../models/account_models.dart';
import '../utils/eddit_account.validation.dart';

class EdditAccount extends StatefulWidget {
  const EdditAccount({super.key});

  @override
  State<EdditAccount> createState() => _EdditAccountState();
}

class _EdditAccountState extends State<EdditAccount> {
  //.. Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  //
  final nameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final usernameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();

  bool loading = false;
  String? netProfileImage;
  String? netCoverImage;

  //
  String? profileImagePath;
  String? coverImagePath;

  @override
  void initState() {
    super.initState();
    loading = false;

    _lodeDataBeforeBuild();
  }

  //
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const AppBarCustom('Eddit Account'),
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 10),

                PickImage(
                  netWorkImage: netProfileImage,
                  netWorkCoverImage: netCoverImage,
                  isEddit: true,
                  onCoverImagePath: (coverPath) async {
                    coverImagePath = coverPath;
                    // print('CoverImage path $coverPath');
                  },
                  onImagePathSelected: (profileImagePAth) async {
                    profileImagePath = profileImagePAth;
                    // print("path panic vai $profileImagePAth");
                  },
                ),

                AppTextFromField(
                  controller: nameController,
                  hint: "Name",
                  validator: EdditAccountValidation.validateName,
                  focusNode: nameFocusNode,
                  onFieldSubmitted: (_) => emailFocusNode.requestFocus(),
                ),
                AppTextFromField(
                  controller: aboutController,
                  hint: "About",
                  labelText: "Write About Text",
                  validator: EdditAccountValidation.validateAbout,
                ).multiline(),
                const SizedBox(height: 60),
                // Existing code...

                CupertinoButtonCustom(
                  isLoading: loading,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  color: AppColor.nokiaBlue,
                  text: "Eddit",
                  onPressed: () async {
                    if (formKey.currentState?.validate() ?? false) {
                      setState(() => loading = true);

                      final Message message = await AccountReq.updateAccount(
                        name: nameController.text,
                        username: usernameController.text,
                        about: aboutController.text,
                        profileImage: profileImagePath,
                        coverImage: coverImagePath,
                      );
                      Alert.showSnackBar(context, message.message);
                      setState(() => loading = true);

                      Navigator.pop(context);
                    }
                  },
                ),

                const SizedBox(height: 70),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _lodeDataBeforeBuild() async {
    AccountModels? accountData = await AccountReq().getAccountData();
    if (accountData != null) {
      nameController.text = accountData.name ?? '';
      emailController.text = accountData.name ?? '';
      usernameController.text = accountData.username ?? '';
      passwordController.text = accountData.password ?? '';
      confirmPasswordController.text = accountData.password ?? '';

      aboutController.text = accountData.about ?? '';
      netProfileImage = accountData.image;
      netCoverImage = accountData.coverImage;
      if (!mounted) {}
      setState(() {});
    }
  }
}
