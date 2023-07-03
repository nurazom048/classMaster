import 'package:flutter/material.dart';

class ViewImagesFullScreen extends StatelessWidget {
  final List<String> images;

  ViewImagesFullScreen({Key? key, required this.images}) : super(key: key);

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Images'),
        actions: [
          Text('${images.length}'),
          const SizedBox(width: 16),
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height - 100,
        width: MediaQuery.of(context).size.width - 1,
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: images.length,
          itemBuilder: (context, index) {
            final imageUrl = images[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 1),
              color: Colors.black12,
              height: 300,
              width: MediaQuery.of(context).size.width - 1,
              child: InteractiveViewer(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
