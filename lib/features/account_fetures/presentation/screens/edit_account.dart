import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:classmate/core/export_core.dart';
import 'package:classmate/features/account_fetures/presentation/utils/edit_account.validation.dart';
import 'package:classmate/features/account_fetures/presentation/utils/bangladesh_locations.dart';
import 'package:classmate/core/widgets/searchable_dropdown.dart';
import '../../../../core/constant/enums.dart';
import '../../../authentication_fetures/presentation/widgets/static_widget/who_are_you_button.dart';
import '../../../authentication_fetures/presentation/screen/signup_screen.dart';
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
  final streetAddressController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
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
  String? selectedDistrict;
  String? selectedUpazila;

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
    streetAddressController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    nameFocusNode.dispose();
    usernameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedRole = ref.watch(selectAccountTypeProvider);
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

                      // 🟢 AbsorbPointer makes it (Read-Only)
                      AbsorbPointer(
                        absorbing: true,
                        child: Opacity(
                          opacity: 0.8,
                          child: WhoAreYouButton(
                            onAccountType: (role) {},
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      AppTextFromField(
                        controller: aboutController,
                        hint: 'About',
                        labelText: 'Write About Text',
                        validator: EditAccountValidation.validateAbout,
                      ).multiline(),

                      // --- Address & Location Section ---
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 24).copyWith(top: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Address & Location",
                                  style: TS.opensensBlue(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (selectedRole == 'academy')
                                  IconButton(
                                    onPressed: () {
                                      // Simulate permission dialog
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Allow Location Access?'),
                                          content: const Text('Class Master needs access to your location to auto-fill the coordinates.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text('Deny'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                setState(() {
                                                  latitudeController.text = '23.8103';
                                                  longitudeController.text = '90.4125';
                                                });
                                                print('Permission granted. Location data received: Latitude = ${latitudeController.text}, Longitude = ${longitudeController.text}, District = $selectedDistrict, Upazila = $selectedUpazila, Street Address = ${streetAddressController.text}');
                                                Alert.showSnackBar(context, 'Location auto-filled: Dhaka, Bangladesh');
                                              },
                                              child: const Text('Allow'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.my_location, color: AppColor.nokiaBlue),
                                    tooltip: 'Get Location',
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            
                            // Street Address Input
                            AppTextFromField(
                              controller: streetAddressController,
                              hint: 'Street Address',
                              labelText: 'e.g. 123 Main St',
                              margin: EdgeInsets.zero,
                            ),
                            const SizedBox(height: 20),
                            
                            // District & Upazila side-by-side searchable dropdowns
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: SearchableDropdown(
                                    label: 'District',
                                    hint: 'Select District',
                                    value: selectedDistrict,
                                    items: bangladeshDistrictsAndUpazilas.keys.toList(),
                                    onChanged: (district) {
                                      setState(() {
                                        selectedDistrict = district;
                                        selectedUpazila = null; // Reset upazila when district changes
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: SearchableDropdown(
                                    label: 'Upazila / Thana',
                                    hint: 'Select Upazila',
                                    value: selectedUpazila,
                                    items: selectedDistrict != null
                                        ? bangladeshDistrictsAndUpazilas[selectedDistrict] ?? []
                                        : [],
                                    onChanged: (upazila) {
                                      setState(() {
                                        selectedUpazila = upazila;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Conditional Map Section for Academy
                      if (selectedRole == 'academy') ...[
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: latitudeController,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  decoration: InputDecoration(
                                    labelText: 'Latitude',
                                    labelStyle: TextStyle(color: AppColor.nokiaBlue),
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.nokiaBlue),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: longitudeController,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  decoration: InputDecoration(
                                    labelText: 'Longitude',
                                    labelStyle: TextStyle(color: AppColor.nokiaBlue),
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(color: AppColor.nokiaBlue),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            '* Click map icon to auto-fill or type manually',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],

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
        // Log account and address details to console for debugging
        print('Account loaded: ${account.toJson()}');
        print('Address: ${account.address?.toJson()}');

        if (mounted) {
          setState(() {
            nameController.text = account.name ?? '';
            usernameController.text = account.username ?? '';
            aboutController.text = account.about ?? '';

            if (account.image != null) {
              netProfileImage = account.image;
            }
            if (account.coverImage != null) {
              netCoverImage = account.coverImage;
            }

            if (account.address != null) {
              selectedDistrict = account.address!.district;
              selectedUpazila = account.address!.upazila;
              streetAddressController.text = account.address!.streetAddress ?? '';
              latitudeController.text = account.address!.latitude != null
                  ? account.address!.latitude.toString()
                  : '';
              longitudeController.text = account.address!.longitude != null
                  ? account.address!.longitude.toString()
                  : '';
            }

            // 🟢 ডাটাবেজ থেকে পাওয়া রোল রিভারপড প্রোভাইডারে সেট করা হচ্ছে (ধরে নেওয়া হচ্ছে ডাটাবেজে student/academy বা অনুরুপ ভ্যালু আছে)
            final String currentRole =
                account.accountType?.toString().split('.').last.toLowerCase() ??
                'student';
            ref.read(selectAccountTypeProvider.notifier).update((state) => currentRole);
          });
        }
      },
    );
  }

  Future<void> _updateAccount(BuildContext context) async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    setState(() => isLoading = true);
    Alert.showSnackBar(context, 'Updating your profile, please wait...');

    final selectedRole = ref.read(selectAccountTypeProvider);

    final editAccountData = AccountEditModel(
      name: nameController.text,
      username: usernameController.text,
      about: aboutController.text,
      accountType: selectedRole,
      district: selectedDistrict,
      upazila: selectedUpazila,
      streetAddress: streetAddressController.text.isNotEmpty ? streetAddressController.text : null,
      latitude: (selectedRole == 'academy' && latitudeController.text.isNotEmpty)
          ? double.tryParse(latitudeController.text)
          : null,
      longitude: (selectedRole == 'academy' && longitudeController.text.isNotEmpty)
          ? double.tryParse(longitudeController.text)
          : null,
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
        ref.invalidate(accountDataProvider(null));
        Alert.showSnackBar(context, 'Success: $message');
        if (mounted) Navigator.pop(context);
      },
    );

    if (mounted) setState(() => isLoading = false);
  }
}
