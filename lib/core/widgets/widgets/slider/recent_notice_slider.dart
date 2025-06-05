import 'package:carousel_slider/carousel_slider.dart' as slider;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../constant/app_color.dart';

final carouselIndexProvider = StateProvider.family<int, String>(
  (ref, key) => 0,
);

class RecentNoticeSlider extends StatelessWidget {
  final List<Widget> list;
  final String ukey;

  const RecentNoticeSlider({super.key, required this.list, required this.ukey});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Consumer(
        builder: (context, ref, _) {
          //! provider
          final carouselIndex = ref.watch(carouselIndexProvider(ukey));
          final carouselIndexNotifier = ref.read(
            carouselIndexProvider(ukey).notifier,
          );
          return Column(
            children: [
              Container(
                height: 125,
                margin: const EdgeInsets.symmetric(horizontal: 18),
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: slider.CarouselSlider(
                  options: slider.CarouselOptions(
                    height: 120.0,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {
                      carouselIndexNotifier.state = index;
                    },
                    //autoPlay: true,
                  ),
                  items: list,
                ),
              ),
              const SizedBox(height: 13),
              AnimatedSmoothIndicator(
                activeIndex: carouselIndex,
                count: 4, // Update the count based on the number of items
                effect: ExpandingDotsEffect(
                  dotHeight: 12,
                  activeDotColor: AppColor.nokiaBlue,
                ),
              ),
              const SizedBox(height: 10),
            ],
          );
        },
      ),
    );
  }
}
