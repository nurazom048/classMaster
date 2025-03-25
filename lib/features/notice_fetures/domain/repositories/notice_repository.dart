import 'package:classmate/features/notice_fetures/data/models/recent_notice_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/models/message_model.dart';
import '../interface/pdf_interface.dart'; // For PdfFileData

// notice repository
abstract class NoticeRepository {
  /// Fetches recent notices with optional pagination and academy filtering
  Future<RecentNotice> fetchRecentNotice({int? page, String? academyId});

  /// Adds a new notice with optional PDF file
  Future<Either<String, String>> addNotice({
    String? contentName,
    String? description,
    PdfFileData? pdfFileData,
    required WidgetRef ref,
  });

  /// Deletes a notice by its ID
  Future<Either<Message, Message>> deleteNotice({required String noticeId});
}
