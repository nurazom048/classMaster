// ignore_for_file: use_build_context_synchronously, unused_result

import 'package:classmate/core/component/heder_component/transition/right_to_left_transition.dart';
import 'package:classmate/route/route_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/my_divider.dart';

import 'package:classmate/features/collection_fetures/Ui/aboutus_screen.dart';
import 'package:classmate/features/routine/presentation/screens/save_routines_screen.dart';
import 'package:classmate/features/routine_summary_fetures/presentation/screens/save_summary_screen.dart';
import '../../../core/constant/enum.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/export_core.dart';
import '../../../core/widgets/account_card.dart';
import '../../../core/widgets/my_container_button.dart';
import '../../account_fetures/domain/providers/account_providers.dart';
import '../../authentication_fetures/domain/providers/auth_controller.dart';
import '../../notice_fetures/presentation/screens/view_all_recent_notice.dart';
import '../../../services/firebase/firebase_analytics.service.dart';
import '../../../services/notification_services/awn_package.dart';
import '../../../services/notification_services/local_notifications.dart';
import '../../../services/notification_services/notification.dart';
import '../../home_fetures/presentation/utils/utils.dart';
import '../../account_fetures/presentation/screens/profile_screen.dart';
import 'setting_screen.dart';
import '../../account_fetures/presentation/screens/edit_account.dart';
import 'package:go_router/go_router.dart';
import '../../../core/local_data/local_data.dart';

//! Hidden Bottom Nav on Scroll
final hideNevBarOnScorningProvider = StateProvider.autoDispose<bool>(
  (ref) => false,
);

class CollectionScreen extends ConsumerStatefulWidget {
  final String? accountUsername;

  const CollectionScreen({super.key, this.accountUsername});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CollectionScreenState();
}

class _CollectionScreenState extends ConsumerState<CollectionScreen> {
  late ScrollController collectionPageScroll;

  @override
  void initState() {
    super.initState();
    collectionPageScroll = ScrollController();
    // Request notification permission on screen init
    AwesomeNotificationSetup.takePermission(context);
    // Log screen event in Firebase Analytics
    FirebaseAnalyticsServices.logEvent(
      name: 'collection_screen',
      parameters: {"content_type": "ontap"},
    );
  }

  @override
  void dispose() {
    // Dispose the scroll controller to prevent memory leaks
    collectionPageScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isGuest = ref.watch(isGuestProvider).value ?? false;
    final isMobile = MediaQuery.of(context).size.width < 650;

    final Widget bodyContent;

    if (isGuest) {
      bodyContent = Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person_outline, size: 72, color: Colors.grey),
              const SizedBox(height: 24),
              Text(
                "You are exploring as a guest.",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.titleLarge?.color ?? Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                "Login to access your profile, saved routines, and more.",
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7) ?? Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () async {
                  await LocalData.emptyLocal();
                  if (context.mounted) GoRouter.of(context).go('/auth/login');
                },
                icon: const Icon(Icons.login),
                label: const Text("Login Now"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  backgroundColor: const Color(0xFF0066CC),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      bodyContent = Consumer(
        builder: (context, ref, _) {
          return NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              Utils.hideNevBarOnScroll(scrollNotification, ref);
              return false;
            },
            child: RefreshIndicator(
              onRefresh: () async {
                final bool isOnline = await Utils.isOnlineMethod();
                if (!isOnline) {
                  Alert.showSnackBar(context, 'You are in offline mode');
                } else {
                  try {
                    await ref.refresh(accountDataProvider(widget.accountUsername).future);
                  } catch (e) {
                    // Handled by accountDataProvider error state
                  }
                }
              },
              child: SingleChildScrollView(
                controller: collectionPageScroll,
                padding: EdgeInsets.only(bottom: isMobile ? 100 : 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isMobile)
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Collection',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    Consumer(
                      builder: (context, ref, _) {
                        final accountData = ref.watch(
                          accountDataProvider(widget.accountUsername),
                        );
                        return SizedBox(
                          height: 129,
                          child: accountData.when(
                            data:
                                (data) => data.fold(
                                  (l) => const Center(
                                    child: Text("No Data Available"),
                                  ),
                                  (r) => AccountCard(
                                    account: r,
                                    onTap: () {
                                      context.pushNamed(
                                        RouteConst.viewProfile,
                                        params: {'username': r.username ?? ''},
                                      );
                                    },
                                  ),
                                ),
                            error: (error, stackTrace) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (context.mounted) {
                                  Alert.showSnackBar(context, error.toString());
                                }
                              });
                              return const Center(
                                child: Text("Failed to load account details"),
                              );
                            },
                            loading:
                                () => SizedBox(
                                  height: 100,
                                  child: Center(child: Loaders.center()),
                                ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 5),
                    Consumer(
                      builder: (context, ref, _) {
                        final classNotification = ref.watch(
                          classNotificationProvider,
                        );
                        return SizedBox(
                          height: 1,
                          width: 1,
                          child: classNotification.when(
                            data: (data) {
                              if (data != null) {
                                LocalNotification.scheduleNotifications(data);
                              }
                              return const SizedBox();
                            },
                            error: (error, stackTrace) => const SizedBox(),
                            loading: () => const SizedBox(),
                          ),
                        );
                      },
                    ),
                    MyContainerButton(
                      const FaIcon(FontAwesomeIcons.pen),
                      "Edit Profile",
                      onTap: () {
                        GoRouter.of(
                          context,
                        ).pushNamed(RouteConst.editAccount);
                      },
                    ),
                    const SizedBox(height: 10),
                    Consumer(
                      builder: (context, ref, _) {
                        final accountData = ref.watch(
                          accountDataProvider(widget.accountUsername),
                        );
                        return accountData.when(
                          data:
                              (data) => data.fold(
                                (l) => const Center(
                                  child: Text("User data not found"),
                                ),
                                (r) =>
                                    r.accountType == AccountTypeString.academy
                                        ? MyContainerButton(
                                          const Icon(Icons.calendar_month),
                                          "My NoticeBoard",
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              RightToLeftTransition(
                                                page: ViewAllRecentNotice(),
                                              ),
                                            );
                                          },
                                        )
                                        : const SizedBox(),
                              ),
                          error:
                              (error, stackTrace) => const SizedBox.shrink(),
                          loading: () => const SizedBox.shrink(),
                        );
                      },
                    ),
                    const MyDividerr(thickness: 1.0, height: 1.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TilesButton(
                          "Saved\nRoutines",
                          const FaIcon(FontAwesomeIcons.bookmark),
                          saxpath:
                              'assets/svg/undraw_personal_file_re_5joy.svg',
                          imageMargin: const EdgeInsets.only(left: 10),
                          onTap: () {
                            Navigator.push(
                              context,
                              RightToLeftTransition(
                                page: const SaveRoutinesScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 20),
                        TilesButton(
                          "Saved Summaries",
                          const FaIcon(FontAwesomeIcons.bookmark),
                          saxpath:
                              'assets/svg/undraw_my_documents_re_13dc.svg',
                          onTap: () {
                            Navigator.push(
                              context,
                              RightToLeftTransition(
                                page: const SaveSummeryScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const MyDividerr(thickness: 1.0, height: 1.0),
                    MyContainerButton(
                      const Icon(Icons.settings_outlined),
                      "Settings",
                      onTap: () {
                        GoRouter.of(
                          context,
                        ).pushNamed(RouteConst.settingsPage);
                      },
                    ),
                    MyContainerButton(
                      const Icon(Icons.logout_outlined),
                      "Sign out",
                      color: Colors.red,
                      onTap: () => AuthController.logOut(context, ref: ref),
                    ),
                    const MyDividerr(thickness: 1.0, height: 1.0),
                    MyContainerButton(
                      const Icon(Icons.help_rounded),
                      "About",
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AboutScreen(),
                            ),
                          ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: isMobile ? null : const AppBarCustom('Collection', leadingIcon: false),
      body: SafeArea(
        child: bodyContent,
      ),
    );
  }
}
