// ignore_for_file: avoid_print, library_prefixes

import 'package:classmate/features/routine_summary_fetures/presentation/screens/add_summary_screen.dart';
import 'package:classmate/features/routine_summary_fetures/presentation/socket_services/socketCon.dart';
import 'package:classmate/features/routine_summary_fetures/presentation/widgets/static_widgets/chats_dribbles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart';
import '../../../../core/export_core.dart';
import '../../../routine/presentation/providers/chack_status_controller.dart';
import '../../domain/providers/summary_controller.dart';
import '../widgets/static_widgets/add_summary_button.dart';
import '../widgets/static_widgets/summary_header.dart';
import '../../../../core/local_data/local_data.dart';

// ignore: constant_identifier_names
const String DEMO_PROFILE_IMAGE =
    "https://icon-library.com/images/person-icon-png/person-icon-png-1.jpg";

class SummaryScreen extends ConsumerStatefulWidget {
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
  ConsumerState<SummaryScreen> createState() => _SummaryScreenState();
}

late ScrollController scrollController;
late ScrollController pageScrollController;

class _SummaryScreenState extends ConsumerState<SummaryScreen> {
  bool isGuestMode = false;
  List<String> typingUsers = []; // Track who is typing

  @override
  void initState() {
    super.initState();
    print(
      '[SummaryScreen] Initializing screen for routine ${widget.routineID}',
    );
    scrollController = ScrollController();
    pageScrollController = ScrollController();
    _checkGuestAndInit();
  }

  void _checkGuestAndInit() async {
    final guest = await LocalData.isGuest();
    if (mounted) {
      setState(() {
        isGuestMode = guest;
      });
      if (!guest) {
        _initializeSocket();
      }
    }
  }

  @override
  void dispose() {
    print('[SummaryScreen] Disposing screen for routine ${widget.routineID}');
    if (!isGuestMode) {
      print('[Socket] Leaving room ${widget.routineID}');
      SocketService.leaveRoom(widget.routineID);
      print('[Socket] Disconnecting socket');
      SocketService.disconnect();
    }
    scrollController.dispose();
    pageScrollController.dispose();
    super.dispose();
  }

  Future<void> _initializeSocket() async {
    print('[Socket] Starting socket initialization');

    try {
      print('[Socket] Attempting to initialize socket connection');
      await SocketService.initializeSocket();
      print('[Socket] Successfully initialized socket connection');

      print('[Socket] Attempting to join room ${widget.routineID}');
      SocketService.joinRoom(widget.routineID);
      print('[Socket] Join room request sent for ${widget.routineID}');

      // Set up event listeners with refresh callback
      SocketService.listenToRoomEvents(
        onChatMessage: (summary) {
          print('[Socket] [Event] New chat message received: ${summary.toString()}');
          if (mounted) {
            // ignore: unused_result
            ref.refresh(summaryControllerProvider(widget.classId));
          }
        },
        onUserOnline: (data) {
          print('[Socket] [Event] User online: ${data['username']}');
          final name = data['username'] ?? 'User';
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("🟢 $name is online"),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        onUserOffline: (data) {
          print('[Socket] [Event] User offline: ${data['username'] ?? data['userId']}');
          final name = data['username'] ?? 'User';
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("🔴 $name went offline"),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        onUserTyping: (data) {
          final name = data['username'] ?? 'Someone';
          if (!typingUsers.contains(name)) {
            setState(() {
              typingUsers.add(name);
            });
          }
          // Auto-remove typing user after 4 seconds of inactivity
          Future.delayed(const Duration(seconds: 4), () {
            if (mounted && typingUsers.contains(name)) {
              setState(() {
                typingUsers.remove(name);
              });
            }
          });
        },
        onUserStopTyping: (data) {
          // Timer naturally cleans it up, or if user leaves room
        },
      );

      // Error listener
      SocketService.socket.on('error', (error) {
        print('[Socket] [Error] Socket error occurred:');
        print('  - Message: ${error['message']}');
        print('  - Code: ${error['code']}');
      });

      // Connection status listeners
      SocketService.socket.onConnect((_) {
        print('[Socket] [Status] Connected to socket server');
        print('  - Socket ID: ${SocketService.socket.id}');
      });

      SocketService.socket.onDisconnect((_) {
        print('[Socket] [Status] Disconnected from socket server');
      });

      SocketService.socket.onConnecting((_) {
        print('[Socket] [Status] Attempting to connect to server...');
      });

      SocketService.socket.onReconnect((_) {
        print('[Socket] [Status] Reconnected to server');
      });
    } catch (e) {
      print('[Socket] [Error] Initialization failed:');
      print('  - Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isGuest = ref.watch(isGuestProvider).value ?? false;

    if (isGuest) {
      return const SafeArea(
        child: Scaffold(
          body: ErrorScreen(
            error:
                "Summaries are available only for logged-in routine members.",
          ),
        ),
      );
    }

    final checkStatus = ref.watch(
      checkStatusControllerProvider(widget.routineID),
    );

    return SafeArea(
      child: Scaffold(
        body: checkStatus.when(
          data: (data) => onData(ref, data),
          error: (error, stackTrace) => Alert.handleError(context, error),
          loading: () => Loaders.center(),
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

                    return Column(
                      children: [
                        if (typingUsers.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "${typingUsers.join(', ')} is typing...",
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.blue,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Expanded(
                          child: ListView.builder(
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
                          ),
                        ),
                      ],
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
