import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../appWidget/app_text.dart';

class ErrorScreen extends ConsumerWidget {
  final String error;
  const ErrorScreen({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: Text(
        error,
        style: TS.heading(),
      ),
    ));
  }
}
