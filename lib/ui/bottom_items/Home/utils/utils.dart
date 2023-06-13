import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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

  //
  static String formatDate(DateTime flutteDate) {
    var now = DateTime.now();
    var formatter = DateFormat('MMM');
    var month = formatter.format(flutteDate);
    String displayDate;

    if (flutteDate.day == now.day && flutteDate.month == now.month) {
      displayDate = "Today";
    } else if (flutteDate.day == now.subtract(const Duration(days: 1)).day &&
        flutteDate.month == now.subtract(const Duration(days: 1)).month) {
      displayDate = "Yesterday";
    } else {
      displayDate = "${flutteDate.day} $month";
    }

    return displayDate;
  }

  // isOnlineMethode

  static Future<bool> isOnlineMethode() async {
    // final connectivityResult = await (Connectivity().checkConnectivity());
    print("from methode");

    bool set = false;
    if (set == false) {
      Connectivity().checkConnectivity().then((connectivityResult) {
        if (connectivityResult != ConnectivityResult.none) {
          set = true;
        } else {
          set = false;
        }
      });
    }

    //

    return set;
  }
//*************************************************** */
  //   ConnectivityResult _connectionStatus = ConnectivityResult.none;

  //   final Connectivity _connectivity = Connectivity();
  //   late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  //   //
  //   Future<void> initConnectivity() async {
  //     late ConnectivityResult result;
  //     // Platform messages may fail, so we use a try/catch PlatformException.
  //     try {
  //       result = await _connectivity.checkConnectivity();
  //       _connectionStatus = result;
  //     } catch (e) {
  //       print('Couldn\'t check connectivity status $e');
  //       return;
  //     }
  //   }

  //   //
  // }
}