// ignore_for_file: file_names, deprecated_member_use, use_build_context_synchronously

import 'package:classmate/core/widgets/appWidget/buttons/cupertino_buttons.dart';
import 'package:classmate/core/widgets/widgets/animi/auth_animi_wiggets.dart';
import 'package:classmate/features/authentication_fetures/presentation/widgets/static_widget/charcater_painter.dart';
import 'package:classmate/features/authentication_fetures/presentation/widgets/static_widget/forget_password_btn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classmate/core/dialogs/alert_dialogs.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constant/app_color.dart';
import '../../../../core/widgets/appWidget/text_form_field.dart';
import '../../../../core/widgets/appWidget/app_text.dart';
import '../../../../core/widgets/heder/heder_title.dart';

import '../../../../route/route_constant.dart';
import '../../../../core/local_data/local_data.dart';
import '../../data/services/credential_save_service.dart';
import '../../data/services/saved_accounts_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/providers/auth_controller.dart';
import '../../domain/providers/google_auth_controller.dart';

import '../utils/validators/login_validation.dart';
import '../widgets/static_widget/or.dart';
import '../widgets/static_widget/sign_up_page_switch.dart';
import '../widgets/static_widget/social_login_button.dart';
import 'dart:async';
import 'dart:math';

class AnimatedLoginScreen extends StatelessWidget {
  const AnimatedLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter',
        scaffoldBackgroundColor: const Color(0xFFEAEAEF),
      ),
      home: const LoginScreen(),
    );
  }
}

// ============================================================================
// PART 2: ACTUAL LOGIN SCREEN (Form Content + Logic)
// Uses the AuthAnimationScreen wrapper to inherit the animations
// ============================================================================

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  bool _isPasswordVisible = false;
  bool _byUsername = false;

  // Saved accounts state (Facebook style)
  List<SavedAccount> _savedAccounts = [];
  bool _showManualForm = false;

  // Trackable states passed down to the reusable animation wrapper
  double _inputProgress = 0.0;
  bool _isWhistling = false;
  bool _isAngry = false;
  bool _isHappy = false;

  String _statusText = "Please enter your details";
  Color _statusColor = Colors.grey.shade500;

  @override
  void initState() {
    super.initState();
    _loadSavedAccountsList();
    _loadSavedCredentials();

    void updateProgress() {
      if (_isAngry || _isHappy) return;
      setState(() {
        final textLength =
            _byUsername
                ? _usernameController.text.length
                : _emailController.text.length;
        _inputProgress = min(textLength / 30.0, 1.0);
      });
    }

    _emailController.addListener(updateProgress);
    _usernameController.addListener(updateProgress);

    _emailFocus.addListener(() {
      setState(() {});
    });

    _passwordFocus.addListener(() {
      if (_isAngry || _isHappy || _isPasswordVisible) return;
      setState(() {
        _isWhistling = _passwordFocus.hasFocus;
      });
    });
  }

  Future<void> _loadSavedAccountsList() async {
    final list = await SavedAccountsService.getSavedAccounts();
    if (mounted) {
      setState(() {
        _savedAccounts = list;
        if (list.isNotEmpty) {
          _showManualForm = false;
        } else {
          _showManualForm = true;
        }
      });
    }
  }

  Future<void> _loadSavedCredentials() async {
    final credentials = await CredentialSaveService.getSavedCredentials();
    if (credentials.isEmpty) return;

    setState(() {
      if (credentials['username'] != null &&
          credentials['username']!.isNotEmpty) {
        _byUsername = true;
        _usernameController.text = credentials['username']!;
      } else if (credentials['email'] != null &&
          credentials['email']!.isNotEmpty) {
        _byUsername = false;
        _emailController.text = credentials['email']!;
      }
      if (credentials['password'] != null) {
        _passwordController.text = credentials['password']!;
      }

      // Update progress bar
      final textLength =
          _byUsername
              ? _usernameController.text.length
              : _emailController.text.length;
      _inputProgress = min(textLength / 30.0, 1.0);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _resetToNormal() {
    if (mounted) {
      setState(() {
        _isAngry = false;
        _isHappy = false;
        _statusText = "Please enter your details";
        _statusColor = Colors.grey.shade500;
        if (_passwordFocus.hasFocus && !_isPasswordVisible) {
          _isWhistling = true;
        }
      });
    }
  }

  void _triggerFeedback(bool isSuccess) {
    FocusScope.of(context).unfocus();
    setState(() {
      _isWhistling = false;
    });

    if (!isSuccess) {
      setState(() {
        _isAngry = true;
        _statusText = "Validation Failed! Please check fields.";
        _statusColor = Colors.red.shade500;
      });
      Future.delayed(const Duration(seconds: 2), _resetToNormal);
    } else {
      setState(() {
        _isHappy = true;
        _statusText = "Processing login details...";
        _statusColor = Colors.green.shade500;
      });
      Future.delayed(const Duration(seconds: 3), _resetToNormal);
    }
  }

  void _loginWithSavedAccount(SavedAccount account, AuthController authLogin) {
    _triggerFeedback(true);
    authLogin.signIn(
      context,
      username: account.username,
      email: account.email,
      password: account.password,
    );
  }

  void _confirmRemoveSavedAccount(SavedAccount account) {
    Alert.errorAlertDialogCallBack(
      context,
      "Remove ${account.name ?? account.id} from this device?",
      onConfirm: (isConfirmed) async {
        if (isConfirmed) {
          await SavedAccountsService.removeAccount(account.id);
          await _loadSavedAccountsList();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final authLogin = ref.watch(authController_provider.notifier);
        final bool loading = ref.watch(authController_provider);
        final googleAuthProvider = ref.read(googleAuthControllerProvider);

        return AuthAnimationScreen(
          progress: _inputProgress,
          isFocused: _emailFocus.hasFocus,
          isEyesClosed:
              _isPasswordVisible ||
              (_passwordFocus.hasFocus && !_isPasswordVisible),
          isWhistling: _isWhistling,
          isAngry: _isAngry,
          isHappy: _isHappy,
          child: Form(
            key: _formKey,
            child: AutofillGroup(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand Header (Logo & Title)
                  Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/png/logo.png',
                              width: 36,
                              height: 36,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.school,
                                  color: AppColor.nokiaBlue,
                                  size: 36,
                                );
                              },
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "Class Master",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          (!_showManualForm && _savedAccounts.isNotEmpty)
                              ? "Recent Logins"
                              : "Welcome back!",
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          (!_showManualForm && _savedAccounts.isNotEmpty)
                              ? "Tap your picture or account to log in"
                              : _statusText,
                          style: TextStyle(
                            fontSize: 14,
                            color: _statusColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // =========================================================
                  // SECTION A: SAVED ACCOUNTS CARD LIST (Facebook Style)
                  // =========================================================
                  if (!_showManualForm && _savedAccounts.isNotEmpty) ...[
                    ..._savedAccounts.map((account) {
                      final String displayName =
                          account.name ??
                          (account.username ??
                              account.email ??
                              'Saved Account');
                      final String subtitle =
                          account.username != null &&
                                  account.username!.isNotEmpty
                              ? "@${account.username}"
                              : (account.email ?? '');

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap:
                              loading
                                  ? null
                                  : () => _loginWithSavedAccount(
                                    account,
                                    authLogin,
                                  ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 26,
                                  backgroundColor: AppColor.nokiaBlue
                                      .withOpacity(0.1),
                                  backgroundImage:
                                      account.imageUrl != null &&
                                              account.imageUrl!.isNotEmpty
                                          ? CachedNetworkImageProvider(
                                            account.imageUrl!,
                                          )
                                          : null,
                                  child:
                                      account.imageUrl == null ||
                                              account.imageUrl!.isEmpty
                                          ? Text(
                                            displayName.isNotEmpty
                                                ? displayName[0].toUpperCase()
                                                : 'U',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: AppColor.nokiaBlue,
                                            ),
                                          )
                                          : null,
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        displayName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF111827),
                                        ),
                                      ),
                                      if (subtitle.isNotEmpty) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          subtitle,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                  onPressed:
                                      () => _confirmRemoveSavedAccount(account),
                                ),
                                const Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 10),

                    // "Use another account" Button (Facebook Style)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _showManualForm = true;
                          });
                        },
                        icon: const Icon(
                          Icons.person_add_outlined,
                          size: 20,
                          color: Color(0xFF111827),
                        ),
                        label: const Text(
                          "Use another profile",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF111827),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: const Color(0xFFF0F2F5),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Create New Account Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          context.pushNamed(
                            RouteConst.signUp,
                            extra: _emailController.text.trim().toString(),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Color(0xFF164BB6)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Create new account",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF164BB6),
                          ),
                        ),
                      ),
                    ),
                  ]

                  // =========================================================
                  // SECTION B: MANUAL LOGIN FORM SECTION
                  // =========================================================
                  else ...[
                    if (_savedAccounts.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _showManualForm = false;
                            });
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.arrow_back,
                                size: 18,
                                color: AppColor.nokiaBlue,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "Back to saved profiles",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.nokiaBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Email/Username Field
                    AppTextFromField(
                      focusNode: _emailFocus,
                      margin: EdgeInsets.zero,
                      autofillHints:
                          _byUsername
                              ? const [AutofillHints.username]
                              : const [AutofillHints.email],
                      controller:
                          _byUsername ? _usernameController : _emailController,
                      hint: _byUsername ? 'Username' : "Email",
                      labelText:
                          _byUsername
                              ? "Enter Username"
                              : "Enter email address",
                      validator: (value) {
                        if (_byUsername) {
                          return LoginValidation.validUsername(value);
                        } else {
                          return LoginValidation.validateEmail(value);
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                _byUsername = !_byUsername;
                                _emailController.clear();
                                _usernameController.clear();
                                _emailFocus.requestFocus();
                              });
                            },
                            child: Text(
                              _byUsername ? 'With Email?' : 'With Username?',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Password Field
                    AppTextFromField(
                      focusNode: _passwordFocus,
                      margin: EdgeInsets.zero,
                      autofillHints: const [AutofillHints.password],
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      hint: "Password",
                      labelText: "••••••••",
                      validator:
                          (value) => LoginValidation.validatePassword(value),
                    ),

                    const SizedBox(height: 16),

                    // Forget password
                    ForgetPasswordBtn(
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        context.pushNamed(
                          RouteConst.forgetPassword,
                          extra: _emailController.text.trim().toString(),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Custom Login Button with Validation
                    CupertinoButtonCustom(
                      isLoading: loading,
                      padding: EdgeInsets.zero,
                      color: AppColor.nokiaBlue,
                      text: "Log In",
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          _triggerFeedback(true);
                          authLogin.signIn(
                            context,
                            username: _usernameController.text.trim(),
                            email: _emailController.text.trim(),
                            password: _passwordController.text,
                          );
                        } else {
                          _triggerFeedback(false);
                          Alert.showSnackBar(context, 'Fill the form');
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        // Google Login Button
                        Expanded(
                          child: SocialLoginButton(
                            margin: EdgeInsets.zero,
                            isLoading: false,
                            onTap: () {
                              googleAuthProvider.signing(context, ref);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Guest Login Button
                        Expanded(
                          child: SocialLoginButton(
                            margin: EdgeInsets.zero,
                            backgroundColor: Colors.blueGrey.shade50,
                            textColor: Colors.blueGrey.shade700,
                            icon: Icon(
                              Icons.explore_outlined,
                              color: Colors.blueGrey.shade700,
                              size: 20,
                            ),
                            text: "Explore",
                            isLoading: false,
                            onTap: () async {
                              final router = GoRouter.of(context);
                              await LocalData.emptyLocal();
                              await LocalData.saveIsGuest(true);
                              router.go('/home');
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          context.pushNamed(
                            RouteConst.signUp,
                            extra: _emailController.text.trim().toString(),
                          );
                        },
                        child: RichText(
                          text: const TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(
                              color: Color.fromARGB(255, 22, 75, 182),
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(
                                text: "Sign up",
                                style: TextStyle(
                                  color: Color(0xFF111827),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
