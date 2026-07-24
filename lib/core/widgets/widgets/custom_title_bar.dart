import 'package:classmate/core/constant/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../route/route_constant.dart';
import '../../constant/app_color.dart';
import '../../local_data/local_data.dart';
import '../../../features/account_fetures/domain/providers/account_providers.dart';
import '../../../features/account_fetures/data/models/account_models.dart';
import '../../../ui/bottom_nevbar_items/bottom_navbar.dart';
import 'package:classmate/core/component/heder_component/transition/right_to_left_transition.dart';
import 'package:classmate/features/search_fetures/presentation/screens/search_page.dart';
import 'package:classmate/features/notification/screen/notification.screen.dart';
import 'package:classmate/features/account_fetures/presentation/screens/profile_screen.dart';

class CustomTitleBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  final String title;
  final IconData? icon;
  final double elevation;
  final Widget? action;

  const CustomTitleBar(
    this.title, {
    this.icon,
    this.elevation = 0.0,
    this.action,
    super.key,
  });

  @override
  ConsumerState<CustomTitleBar> createState() => _CustomTitleBarState();

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

class _CustomTitleBarState extends ConsumerState<CustomTitleBar> {
  bool _isSearchExpanded = false;
  final TextEditingController _searchController = TextEditingController();

  void _navigateToShellPage(Widget page, [DrawerItem? drawerItem]) {
    if (drawerItem != null) {
      ref.read(drawerActiveItemProvider.notifier).state = drawerItem;
    }
    ref.read(bottomNavBarIndexProvider.notifier).state = 2;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      collectionNavigatorKey.currentState?.popUntil((route) => route.isFirst);
      collectionNavigatorKey.currentState?.push(
        RightToLeftTransition(page: page),
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 650;

    // Fetch user account info
    final isGuestAsync = ref.watch(isGuestProvider);
    final isGuest = isGuestAsync.value ?? false;
    final accountData = isGuest ? null : ref.watch(accountDataProvider(null));

    // Get formatted date details
    final now = DateTime.now();
    final dayOfWeek = DateFormat('EEEE').format(now);
    final dateStr = DateFormat('MM/dd/yy').format(now);

    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child:
          _isSearchExpanded && isMobile
              ? _buildMobileExpandedSearch()
              : _buildStandardHeader(
                isMobile,
                dayOfWeek,
                dateStr,
                accountData,
                isGuest,
              ),
    );
  }

  // 🔍 Mobile View - Expanded Search Bar
  Widget _buildMobileExpandedSearch() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            setState(() {
              _isSearchExpanded = false;
            });
          },
        ),
        Expanded(
          child: Container(
            height: 42,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              textInputAction: TextInputAction.search,
              onChanged: (value) {
                setState(() {});
              },
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  ref.read(searchStringProvider.notifier).state = value;
                  _navigateToShellPage(const SearchPage(), DrawerItem.search);
                }
              },
              decoration: const InputDecoration(
                hintText: "Search notices, routines...",
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                prefixIcon: Icon(Icons.search, size: 20, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ),
        if (_searchController.text.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.close, color: Colors.grey),
            onPressed: () {
              _searchController.clear();
              setState(() {});
            },
          ),
      ],
    );
  }

  // 💼 Standard Header with Responsive design
  Widget _buildStandardHeader(
    bool isMobile,
    String dayOfWeek,
    String dateStr,
    AsyncValue<dynamic>? accountData,
    bool isGuest,
  ) {
    final hasDrawer = Scaffold.of(context).hasDrawer;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 🍔 Left side: Drawer trigger on Mobile, Date info on Desktop/Tablet
        if (isMobile && hasDrawer) ...[
          IconButton(
            icon: const Icon(Icons.menu, size: 26),
            color: Colors.black87,
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          const SizedBox(width: 8),
        ],

        // Date & Day Display
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dayOfWeek,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade500,
              ),
            ),
            Text(
              dateStr,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),

        const Spacer(),

        // 🔍 Center: Search Input on Desktop/Tablet
        if (!isMobile)
          Expanded(
            flex: 3,
            child: Container(
              height: 42,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: InkWell(
                onTap:
                    () => _navigateToShellPage(
                      const SearchPage(),
                      DrawerItem.search,
                    ),
                borderRadius: BorderRadius.circular(12),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Icon(Icons.search, size: 20, color: Colors.grey),
                    ),
                    const Expanded(
                      child: Text(
                        "Search notices, routines, job circular...",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Text(
                        "Ctrl + K",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        const Spacer(),

        // 🔔 Right side icons: Notifications, Search icon on Mobile, Profile details
        Row(
          children: [
            if (isMobile) ...[
              IconButton(
                icon: Icon(Icons.search, color: AppColor.nokiaBlue, size: 24),
                onPressed: () {
                  setState(() {
                    _isSearchExpanded = true;
                  });
                },
              ),
              const SizedBox(width: 4),
            ],

            // Notifications Icon
            InkWell(
              onTap:
                  () => _navigateToShellPage(
                    const NotificationScreen(),
                    DrawerItem.notifications,
                  ),
              borderRadius: BorderRadius.circular(20),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.notifications_none_outlined,
                  size: 25,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Profile info
            accountData != null
                ? accountData.when(
                  data: (either) {
                    return either.fold(
                      (err) => _buildAvatar(null, '?', isMobile, isGuest),
                      (acc) => _buildProfileInfo(acc, isMobile, isGuest),
                    );
                  },
                  loading:
                      () => const CircleAvatar(
                        radius: 16,
                        child: SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                  error:
                      (err, stack) =>
                          _buildAvatar(null, '?', isMobile, isGuest),
                )
                : _buildProfileInfo(null, isMobile, isGuest),
          ],
        ),
      ],
    );
  }

  Widget _buildAvatar(
    String? imgUrl,
    String nameInitial,
    bool isMobile,
    bool isGuest,
  ) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: Colors.blue.shade100,
      backgroundImage:
          imgUrl != null && imgUrl.isNotEmpty
              ? CachedNetworkImageProvider(imgUrl)
              : null,
      child:
          imgUrl == null || imgUrl.isEmpty
              ? Text(
                nameInitial,
                style: TextStyle(
                  color: AppColor.nokiaBlue,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              )
              : null,
    );
  }

  Widget _buildProfileInfo(
    AccountModels? account,
    bool isMobile,
    bool isGuest,
  ) {
    final String displayName =
        isGuest ? "Guest User" : (account?.name ?? "Md Nur Azom");
    final String initial =
        displayName.isNotEmpty ? displayName[0].toUpperCase() : "N";
    final String? imgUrl = isGuest ? null : account?.imageUrl;

    if (isMobile) {
      return InkWell(
        onTap:
            () =>
                _navigateToShellPage(const ProfileScreen(), DrawerItem.profile),
        child: _buildAvatar(imgUrl, initial, isMobile, isGuest),
      );
    }

    return InkWell(
      onTap:
          () => _navigateToShellPage(const ProfileScreen(), DrawerItem.profile),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            _buildAvatar(imgUrl, initial, isMobile, isGuest),
            const SizedBox(width: 8),
            Text(
              displayName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
