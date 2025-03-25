import 'package:carousel_slider/carousel_slider.dart' as slider;
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart' as shimmer;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../constant/app_color.dart';

class RecentNoticeSliderSkelton extends StatelessWidget {
  const RecentNoticeSliderSkelton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    slider.CarouselSliderController buttonCarouselController =
        slider.CarouselSliderController();

    return SizedBox(
      height: 165,
      child: Column(
        children: [
          Container(
            height: 123,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            width: double.infinity,
            decoration: BoxDecoration(
              //color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: shimmer.Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              period: const Duration(seconds: 2),
              enabled: true,
              child: slider.CarouselSlider(
                carouselController: buttonCarouselController,
                options: slider.CarouselOptions(
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
          const SizedBox(height: 10),
          shimmer.Shimmer.fromColors(
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
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
