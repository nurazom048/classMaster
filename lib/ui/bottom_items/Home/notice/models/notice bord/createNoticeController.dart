import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/dialogs/alart_dialogs.dart';
import '../../notice controller/noticeRequest.dart';

final noticeBoardCreater_provider = ChangeNotifierProvider.autoDispose(
    (ref) => CreateNoticeBoard(ref.read(noticeReqProvider)));

class CreateNoticeBoard extends ChangeNotifier {
  final NoticeRequest noticeReq;
  CreateNoticeBoard(this.noticeReq);

  bool _createNoticeBoardLoader = false;
  bool get createNoticeBoardLoader => _createNoticeBoardLoader;

  Future<void> createNoticeBoard(name, about, context) async {
    _createNoticeBoardLoader = true;
    notifyListeners();

    final res = await noticeReq.createAnewNoticeBoard(name: name, about: about);

    _createNoticeBoardLoader = false;
    notifyListeners();

    res.fold(
      (l) => Alart.errorAlartDilog(context, l),
      (r) => Alart.showSnackBar(context, r.message),
    );
  }
}
