import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../constant/app_color.dart';

class RecentNoticeSliderScealton extends StatelessWidget {
  const RecentNoticeSliderScealton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 181,
      child: Column(
        children: [
          Container(
            height: 140,
            margin: const EdgeInsets.symmetric(horizontal: 18),
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
              //color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              period: const Duration(seconds: 2),
              enabled: true,
              child: CarouselSlider(
                carouselController: CarouselController(),
                options: CarouselOptions(
                  height: 120.0,
                  viewportFraction: 1,
                  autoPlay: true,
                ),
                items: List.generate(
                  2,
                  (index) => Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: const BoxDecoration(color: Colors.amber),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 13),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            period: const Duration(seconds: 2),
            enabled: true,
            child: AnimatedSmoothIndicator(
              activeIndex: 0,
              count: 4,
              effect: ExpandingDotsEffect(
                dotHeight: 12,
                activeDotColor: AppColor.nokiaBlue,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}