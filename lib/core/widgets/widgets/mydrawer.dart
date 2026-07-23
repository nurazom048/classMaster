import 'package:classmate/core/constant/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../route/route_constant.dart';
import '../../constant/app_color.dart';
import '../../constant/logo_const.dart';
import '../../local_data/local_data.dart';
import '../../../features/account_fetures/domain/providers/account_providers.dart';
import '../../../features/account_fetures/data/models/account_models.dart';
import '../../../ui/bottom_nevbar_items/bottom_navbar.dart';
import 'package:classmate/core/component/heder_component/transition/right_to_left_transition.dart';
import 'package:classmate/features/routine/presentation/screens/save_routines_screen.dart';
import 'package:classmate/features/routine_summary_fetures/presentation/screens/save_summary_screen.dart';
import 'package:classmate/features/notice_fetures/presentation/screens/saved_notices_screen.dart';
import 'package:classmate/features/search_fetures/presentation/screens/search_page.dart';
import 'package:classmate/features/collection_fetures/Ui/setting_screen.dart';
import 'package:classmate/features/notification/screen/notification.screen.dart';
import 'package:classmate/features/account_fetures/presentation/screens/profile_screen.dart';

class MyDrawer extends ConsumerStatefulWidget {
  const MyDrawer({super.key});

  @override
  ConsumerState<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends ConsumerState<MyDrawer> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _navigateToShellPage(Widget page, bool isMobile, DrawerItem drawerItem) {
    if (isMobile) Navigator.pop(context);
    ref.read(drawerActiveItemProvider.notifier).state = drawerItem;
    ref.read(bottomNavBarIndexProvider.notifier).state = 2;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      collectionNavigatorKey.currentState?.popUntil((route) => route.isFirst);
      collectionNavigatorKey.currentState?.push(
        RightToLeftTransition(page: page),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 650;
    final index = ref.watch(bottomNavBarIndexProvider);
    final drawerActiveItem = ref.watch(drawerActiveItemProvider);
    final effectiveActiveItem = index == 0 ? DrawerItem.home : drawerActiveItem;

    // Fetch user details
    final isGuestAsync = ref.watch(isGuestProvider);
    final isGuest = isGuestAsync.value ?? false;
    final accountData = isGuest ? null : ref.watch(accountDataProvider(null));

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // 🏷️ Header: Logo & Hamburger Close Button (for Mobile)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          LogoConst.logo,
                          width: 32,
                          height: 32,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "classMaster",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: AppColor.nokiaBlue,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  if (isMobile)
                    IconButton(
                      icon: const Icon(
                        Icons.menu_open,
                        size: 24,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),

            // 📜 Scrollable Menu Items
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // =============================================
                      // 🧭 Navigation Items
                      // =============================================
                      _buildMenuItem(
                        icon: Icons.home_filled,
                        text: "Home",
                        isActive: effectiveActiveItem == DrawerItem.home,
                        onTap: () {
                          if (isMobile) Navigator.pop(context);
                          ref.read(drawerActiveItemProvider.notifier).state =
                              DrawerItem.home;
                          ref.read(bottomNavBarIndexProvider.notifier).state =
                              0;
                        },
                      ),
                      const SizedBox(height: 4),
                      _buildMenuItem(
                        icon: Icons.add_circle_outline,
                        text: "Add",
                        isActive: effectiveActiveItem == DrawerItem.add,
                        onTap: () {
                          if (isMobile) Navigator.pop(context);
                          ref.read(drawerActiveItemProvider.notifier).state =
                              DrawerItem.add;
                          BottomNavBar.addPopup(context);
                        },
                      ),
                      const SizedBox(height: 4),
                      _buildMenuItem(
                        icon: Icons.search,
                        text: "Search",
                        isActive: effectiveActiveItem == DrawerItem.search,
                        onTap:
                            () => _navigateToShellPage(
                              const SearchPage(),
                              isMobile,
                              DrawerItem.search,
                            ),
                      ),

                      const SizedBox(height: 24),

                      // =============================================
                      // 📂 Saved Section
                      // =============================================
                      _buildSectionHeader("SAVED"),
                      const SizedBox(height: 8),
                      _buildMenuItem(
                        icon: Icons.bookmark_border,
                        text: "Save Notice",
                        isActive: effectiveActiveItem == DrawerItem.saveNotice,
                        onTap:
                            () => _navigateToShellPage(
                              const SavedNoticesScreen(),
                              isMobile,
                              DrawerItem.saveNotice,
                            ),
                      ),
                      const SizedBox(height: 4),
                      _buildMenuItem(
                        icon: Icons.schedule,
                        text: "Save Routine",
                        isActive: effectiveActiveItem == DrawerItem.saveRoutine,
                        onTap:
                            () => _navigateToShellPage(
                              const SaveRoutinesScreen(),
                              isMobile,
                              DrawerItem.saveRoutine,
                            ),
                      ),
                      const SizedBox(height: 4),
                      _buildMenuItem(
                        icon: Icons.schedule,
                        text: "Save Summaries",
                        isActive: effectiveActiveItem == DrawerItem.saveSummary,
                        onTap:
                            () => _navigateToShellPage(
                              const SaveSummeryScreen(),
                              isMobile,
                              DrawerItem.saveSummary,
                            ),
                      ),
                      const SizedBox(height: 24),

                      // =============================================
                      // ⚙️ Other Section
                      // =============================================
                      _buildSectionHeader("OTHER"),
                      const SizedBox(height: 8),
                      _buildMenuItem(
                        icon: Icons.settings_outlined,
                        text: "Settings",
                        isActive: effectiveActiveItem == DrawerItem.settings,
                        onTap:
                            () => _navigateToShellPage(
                              SettingsPage(),
                              isMobile,
                              DrawerItem.settings,
                            ),
                      ),
                      const SizedBox(height: 4),
                      _buildMenuItem(
                        icon: Icons.notifications_none_outlined,
                        text: "Notifications",
                        isActive:
                            effectiveActiveItem == DrawerItem.notifications,
                        onTap:
                            () => _navigateToShellPage(
                              const NotificationScreen(),
                              isMobile,
                              DrawerItem.notifications,
                            ),
                      ),
                      const SizedBox(height: 4),
                      // _buildMenuItem(
                      //   icon: Icons.help_outline_outlined,
                      //   text: "abou us",
                      //   isActive: false,
                      //   onTap: () {

                      // ),
                      const SizedBox(height: 4),
                      _buildMenuItem(
                        icon: Icons.help_outline_outlined,
                        text: "Help & Support",
                        isActive: false,
                        onTap: () {
                          if (isMobile) Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Support team: support@classmaster.top",
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      _buildMenuItem(
                        icon: Icons.logout_outlined,
                        text: "Sign Out",
                        isActive: false,
                        textColor: Colors.redAccent,
                        iconColor: Colors.redAccent,
                        onTap: () => _handleLogout(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),

            // =============================================
            // 👤 Bottom Profile Card
            // =============================================
            accountData != null
                ? accountData.when(
                  data: (either) {
                    return either.fold(
                      (err) => _buildProfileCard(
                        null,
                        '?',
                        'Guest User',
                        '@guest',
                        isMobile,
                        isGuest,
                      ),
                      (acc) => _buildProfileCard(
                        acc.imageUrl,
                        acc.name != null && acc.name!.isNotEmpty
                            ? acc.name![0].toUpperCase()
                            : 'N',
                        acc.name ?? 'Md Nur Azom',
                        acc.username != null
                            ? '@${acc.username}'
                            : '@nurazom049',
                        isMobile,
                        isGuest,
                      ),
                    );
                  },
                  loading:
                      () => const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                  error:
                      (err, stack) => _buildProfileCard(
                        null,
                        '?',
                        'Guest User',
                        '@guest',
                        isMobile,
                        isGuest,
                      ),
                )
                : _buildProfileCard(
                  null,
                  'N',
                  'Md Nur Azom',
                  '@nurazom049',
                  isMobile,
                  isGuest,
                ),
          ],
        ),
      ),
    );
  }

  // Section Header (e.g. SAVED, OTHER)
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade400,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  // Sidebar Menu Item Widget with Hover & Selected styles
  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required bool isActive,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color:
                isActive
                    ? AppColor.nokiaBlue.withOpacity(0.08)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 22,
                color:
                    isActive
                        ? AppColor.nokiaBlue
                        : (iconColor ?? Colors.grey.shade600),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    color:
                        isActive
                            ? AppColor.nokiaBlue
                            : (textColor ?? Colors.grey.shade800),
                  ),
                ),
              ),
              if (isActive)
                Container(
                  width: 4,
                  height: 18,
                  decoration: BoxDecoration(
                    color: AppColor.nokiaBlue,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Sidebar User Card Widget at the Bottom
  Widget _buildProfileCard(
    String? imgUrl,
    String initial,
    String name,
    String username,
    bool isMobile,
    bool isGuest,
  ) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: InkWell(
        onTap:
            () => _navigateToShellPage(
              const ProfileScreen(),
              isMobile,
              DrawerItem.profile,
            ),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColor.nokiaBlue.withOpacity(0.1),
                backgroundImage:
                    imgUrl != null && imgUrl.isNotEmpty
                        ? CachedNetworkImageProvider(imgUrl)
                        : null,
                child:
                    imgUrl == null || imgUrl.isEmpty
                        ? Text(
                          initial,
                          style: TextStyle(
                            color: AppColor.nokiaBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        )
                        : null,
              ),
              const SizedBox(width: 10),
              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      username,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Dropdown/More icon
              Icon(Icons.more_vert, size: 18, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  // Logout action
  void _handleLogout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text("Log Out"),
          content: const Text(
            "Are you sure you want to log out from ClassMaster?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await LocalData.emptyLocal();
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
                // ignore: use_build_context_synchronously
                context.goNamed(RouteConst.login);
              },
              child: const Text(
                "sign Out",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );
  }
}
