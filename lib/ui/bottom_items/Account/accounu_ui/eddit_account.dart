// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:table/core/dialogs/alart_dialogs.dart';
import 'package:table/models/message_model.dart';
import 'package:table/ui/bottom_items/Account/account_request/account_request.dart';
import 'package:table/ui/bottom_items/Account/models/account_models.dart';
import 'package:table/ui/bottom_items/Account/utils/eddit_account.validation.dart';
import 'package:table/widgets/appWidget/TextFromFild.dart';
import 'package:table/widgets/pick_image.dart';
import '../../../../constant/app_color.dart';
import '../../../../core/component/loaders.dart';
import '../../../../widgets/appWidget/buttons/cupertino_butttons.dart';
import '../../../../widgets/heder/heder_title.dart';

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
  String? netprofileImage;
  String? netCoverImage;

  //
  String? profileImagePath;
  String? coverImagePath;

  @override
  void initState() {
    super.initState();
    loading = false;

    _lodedataBeforeBuild();
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              HeaderTitle("Eddit Account", context),
              const SizedBox(height: 10),

              PickImage(
                netWorkIamge: netprofileImage,
                netWorkCoverImage: netCoverImage,
                isEddit: true,
                onCoverImagePath: (coverPath) async {
                  coverImagePath = coverPath;
                  print('CoverImage path $coverPath');
                },
                onImagePathSelected: (profileImagePAth) async {
                  profileImagePath = profileImagePAth;
                  print("path paici vai $profileImagePAth");
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

              if (loading != null && loading == true)
                Loaders.button()
              else
                CupertinoButtonCustom(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  color: AppColor.nokiaBlue,
                  textt: "Eddit",
                  onPressed: () async {
                    setState(() => loading = true);
                    if (formKey.currentState?.validate() ?? false) {
                      final Message message = await AccountReq.updateAccount(
                        name: nameController.text,
                        username: usernameController.text,
                        about: aboutController.text,
                        profileImage: profileImagePath,
                        coverImage: coverImagePath,
                      );
                      Alart.showSnackBar(context, message.message);
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
    );
  }

  void _lodedataBeforeBuild() async {
    AccountModels? accountData = await AccountReq().getAccountData();
    if (accountData != null) {
      nameController.text = accountData.name ?? '';
      emailController.text = accountData.name ?? '';
      usernameController.text = accountData.username ?? '';
      passwordController.text = accountData.password ?? '';
      confirmPasswordController.text = accountData.password ?? '';

      aboutController.text = accountData.about ?? '';
      netprofileImage = accountData.image;
      netCoverImage = accountData.coverImage;
      if (!mounted) {}
      setState(() {});
    }
  }
}
