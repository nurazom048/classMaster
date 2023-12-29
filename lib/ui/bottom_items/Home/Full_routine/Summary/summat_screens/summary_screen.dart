// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:classmate/constant/constant.dart';
import 'package:classmate/core/component/loaders.dart';
import 'package:classmate/core/dialogs/alert_dialogs.dart';
import 'package:classmate/ui/bottom_items/Home/Full_routine/Summary/summat_screens/add_summary.dart';
import 'package:classmate/widgets/error/error.widget.dart';
import 'package:socket_io_client/socket_io_client.dart';
import '../../controller/check_status_controller.dart';
import '../Summary Controller/summary_controller.dart';
import '../widgets/add_summary_button.dart';
import '../widgets/chats.dribles .dart';
import '../widgets/summary_header.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

// ignore: constant_identifier_names
const String DEMO_PROFILE_IMAGE =
    "https://icon-library.com/images/person-icon-png/person-icon-png-1.jpg";

class SummaryScreen extends StatefulWidget {
  final String classId;
  final String routineID;
  //Header
  final String? className;
  final String? subjectCode;
  final String? instructorName;
  //
  final DateTime? startTime;
  final DateTime? endTime;
  final int? start; //priode start
  final int? end; //priode end
  final String? room;

  const SummaryScreen({
    super.key,
    required this.classId,
    required this.routineID,
    required this.className,
    required this.instructorName,
    required this.subjectCode,
    this.startTime,
    this.endTime,
    this.start,
    this.end,
    this.room,
  });

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

late ScrollController scrollController;
late ScrollController pageScrollController;
late IO.Socket socket;

class _SummaryScreenState extends State<SummaryScreen> {
  @override
  void dispose() {
    scrollController.dispose(); // Dispose the ScrollController
    pageScrollController.dispose(); // Dispose the ScrollController
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    pageScrollController = ScrollController();
    // //socket
    // socket = IO.io(
    //     'http://localhost:3000',
    //     OptionBuilder()
    //         .setTransports(['websocket']) // for Flutter or Dart VM
    //         .disableAutoConnect() // disable auto-connection
    //         .setExtraHeaders({'foo': 'bar'}) // optional
    //         .build());
    // socket.connect();

//
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer(builder: (context, ref, _) {
          // Providers
          final checkStatus =
              ref.watch(checkStatusControllerProvider(widget.routineID));

          return checkStatus.when(
            data: (data) {
              return onData();
            },
            error: (error, stackTrace) => Alert.handleError(context, error),
            loading: () => Loaders.center(),
          );
        }),
      ),
    );
  }

  Widget onData() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      pageScrollController
          .jumpTo(pageScrollController.position.minScrollExtent);
    });
    return Consumer(builder: (BuildContext context, WidgetRef ref, _) {
      //! provider

      print("ClassId : ${widget.classId}");
      print("priode : ${widget.start}");

      //! provider
      final allSummary = ref.watch(summaryControllerProvider(widget.classId));
      final checkStatus =
          ref.watch(checkStatusControllerProvider(widget.routineID));

      String status = checkStatus.value?.activeStatus ?? '';
      final bool isCaptain = checkStatus.value?.isCaptain ?? false;
      final bool isOwner = checkStatus.value?.isOwner ?? false;
      //
      final summaryNotifier =
          ref.watch(summaryControllerProvider(widget.classId).notifier);
      return SafeArea(
        child: Scaffold(
            body: NestedScrollView(
              controller: pageScrollController,
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverToBoxAdapter(
                  child: SummaryHeader(
                    classId: widget.classId,
                    className: widget.className,
                    instructorName: widget.instructorName,

                    //
                    startTime: widget.startTime,
                    endTime: widget.endTime,
                    start: widget.start,
                    end: widget.end,
                    room: widget.room,
                  ),
                ),
              ],
              body: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Builder(builder: (context) {
                  if (status != 'joined') {
                    return ErrorScreen(error: Const.CANT_SEE_SUMMARYS);
                  }
                  return Container(
                    child: allSummary.when(
                      data: (data) {
                        if (data.summaries.isEmpty) {
                          return const ErrorScreen(
                              error: "There is no Summary");
                        }

                        void scrollListener() {
                          if (scrollController.position.pixels ==
                              scrollController.position.maxScrollExtent) {
                            if (data.currentPage != data.totalPages) {
                              print('?TOPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP');

                              print(
                                  'current page ${data.currentPage}  ${data.totalPages}');
                              summaryNotifier.loadMore(
                                  data.currentPage, data.totalPages);
                            } else {
                              print(
                                  'No New Summary current page ${data.currentPage}  ${data.totalPages}');
                            }
                          }
                        }

                        scrollController.addListener(scrollListener);
                        return ListView.builder(
                          shrinkWrap: true,
                          controller: scrollController,
                          // reverse: true,
                          itemCount: data.summaries.length,
                          itemBuilder: (context, i) {
                            int lenght = data.summaries.length;
                            return Column(
                              children: [
                                ChatsDribbles(summary: data.summaries[i]),

                                // Lodes and end text
                                if (data.currentPage != data.totalPages &&
                                    data.totalPages > 10 &&
                                    i.isEqual(lenght - 1))
                                  Loaders.center()
                                else if (i.isEqual(lenght - 1))
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text("Reached to end"),
                                  ),
                              ],
                            );
                          },
                        );
                      },
                      error: (error, stackTrace) =>
                          Alert.handleError(context, error),
                      loading: () => Loaders.center(),
                    ),
                  );
                }),
              ),

              ///
            ),

            //... Add summary icon.....//
            floatingActionButton: isCaptain == true || isOwner
                ? AddSummaryButton(
                    onTap: () {
                      print("onTAp");

                      return Navigator.push(
                        context,
                        CupertinoPageRoute(
                            fullscreenDialog: true,
                            builder: (context) =>
                                AddSummaryScreen(classId: widget.classId)),
                      );
                    },
                  )
                : const SizedBox()),
      );
    });
  }
}

///
