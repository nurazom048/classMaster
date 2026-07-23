// ignore_for_file: deprecated_member_use

import 'package:classmate/core/local_data/local_data.dart' show LocalData;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:classmate/core/dialogs/alert_dialogs.dart';

import '../../core/constant/app_color.dart';
import '../../core/constant/enums.dart';

import '../../core/component/responsive.dart';
import '../../core/widgets/bottom_sheet_shape.dart';
import '../../features/notice_fetures/presentation/screens/add_notice_screen.dart';
import '../../features/routine/presentation/screens/create_new_routine.dart';
import '../../features/routine/presentation/widgets/static_widgets/dash_border_button.dart';
import '../../features/collection_fetures/Ui/collections.screen.dart';
import '../../features/home_fetures/presentation/screens/home.screen.dart';
import '../../core/widgets/widgets/bottom_bar_item_custom.dart';
import '../../core/widgets/widgets/mydrawer.dart';
import '../../core/widgets/widgets/promo_ad_widget.dart';
import '../../core/component/heder_component/transition/right_to_left_transition.dart';

final bottomNavBarIndexProvider = StateProvider<int>((ref) => 0);
final showPlusProvider = StateProvider<bool>((ref) => false);
final drawerActiveItemProvider = StateProvider<DrawerItem>(
  (ref) => DrawerItem.home,
);

final GlobalKey<NavigatorState> collectionNavigatorKey =
    GlobalKey<NavigatorState>();

class CollectionNavigator extends ConsumerWidget {
  const CollectionNavigator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      onWillPop: () async {
        final NavigatorState? navigator = collectionNavigatorKey.currentState;
        if (navigator != null && navigator.canPop()) {
          navigator.pop();
          if (!navigator.canPop()) {
            ref.read(bottomNavBarIndexProvider.notifier).state = 0;
            ref.read(drawerActiveItemProvider.notifier).state = DrawerItem.home;
          }
          return false;
        }
        return true;
      },
      child: Navigator(
        key: collectionNavigatorKey,
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (context) => const CollectionScreen(),
            settings: settings,
          );
        },
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  BottomNavBar({super.key});

  final List<Widget> pages = [
    const HomeScreen(),
    const Text("Add Screen"),
    const CollectionNavigator(),
  ];

  // Add Button
  static Widget add = CircleAvatar(
    radius: 20,
    backgroundColor: AppColor.nokiaBlue,
    child: const Icon(Icons.add, color: Colors.white),
  );

  // Add popup
  static addPopup(BuildContext context) => plusBottomSheet(context);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final index = ref.watch(bottomNavBarIndexProvider);
        final width = MediaQuery.of(context).size.width;

        final isMobile = width < 650;
        final isDesktop = width >= 1100;
        final showAd = ref.watch(showAdProvider);

        if (isMobile) {
          // 📱 Mobile View: Drawer sidebar & floating bottom navigation bar
          final hideNavBar = ref.watch(hideNevBarOnScorningProvider);
          final showPlus = ref.watch(showPlusProvider);

          return Scaffold(
            extendBody: true,
            drawer: const Drawer(child: MyDrawer()),
            body: IndexedStack(index: index, children: pages),
            bottomNavigationBar: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: hideNavBar ? 0 : 80,
              child: Wrap(
                children: [
                  SafeArea(
                    bottom: true,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                      child: Container(
                        height: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(63),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.35),
                              blurRadius: 40,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            BottomBarItemCustom(
                              label: "Home",
                              icon: Icons.home_filled,
                              isSelected: index == 0 && showPlus == false,
                              onTap: () {
                                ref
                                    .read(bottomNavBarIndexProvider.notifier)
                                    .state = 0;
                                ref
                                    .read(drawerActiveItemProvider.notifier)
                                    .state = DrawerItem.home;
                              },
                            ),
                            InkWell(
                              onTap: () {
                                ref
                                    .read(showPlusProvider.notifier)
                                    .update((state) => !state);
                                plusBottomSheet(context);
                              },
                              child:
                                  showPlus == false
                                      ? CircleAvatar(
                                        radius: 19,
                                        backgroundColor: AppColor.nokiaBlue,
                                        child: CircleAvatar(
                                          radius: 17.6,
                                          backgroundColor: Colors.white,
                                          child: FaIcon(
                                            FontAwesomeIcons.plus,
                                            color: AppColor.nokiaBlue,
                                          ),
                                        ),
                                      )
                                      : CircleAvatar(
                                        radius: 20,
                                        backgroundColor: AppColor.nokiaBlue,
                                        child: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                      ),
                            ),
                            BottomBarItemCustom(
                              label: "Collections",
                              icon: Icons.person_outline_outlined,
                              isSelected: index == 2 && showPlus == false,
                              onTap: () {
                                ref
                                    .read(bottomNavBarIndexProvider.notifier)
                                    .state = 2;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          // 💻 Tablet & Desktop View: 2-part or 3-part layout
          return Scaffold(
            body: Row(
              children: [
                // 1️⃣ First Part: Persistent Sidebar (Drawer-like)
                const SizedBox(width: 260, child: MyDrawer()),

                const VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: Color(0xFFF3F4F6),
                ),

                // 2️⃣ Second Part: Main content area (takes remaining space)
                Expanded(child: IndexedStack(index: index, children: pages)),

                // 3️⃣ Third Part: Promotional Ad (Desktop only, if visible & on Home page)
                if (isDesktop && showAd && index == 0) ...[
                  const VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: Color(0xFFF3F4F6),
                  ),
                  const SizedBox(width: 320, child: PromoAdWidget()),
                ],
              ],
            ),
          );
        }
      },
    );
  }
}

plusBottomSheet(BuildContext context) {
  showModalBottomSheet(
    barrierColor: Colors.transparent,
    elevation: 0,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    context: context,
    showDragHandle: false,
    enableDrag: false,
    builder: (BuildContext context) {
      return Consumer(
        builder: (context, ref, _) {
          return Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ref.read(showPlusProvider.notifier).state = false;
                    Navigator.of(context).pop();
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white60,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.35),
                          blurRadius: 40,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BottomSheetShape(
                          size: 500,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DashBorderButtonMini(
                                  text: "Notices",
                                  icon: Icons.calendar_view_day,
                                  onTap: () async {
                                    final String? type =
                                        await LocalData.getAccountType();
                                    if (!context.mounted) return;

                                    if (type != null &&
                                        type == AccountTypeString.academy) {
                                      ref
                                          .read(showPlusProvider.notifier)
                                          .state = false;
                                      Navigator.pop(context);
                                      ref
                                          .read(
                                            drawerActiveItemProvider.notifier,
                                          )
                                          .state = DrawerItem.add;
                                      ref
                                          .read(
                                            bottomNavBarIndexProvider.notifier,
                                          )
                                          .state = 2;
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                            collectionNavigatorKey.currentState
                                                ?.push(
                                                  RightToLeftTransition(
                                                    page: AddNoticeScreen(),
                                                  ),
                                                );
                                          });
                                    } else {
                                      Alert.upcoming(context);
                                    }
                                  },
                                ),
                                Row(
                                  children: [
                                    DashBorderButtonMini(
                                      text: "Routine",
                                      icon: Icons.blender_outlined,
                                      onTap: () {
                                        ref
                                            .read(showPlusProvider.notifier)
                                            .state = false;
                                        Navigator.pop(context);
                                        ref
                                            .read(
                                              drawerActiveItemProvider.notifier,
                                            )
                                            .state = DrawerItem.add;
                                        ref
                                            .read(
                                              bottomNavBarIndexProvider
                                                  .notifier,
                                            )
                                            .state = 2;
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                              collectionNavigatorKey
                                                  .currentState
                                                  ?.push(
                                                    RightToLeftTransition(
                                                      page: CreateNewRoutine(),
                                                    ),
                                                  );
                                            });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  ref.read(showPlusProvider.notifier).state = false;
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.615),
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
