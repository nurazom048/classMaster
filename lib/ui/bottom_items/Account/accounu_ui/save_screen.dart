import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/core/dialogs/Alart_dialogs.dart';
import 'package:table/ui/bottom_items/Account/accounu_ui/save_rutins_screen.dart';
import 'package:table/widgets/appWidget/appText.dart';
import 'package:table/widgets/appWidget/dottted_divider.dart';
import 'package:flutter/material.dart' as ma;

import '../../../server/rutinReq.dart';
import '../../Home/full_rutin/controller/chack_status_controller.dart';

class SaveScreen extends StatefulWidget {
  const SaveScreen({super.key});

  @override
  State<SaveScreen> createState() => _SaveScreenState();
}

int intali = 0;

List<Widget> views = [
  const SaveRutinsScreen(),
  ma.Text("data2"),
];

class _SaveScreenState extends State<SaveScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: views[intali],
        floatingActionButton: DotLineTabbar(
            tabs: const [
              'Save Rutine',
              'Save Rutine',
            ],
            onSelected: (selectedIndex) {
              setState(() {
                intali = selectedIndex ?? 0;
              });
              print("Selected index $selectedIndex");
            }),
      ),
    );
  }
}

class DotLineTabbar extends StatefulWidget {
  DotLineTabbar({
    required this.tabs,
    required this.onSelected,
    super.key,
  });
  final List<String> tabs;
  final Function(int?) onSelected;

  @override
  State<DotLineTabbar> createState() => _DotLineTabbarState();
}

class _DotLineTabbarState extends State<DotLineTabbar> {
  int intalIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: Row(
          children: List.generate(
        widget.tabs.length,
        (index) => MyTabDotUnderline(
          title: widget.tabs[index],
          color: Colors.black,
          isSelected: intalIndex == index,
          onTap: () {
            setState(() {
              intalIndex = index;
              widget.onSelected(index);
            });
          },
        ),
      )),
    );
  }
}

class MyTabDotUnderline extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Function()? onTap;

  const MyTabDotUnderline({
    Key? key,
    required this.title,
    this.isSelected = false,
    this.onTap,
    required Color color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? Colors.blue : Colors.black;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        height: 50,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Tab(
              child: ma.Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: DotedDivider(dashColor: color),
            ),
          ],
        ),
      ),
    );
  }
}

class MiniRutineCard extends StatelessWidget {
  const MiniRutineCard({
    required this.rutineName,
    required this.owerName,
    required this.image,
    required this.username,
    required this.rutinId,
    super.key,
  });
  final String rutineName;
  final String owerName;
  final String image;
  final String username, rutinId;
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      //! providers
      final chackStatus = ref.watch(chackStatusControllerProvider(rutinId));
      final chackStatusNotifier =
          ref.watch(chackStatusControllerProvider(rutinId).notifier);
      //? Provider
      final rutinDetals = ref.watch(rutins_detalis_provider(rutinId));
      String status = chackStatus.value?.activeStatus ?? '';
      return Container(
        height: 120,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(rutineName, fontSize: 26).title(),
                InkWell(
                  onTap: () {
                    chackStatusNotifier.saveUnsave(
                        context, !(chackStatus.value?.isSave ?? false));
                  },
                  child: chackStatus.when(
                      data: (data) {
                        return data.isSave == true
                            ? const Icon(Icons.bookmark_added)
                            : const Icon(Icons.bookmark_add_outlined);
                      },
                      error: (error, stackTrace) =>
                          Alart.handleError(context, error),
                      loading: () => ma.Text("Loading")),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const CircleAvatar(radius: 17),
                const SizedBox(width: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    //  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ma.Text(owerName,
                          style: const TextStyle(
                              fontSize: 23, fontWeight: FontWeight.w400)),
                      ma.Text(" @$username",
                          style: const TextStyle(fontSize: 15)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class MiniNoticeCard extends StatelessWidget {
  const MiniNoticeCard({
    required this.rutineName,
    required this.owerName,
    required this.image,
    required this.username,
    required this.rutinId,
    super.key,
  });
  final String rutineName;
  final String owerName;
  final String image;
  final String username, rutinId;
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      //! providers
      // final chackStatus = ref.watch(chackStatusControllerProvider(rutinId));
      // final chackStatusNotifier =
      //     ref.watch(chackStatusControllerProvider(rutinId).notifier);
      //? Provider
      // final rutinDetals = ref.watch(rutins_detalis_provider(rutinId));
      // String status = chackStatus.value?.activeStatus ?? '';
      return Container(
        height: 120,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(rutineName, fontSize: 26).title(),
                // InkWell(
                //   onTap: () {
                //   //   chackStatusNotifier.saveUnsave(
                //   //       context, !(chackStatus.value?.isSave ?? false));
                //    },
                //   child: chackStatus.when(
                //       data: (data) {
                //         return data.isSave == true
                //             ? const Icon(Icons.bookmark_added)
                //             : const Icon(Icons.bookmark_add_outlined);
                //       },
                //       error: (error, stackTrace) =>
                //           Alart.handleError(context, error),
                //       loading: () => Text("Loading")),
                // ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(radius: 17, backgroundImage: NetworkImage(image)),
                const SizedBox(width: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    //  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ma.Text(owerName,
                          style: const TextStyle(
                              fontSize: 23, fontWeight: FontWeight.w400)),
                      ma.Text(" @$username",
                          style: const TextStyle(fontSize: 15)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
