import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:classmate/core/export_core.dart';
import 'package:classmate/features/account_fetures/presentation/utils/edit_account.validation.dart';
import '../../../../core/constant/enum.dart';
import '../../../authentication_fetures/presentation/widgets/static_widget/who_are_you_button.dart';
import '../../data/models/account_models.dart';
import '../../domain/providers/account_providers.dart';
import 'package:image_picker/image_picker.dart';

class EditAccount extends ConsumerStatefulWidget {
  const EditAccount({super.key});

  @override
  ConsumerState<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends ConsumerState<EditAccount> {
  // Controllers
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final aboutController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Focus nodes
  final nameFocusNode = FocusNode();
  final usernameFocusNode = FocusNode();

  // State
  bool isLoading = false;
  XFile? image;
  XFile? coverImage;
  String? netProfileImage;
  String? netCoverImage;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    aboutController.dispose();
    nameFocusNode.dispose();
    usernameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const AppBarCustom('Edit Account'),
        body: Form(
          key: formKey,
          child: Column(
            children: [
              // Progress Bar
              if (isLoading)
                LinearProgressIndicator(
                  backgroundColor: Colors.grey.shade300,
                  color: AppColor.nokiaBlue,
                ),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      PickImage(
                        netWorkImage: netProfileImage,
                        netWorkCoverImage: netCoverImage,
                        isEdit: true,
                        onCoverImagePath: (coverPath) async {
                          setState(() => coverImage = coverPath);
                        },
                        onImagePathSelected: (file) {
                          setState(() => image = file);
                        },
                      ),

                      AppTextFromField(
                        controller: nameController,
                        hint: 'Name',
                        validator: EditAccountValidation.validateName,
                        focusNode: nameFocusNode,
                        onFieldSubmitted:
                            (_) => usernameFocusNode.requestFocus(),
                      ),

                      AppTextFromField(
                        controller: usernameController,
                        hint: 'Username',
                        validator: EditAccountValidation.validateUsername,
                        focusNode: usernameFocusNode,
                      ),

                      // 🟢 AbsorbPointer make it (Read-Only)
                      AbsorbPointer(
                        absorbing: true,
                        child: Opacity(
                          opacity: 0.8,
                          child: WhoAreYouButton(onAccountType: (role) {}),
                        ),
                      ),

                      const SizedBox(height: 16),

                      AppTextFromField(
                        controller: aboutController,
                        hint: 'About',
                        labelText: 'Write About Text',
                        validator: EditAccountValidation.validateAbout,
                      ).multiline(),

                      const SizedBox(height: 60),

                      CupertinoButtonCustom(
                        isLoading: isLoading,
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        color: AppColor.nokiaBlue,
                        text: 'Edit',
                        onPressed: () => _updateAccount(context),
                      ),
                      const SizedBox(height: 70),
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

  Future<void> _loadInitialData() async {
    final Either<AppException, AccountModels> eitherResult = await ref.read(
      accountDataProvider(null).future,
    );

    eitherResult.fold(
      (error) => Alert.showSnackBar(context, 'Failed to load data: $error'),
      (account) {
        if (mounted) {
          setState(() {
            nameController.text = account.name ?? '';
            usernameController.text = account.username ?? '';
            aboutController.text = account.about ?? '';

            // 🟢 ডাটাবেজ থেকে পাওয়া রোল রিভারপড প্রোভাইডারে সেট করা হচ্ছে (ধরে নেওয়া হচ্ছে ডাটাবেজে student/academy বা অনুরুপ ভ্যালু আছে)
            // ignore: unused_local_variable
            final String currentRole =
                account.accountType?.toString().split('.').last.toLowerCase() ??
                'student';
            //    ref.read(selectAccountTypeProvider.notifier).update((state) => currentRole);
          });
        }
      },
    );
  }

  Future<void> _updateAccount(BuildContext context) async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    setState(() => isLoading = true);
    Alert.showSnackBar(context, 'Updating your profile, please wait...');

    final editAccountData = AccountEditModel(
      name: nameController.text,
      username: usernameController.text,
      about: aboutController.text,
      image: image,
      coverImage: coverImage,
    );

    final Either<AppException, String> eitherResult = await ref.read(
      updateAccountProvider(editAccountData).future,
    );

    eitherResult.fold(
      (error) {
        Alert.showSnackBar(context, 'Update failed: $error');
      },
      (message) {
        Alert.showSnackBar(context, 'Success: $message');
        if (mounted) Navigator.pop(context);
      },
    );

    if (mounted) setState(() => isLoading = false);
  }
}
