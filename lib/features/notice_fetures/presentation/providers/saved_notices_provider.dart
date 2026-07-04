import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../data/models/recent_notice_model.dart';

/// A controller that manages locally bookmarked/saved notices using Hive storage.
class SavedNoticesController extends StateNotifier<List<Notice>> {
  SavedNoticesController() : super([]) {
    _loadSavedNotices();
  }

  static const String _boxName = 'saved_notices_box';

  /// Loads notices saved in Hive on initial startup.
  Future<void> _loadSavedNotices() async {
    try {
      final box = await Hive.openBox(_boxName);
      final List<Notice> loaded = [];
      for (var key in box.keys) {
        final String? jsonStr = box.get(key);
        if (jsonStr != null) {
          try {
            final Map<String, dynamic> decoded = json.decode(jsonStr);
            loaded.add(Notice.fromJson(decoded));
          } catch (e) {
            // Avoid failing due to corrupted storage
          }
        }
      }
      // Sort notices so that the newest saved is at the top
      loaded.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      state = loaded;
    } catch (e) {
      // Handle box open exceptions gracefully
    }
  }

  /// Toggles the saved status of a notice.
  Future<void> toggleSaveNotice(Notice notice) async {
    try {
      final box = await Hive.openBox(_boxName);
      final String key = notice.id;

      if (box.containsKey(key)) {
        await box.delete(key);
        state = state.where((n) => n.id != notice.id).toList();
      } else {
        // Store full JSON object so it works offline
        final jsonStr = json.encode(notice.toJson());
        await box.put(key, jsonStr);
        state = [notice, ...state];
      }
    } catch (e) {
      // Gracefully handle persistence issues
    }
  }

  /// Checks if a notice is already saved.
  bool isSaved(String noticeId) {
    return state.any((n) => n.id == noticeId);
  }
}

/// Riverpod provider for accessing saved notices.
final savedNoticesProvider = StateNotifierProvider<SavedNoticesController, List<Notice>>((ref) {
  return SavedNoticesController();
});
