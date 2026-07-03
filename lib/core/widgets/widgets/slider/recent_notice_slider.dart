import 'package:flutter/material.dart';

class RecentNoticeSlider extends StatefulWidget {
  final String ukey;
  final List<Widget> list;

  const RecentNoticeSlider({super.key, required this.ukey, required this.list});

  @override
  State<RecentNoticeSlider> createState() => _RecentNoticeSliderState();
}

class _RecentNoticeSliderState extends State<RecentNoticeSlider> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, keepPage: true);

    // 👂 Listen to page changes
    _pageController.addListener(() {
      int nextPage = _pageController.page?.round() ?? 0;
      if (nextPage != _currentPage) {
        setState(() {
          _currentPage = nextPage;
        });
        debugPrint('🔄 Swiped to page: $_currentPage');
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.list.isEmpty) {
      return const Center(child: Text('No notices available'));
    }

    return Column(
      children: [
        // 📄 Swipeable PageView
        Expanded(
          child: GestureDetector(
            onHorizontalDragEnd: (details) {
              // 👈 Swipe left -> next page
              if (details.primaryVelocity! < 0) {
                if (_currentPage < widget.list.length - 1) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                }
              }
              // 👉 Swipe right -> previous page
              else if (details.primaryVelocity! > 0) {
                if (_currentPage > 0) {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                }
              }
            },
            child: PageView(
              controller: _pageController,
              physics:
                  const NeverScrollableScrollPhysics(), // ⚠️ Disable default swipe
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
                debugPrint('📄 Page changed to: $index');
              },
              children: widget.list,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 🔵 Indicator dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.list.length,
            (index) => GestureDetector(
              onTap: () {
                debugPrint('🔵 Tapped dot: $index');
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                width: _currentPage == index ? 14 : 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _currentPage == index
                          ? const Color(0xFF0052CC) // Active: Royal Blue
                          : Colors.grey.shade300, // Inactive: Light grey
                  boxShadow:
                      _currentPage == index
                          ? [
                            BoxShadow(
                              color: const Color(0xFF0052CC).withOpacity(0.4),
                              blurRadius: 6,
                              spreadRadius: 2,
                            ),
                          ]
                          : [],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
