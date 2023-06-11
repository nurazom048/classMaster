import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Account/accounu_ui/Account_screen.dart';

class Utils {
  // hode Nevbar On scroll
  static bool hideNevBarOnScroll(
      ScrollNotification? scrollNotification, WidgetRef ref) {
    // Logic of scrollNotification
    if (scrollNotification is ScrollStartNotification) {
      // ignore: avoid_print
      print("Scroll Started");

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .watch(hideNevBarOnScrooingProvider.notifier)
            .update((state) => true);
      });
    } else if (scrollNotification is ScrollUpdateNotification) {
      // print(message);
    } else if (scrollNotification is ScrollEndNotification) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .watch(hideNevBarOnScrooingProvider.notifier)
            .update((state) => false);
      });

      String message = 'Scroll Ended';
      print(message);
    }
    return true;
  }
}
