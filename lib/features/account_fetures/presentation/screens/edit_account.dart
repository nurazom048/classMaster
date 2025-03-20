import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:classmate/core/export_core.dart';
import 'package:classmate/features/account_fetures/presentation/utils/eddit_account.validation.dart';
import '../../data/models/account_models.dart';
import '../../data/models/account_update.dart';
import '../../domain/providers/account_providers.dart'; // Assuming providers are here

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
  String? profileImagePath;
  String? coverImagePath;
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
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 10),
                PickImage(
                  netWorkImage: netProfileImage,
                  netWorkCoverImage: netCoverImage,
                  isEddit: true,
                  onCoverImagePath: (coverPath) =>
                      setState(() => coverImagePath = coverPath),
                  onImagePathSelected: (profilePath) =>
                      setState(() => profileImagePath = profilePath),
                ),
                AppTextFromField(
                  controller: nameController,
                  hint: 'Name',
                  validator: EdditAccountValidation.validateName,
                  focusNode: nameFocusNode,
                  onFieldSubmitted: (_) => usernameFocusNode.requestFocus(),
                ),
                AppTextFromField(
                  controller: usernameController,
                  hint: 'Username',
                  validator: EdditAccountValidation.validateUsername,
                  focusNode: usernameFocusNode,
                ),
                AppTextFromField(
                  controller: aboutController,
                  hint: 'About',
                  labelText: 'Write About Text',
                  validator: EdditAccountValidation.validateAbout,
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
      ),
    );
  }

  Future<void> _loadInitialData() async {
    // Await the Future to get the Either result
    final Either<AppException, AccountModels> eitherResult =
        await ref.read(accountDataProvider(null).future);
    eitherResult.fold(
      // Now you can safely call fold on the Either result

      (error) => Alert.showSnackBar(context, 'Failed to load data: $error'),
      (account) {
        if (mounted) {
          setState(() {
            nameController.text = account.name ?? '';
            usernameController.text = account.username ?? '';
            aboutController.text = account.about ?? '';
            netProfileImage = account.image;
            netCoverImage = account.coverImage;
          });
        }
      },
    );
  }

  Future<void> _updateAccount(BuildContext context) async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    setState(() => isLoading = true);
    final updateData = AccountUpdate(
      name: nameController.text,
      username: usernameController.text,
      about: aboutController.text,
      profileImage: profileImagePath,
      coverImage: coverImagePath,
    );

    // Await the Future to get the Either result
    final Either<AppException, String> eitherResult =
        await ref.read(updateAccountProvider(updateData).future);

    // Use fold after awaiting the result
    eitherResult.fold(
      (error) => Alert.showSnackBar(context, 'Update failed: $error'),
      (message) {
        Alert.showSnackBar(context, message);
        if (mounted) Navigator.pop(context);
      },
    );

    if (mounted) setState(() => isLoading = false);
  }
}
