// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:table/constant/constant.dart';
import 'package:table/core/component/loaders.dart';
import 'package:table/core/dialogs/alart_dialogs.dart';
import 'package:table/ui/bottom_items/Home/full_rutin/sunnary_section/summat_screens/add_summary.dart';
import 'package:table/widgets/error/error.widget.dart';
import '../../controller/chack_status_controller.dart';
import '../sunnary Controller/summary_controller.dart';
import '../widgets/add_summary_button.dart';
import '../widgets/chats.dribles .dart';
import '../widgets/summary_header.dart';

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

  SummaryScreen({
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

//
    SchedulerBinding.instance.addPostFrameCallback((_) {
      pageScrollController
          .jumpTo(pageScrollController.position.minScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (BuildContext context, WidgetRef ref, _) {
      //! provider

      print("ClassId : ${widget.classId}");

      //! provider
      final allSummary = ref.watch(sunnaryControllerProvider(widget.classId));
      final chackStatus =
          ref.watch(chackStatusControllerProvider(widget.routineID));

      String status = chackStatus.value?.activeStatus ?? '';
      final bool isCaptain = chackStatus.value?.isCaptain ?? false;
      final bool isOwner = chackStatus.value?.isOwner ?? false;
      //
      final summaryNotifier =
          ref.watch(sunnaryControllerProvider(widget.classId).notifier);
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
                              error: "There is no Summarys");
                        }

                        void scrollListener() {
                          if (scrollController.position.pixels ==
                              scrollController.position.maxScrollExtent) {
                            if (data.currentPage != data.totalPages) {
                              print('?TOPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP');

                              print(
                                  'currentpage ${data.currentPage}  ${data.totalPages}');
                              summaryNotifier.loadMore(
                                  data.currentPage, data.totalPages);
                            } else {
                              print(
                                  'No New Summarys currentpage ${data.currentPage}  ${data.totalPages}');
                            }
                          }
                        }

                        scrollController.addListener(scrollListener);
                        return ListView.builder(
                          controller: scrollController,
                          // reverse: true,
                          itemCount: data.summaries.length,
                          itemBuilder: (context, i) {
                            int lenght = data.summaries.length;
                            return Column(
                              children: [
                                ChatsDribles(summary: data.summaries[i]),

                                // Loders and end text
                                if (data.currentPage != data.totalPages &&
                                    i.isEqual(lenght - 1))
                                  Loaders.center()
                                else if (i.isEqual(lenght - 1))
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text("Reched to end"),
                                  ),
                              ],
                            );
                          },
                        );
                      },
                      error: (error, stackTrace) =>
                          Alart.handleError(context, error),
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

