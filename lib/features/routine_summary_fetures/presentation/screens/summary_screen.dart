// ignore_for_file: avoid_print, library_prefixes

import 'package:classmate/features/routine_summary_fetures/presentation/screens/add_summary.dart';
import 'package:classmate/features/routine_summary_fetures/presentation/socket%20services/socketCon.dart';
import 'package:classmate/features/routine_summary_fetures/presentation/widgets/static_widgets/chats.dribles%20.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/export_core.dart';
import '../../../routine_Fetures/presentation/providers/checkbox_selector_button.dart';
import '../providers/summary_controller.dart';
import '../widgets/static_widgets/add_summary_button.dart';
import '../widgets/static_widgets/summary_header.dart';

// ignore: constant_identifier_names
const String DEMO_PROFILE_IMAGE =
    "https://icon-library.com/images/person-icon-png/person-icon-png-1.jpg";

class SummaryScreen extends StatefulWidget {
  final String classId;
  final String routineID;
  final String? className;
  final String subjectCode;
  final String? instructorName;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? room;

  const SummaryScreen({
    super.key,
    required this.classId,
    required this.routineID,
    this.className,
    this.instructorName,
    required this.subjectCode,
    this.startTime,
    this.endTime,
    this.room,
  });

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

late ScrollController scrollController;
late ScrollController pageScrollController;

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

    // Initialize the SocketService and join the room after initialization
    SocketService.initializeSocket()
        .then((_) {
          // Join the room after socket initialization
          SocketService.joinRoom(widget.routineID);
        })
        .catchError((error) {
          print('Error initializing socket: $error');
        });
  }

  void _listenToChatMessages() {
    SocketService.socket.on('chat message', (data) {
      setState(() {});
      print('Message received: ${data['message']} in room: ${data['room']}');
    });
  }

  // Message received base on room id
  // SocketService.socket.on('chat message', (data) {
  //   final message = data['message'];
  //   final room = data['room'];
  //   print('Message received in room $room: $message');
  // });
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer(
          builder: (context, ref, _) {
            final checkStatus = ref.watch(
              checkStatusControllerProvider(widget.routineID),
            );

            return checkStatus.when(
              data: (data) => onData(ref, data),
              error: (error, stackTrace) => Alert.handleError(context, error),
              loading: () => Loaders.center(),
            );
          },
        ),
      ),
    );
  }

  Widget onData(WidgetRef ref, dynamic data) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      pageScrollController.jumpTo(
        pageScrollController.position.minScrollExtent,
      );
    });

    final allSummary = ref.watch(summaryControllerProvider(widget.classId));
    final checkStatus = ref.watch(
      checkStatusControllerProvider(widget.routineID),
    );
    final summaryNotifier = ref.watch(
      summaryControllerProvider(widget.classId).notifier,
    );

    String status = checkStatus.value?.activeStatus ?? '';
    final bool isCaptain = checkStatus.value?.isCaptain ?? false;
    final bool isOwner = checkStatus.value?.isOwner ?? false;

    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          controller: pageScrollController,
          headerSliverBuilder:
              (context, innerBoxIsScrolled) => [
                SliverToBoxAdapter(
                  child: SummaryHeader(
                    classId: widget.classId,
                    className: widget.className,
                    instructorName: widget.instructorName,
                    startTime: widget.startTime,
                    endTime: widget.endTime,
                    subjectCode: widget.subjectCode,
                    room: widget.room,
                  ),
                ),
              ],
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Builder(
              builder: (context) {
                if (status != 'joined') {
                  return ErrorScreen(error: Const.CANT_SEE_SUMMARY);
                }
                return allSummary.when(
                  data: (data) {
                    if (data.summaries.isEmpty) {
                      return const ErrorScreen(error: "There is no Summary");
                    }

                    scrollController.addListener(() {
                      _listenToChatMessages();
                      if (scrollController.position.pixels ==
                          scrollController.position.maxScrollExtent) {
                        if (data.currentPage != data.totalPages) {
                          summaryNotifier.loadMore(
                            data.currentPage,
                            data.totalPages,
                          );
                        }
                      }
                    });

                    return ListView.builder(
                      shrinkWrap: true,
                      controller: scrollController,
                      itemCount: data.summaries.length,
                      itemBuilder: (context, i) {
                        return Column(
                          children: [
                            ChatsDribbles(summary: data.summaries[i]),
                            if (data.currentPage != data.totalPages &&
                                data.totalPages > 10 &&
                                i == data.summaries.length - 1)
                              Loaders.center()
                            else if (i == data.summaries.length - 1)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Text("Reached to end"),
                              ),
                          ],
                        );
                      },
                    );
                  },
                  error:
                      (error, stackTrace) => Alert.handleError(context, error),
                  loading: () => Loaders.center(),
                );
              },
            ),
          ),
        ),
        floatingActionButton:
            isCaptain || isOwner
                ? AddSummaryButton(
                  onTap: () async {
                    // // Initialize the SocketService and join the room after initialization
                    // SocketService.initializeSocket().then((_) {
                    //   // Join the room after socket initialization
                    //   SocketService.sendMessage(room: widget.routineID);
                    // }).catchError((error) {
                    //   print('Error initializing socket: $error');
                    // });
                    //  Message received base on room id
                    SocketService.socket.on('chat message', (data) {
                      final message = data['message'];
                      final room = data['room'];
                      print('Message received in room $room: $message');
                    });
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        fullscreenDialog: true,
                        builder:
                            (context) => AddSummaryScreen(
                              classId: widget.classId,
                              routineId: widget.routineID,
                            ),
                      ),
                    );
                  },
                )
                : const SizedBox(),
      ),
    );
  }
}
