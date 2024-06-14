// ignore_for_file: avoid_print, library_prefixes

import 'package:classmate/ui/bottom_items/Home/Full_routine/Summary/widgets/chats.dribles%20.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classmate/constant/constant.dart';
import 'package:classmate/core/component/loaders.dart';
import 'package:classmate/core/dialogs/alert_dialogs.dart';
import 'package:classmate/ui/bottom_items/Home/Full_routine/Summary/summat_screens/add_summary.dart';
import 'package:classmate/widgets/error/error.widget.dart';
import '../../controller/check_status_controller.dart';
import '../Summary Controller/summary_controller.dart';
import '../widgets/add_summary_button.dart';
import '../widgets/summary_header.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer(builder: (context, ref, _) {
          final checkStatus =
              ref.watch(checkStatusControllerProvider(widget.routineID));

          return checkStatus.when(
            data: (data) => onData(ref, data),
            error: (error, stackTrace) => Alert.handleError(context, error),
            loading: () => Loaders.center(),
          );
        }),
      ),
    );
  }

  Widget onData(WidgetRef ref, dynamic data) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      pageScrollController
          .jumpTo(pageScrollController.position.minScrollExtent);
    });

    final allSummary = ref.watch(summaryControllerProvider(widget.classId));
    final checkStatus =
        ref.watch(checkStatusControllerProvider(widget.routineID));
    final summaryNotifier =
        ref.watch(summaryControllerProvider(widget.classId).notifier);

    String status = checkStatus.value?.activeStatus ?? '';
    final bool isCaptain = checkStatus.value?.isCaptain ?? false;
    final bool isOwner = checkStatus.value?.isOwner ?? false;

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
                              data.currentPage, data.totalPages);
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
                  error: (error, stackTrace) =>
                      Alert.handleError(context, error),
                  loading: () => Loaders.center(),
                );
              },
            ),
          ),
        ),
        floatingActionButton: isCaptain || isOwner
            ? AddSummaryButton(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      fullscreenDialog: true,
                      builder: (context) =>
                          AddSummaryScreen(classId: widget.classId),
                    ),
                  );
                },
              )
            : const SizedBox(),
      ),
    );
  }
}
