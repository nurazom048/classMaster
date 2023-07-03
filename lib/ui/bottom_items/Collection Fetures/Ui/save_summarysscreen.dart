import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table/constant/constant.dart';

import '../../../../core/component/Loaders.dart';
import '../../../../core/dialogs/alert_dialogs.dart';
import '../../../../widgets/error/error.widget.dart';
import '../../../../widgets/heder/heder_title.dart';
import '../../Home/Full_routine/Summary/Summary Controller/summary_controller.dart';
import '../../Home/Full_routine/Summary/widgets/chats.dribles .dart';

class SaveSummeryScreen extends ConsumerWidget {
  SaveSummeryScreen({super.key});
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //! provider
    final allSummary = ref.watch(summaryControllerProvider(null));
    final summaryNotifier = ref.watch(summaryControllerProvider(null).notifier);

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: ListView(
            controller: scrollController,
            children: [
              HeaderTitle(
                "Save Summarys",
                context,
                margin: const EdgeInsets.symmetric(horizontal: 25)
                    .copyWith(top: KTopPadding + 20),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8).copyWith(top: 20),
                child: allSummary.when(
                  data: (data) {
                    int lenght = data.summaries.length;

                    return data.summaries.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 400),
                            child: Center(
                                child: ErrorScreen(error: 'No Svaed summary')),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: List.generate(
                              lenght,
                              (i) {
                                void scrollListener() {
                                  if (scrollController.position.pixels ==
                                      scrollController
                                          .position.maxScrollExtent) {
                                    print(
                                        '?TOPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP');
                                    summaryNotifier.loadMore(
                                        data.currentPage, data.totalCount);
                                  }
                                }

                                scrollController.addListener(scrollListener);
                                if (data.summaries.isEmpty) {
                                  return const ErrorScreen(
                                      error: "There is no Summarys");
                                }
                                return ChatsDribbles(
                                    summary: data.summaries[i]);
                              },
                            ),
                          );
                  },
                  error: (error, stackTrace) =>
                      Alert.handleError(context, error),
                  loading: () => Loaders.center(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
