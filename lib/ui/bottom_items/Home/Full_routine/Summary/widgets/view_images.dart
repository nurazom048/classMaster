import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classmate/widgets/heder/appbar_custom.dart';

final carouselImageIndexProvider = StateProvider<int>((ref) => 0);

class ViewImagesFullScreen extends ConsumerWidget {
  final List<String> images;
  final int? initialPage;

  ViewImagesFullScreen({
    Key? key,
    required this.images,
    this.initialPage = 0,
  }) : super(key: key);

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context, ref) {
    //! provider
    final carouselIndex = ref.watch(carouselImageIndexProvider);
    final carouselIndexNotifier = ref.read(carouselImageIndexProvider.notifier);
    return Scaffold(
      appBar: AppBarCustom(
        'Images',
        actions: [
          Text('${carouselIndex + 1}/${images.length}'),
          const SizedBox(width: 16),
        ],
      ),
      body: CarouselSlider(
          items: List.generate(
            images.length,
            (index) {
              final imageUrl = images[index];
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: InteractiveViewer(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              );
            },
          ),
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height,

            //height: 400,
            // aspectRatio: 16 / 9,
            //  viewportFraction: 0.8,
            initialPage: initialPage ?? 0,
            enableInfiniteScroll: false,
            //reverse: false,

            // enlargeCenterPage: true,
            //  enlargeFactor: 0,
            onPageChanged: (index, reason) {
              carouselIndexNotifier.state = index;
            },
            scrollDirection: Axis.vertical,
          )),
    );
  }
}
