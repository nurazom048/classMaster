import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/export_core.dart';
import '../../domain/providers/summary_controller.dart';
import '../widgets/static_widgets/chats_dribbles.dart';

class SaveSummeryScreen extends ConsumerStatefulWidget {
  const SaveSummeryScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SaveSummeryScreenState();
}

class _SaveSummeryScreenState extends ConsumerState<SaveSummeryScreen> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //! provider
    final allSummary = ref.watch(summaryControllerProvider(null));
    final summaryNotifier = ref.watch(summaryControllerProvider(null).notifier);

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: ListView(
            controller: scrollController,
            children: [
              HeaderTitle("Save Summary", context),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ).copyWith(top: 20),
                child: allSummary.when(
                  data: (data) {
                    int lenght = data.summaries.length;

                    return data.summaries.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 150),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.bookmark_border_rounded,
                                    size: 72,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "No saved summaries yet",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 40),
                                    child: Text(
                                      "Summaries you bookmark will appear here for quick access even when offline.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: List.generate(lenght, (i) {
                            void scrollListener() {
                              if (scrollController.position.pixels ==
                                  scrollController.position.maxScrollExtent) {
                                summaryNotifier.loadMore(
                                  data.currentPage,
                                  data.totalCount,
                                );
                              }
                            }

                            scrollController.addListener(scrollListener);
                            if (data.summaries.isEmpty) {
                              return const ErrorScreen(
                                error: "There is no Summary",
                              );
                            }
                            return ChatsDribbles(summary: data.summaries[i]);
                          }),
                        );
                  },
                  error:
                      (error, stackTrace) => Alert.handleError(context, error),
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
