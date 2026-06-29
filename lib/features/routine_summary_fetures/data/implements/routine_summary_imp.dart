// ==========================================
// 🏛️ ABSTRACT CLASS (Interface)
// ==========================================
import 'package:classmate/features/routine_summary_fetures/data/models/all_summary_models.dart';
import 'package:image_picker/image_picker.dart';

// ==========================================
// 🏛️ ABSTRACT CLASS (Interface)
// ==========================================
abstract class ISummaryRepository {
  /// Fetch summaries. Pass [classId] for class summaries, or [type] = 'saved' for saved summaries.
  Future<AllSummaryModel> getSummaries({
    String? classId,
    String? type,
    int page = 1,
    int limit = 10,
  });

  /// Uploads text, external links, and files to create a summary.
  /// Uses [XFile] to support both Mobile and Web platforms seamlessly.
  Future<bool> addSummary({
    required String classId,
    String? message,
    List<String>? externalLinks,
    List<XFile>? files, // 🔥 Changed to XFile
  });

  /// Deletes a summary by ID
  Future<bool> removeSummary(String summaryId);

  /// Returns roles and if the summary is saved by the user
  Future<Map<String, dynamic>> getSummaryStatus(String summaryId);

  /// Pass [save] = true to save, and [save] = false to unsave.
  Future<bool> toggleSaveSummary({
    required String summaryId,
    required bool save,
  });
}
