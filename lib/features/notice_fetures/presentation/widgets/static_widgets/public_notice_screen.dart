import 'package:classmate/features/notice_fetures/presentation/screens/view_notice_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PublicNoticeScreen extends StatelessWidget {
  final String noticeId;

  const PublicNoticeScreen({super.key, required this.noticeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notice")),
      body: Center(child: Text("Notice ID: $noticeId")),
    );
  }
}
