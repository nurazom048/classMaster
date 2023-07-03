import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/component/Loaders.dart';
import '../../../../core/dialogs/alart_dialogs.dart';
import '../../../../widgets/error/error.widget.dart';
import '../../../../widgets/heder/heder_title.dart';
import '../../Home/full_rutin/sunnary_section/sunnary Controller/summary_controller.dart';
import '../../Home/full_rutin/sunnary_section/widgets/chats.dribles .dart';

class SaveSummarysScreen extends ConsumerWidget {
  SaveSummarysScreen({super.key});
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //! provider
    final allSummary = ref.watch(sunnaryControllerProvider(null));
    final summaryNotifier = ref.watch(sunnaryControllerProvider(null).notifier);

    return Scaffold(
      body: Center(
        child: ListView(
          controller: scrollController,
          children: [
            HeaderTitle("Save Summarys", context),
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
                                    scrollController.position.maxScrollExtent) {
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
                              return ChatsDribles(summary: data.summaries[i]);
                            },
                          ),
                        );
                },
                error: (error, stackTrace) => Alart.handleError(context, error),
                loading: () => Loaders.center(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}