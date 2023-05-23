import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:table/constant/app_color.dart';
import 'package:table/ui/auth_Section/auth_ui/logIn_screen.dart';
import 'package:table/ui/auth_Section/auth_ui/phone_number_screen.dart';
import 'package:table/ui/bottom_items/Home/widgets/notice_row.dart';
import 'firebase_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

void main() async {
  //notification
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Channel',
        channelDescription: 'Basic channel for notifications',
        defaultColor: Colors.blue,
        ledColor: Colors.blue,
      ),
    ],
  );

  //firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFEFF6FF),
        primarySwatch: Colors.blue,
      ),
      home: LogingScreen(),
    );
  }
}
////////

class RecentNoticeSliderItem extends StatelessWidget {
  const RecentNoticeSliderItem(
      {super.key,
      required this.notice,
      required this.conditon,
      required this.index});
  final notice;
  final int index;
  final bool conditon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (conditon == true) ...[
              NoticeRow(
                notice: notice[index],
                date: notice[index].time.toString(),
                title: notice[index].contentName,
              ),
              NoticeRow(
                notice: notice[index + 1],
                date: notice[index + 1].time.toString(),
                title: notice[index + 1].contentName,
              )
            ],
          ]),
    );
  }
}

///
final carouselIndexProvider = StateProvider<int>((ref) => 0);

class RecentNoticeSlider extends StatelessWidget {
  RecentNoticeSlider({Key? key, required this.list}) : super(key: key);

  final List<Widget> list;

  final carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 181,
      child: Consumer(builder: (context, ref, _) {
        //! provider
        final carouselIndex = ref.watch(carouselIndexProvider);
        final carouselIndexNotifier = ref.read(carouselIndexProvider.notifier);
        return Column(
          children: [
            Container(
              height: 140,
              margin: const EdgeInsets.symmetric(horizontal: 18),
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: CarouselSlider(
                carouselController: carouselController,
                options: CarouselOptions(
                  height: 120.0,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    carouselIndexNotifier.state = index;
                  },
                  autoPlay: true,
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
            const SizedBox(height: 16),
          ],
        );
      }),
    );
  }
}
