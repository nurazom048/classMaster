import 'dart:convert';

import 'package:classmate/features/routine/data/models/routine_model.dart';

SavedRoutinesModel savedRoutinesResponseFromJson(String str) =>
    SavedRoutinesModel.fromJson(json.decode(str));

class SavedRoutinesModel {
  final List<Routine> routines;

  /// Current page returned from API
  final int currentPage;

  /// Total available pages
  final int totalPages;

  const SavedRoutinesModel({
    required this.routines,
    required this.currentPage,
    required this.totalPages,
  });

  factory SavedRoutinesModel.fromJson(Map<String, dynamic> json) {
    return SavedRoutinesModel(
      routines: List<Routine>.from(
        json["routines"].map((x) => Routine.fromJson(x)),
      ),
      currentPage: json["currentPage"] ?? 1,
      totalPages: json["totalPages"] ?? 1,
    );
  }

  /// Convert model back to JSON
  Map<String, dynamic> toJson() {
    return {
      "routines": routines,
      "currentPage": currentPage,
      "totalPages": totalPages,
    };
  }

  /// Used heavily by Riverpod state updates
  SavedRoutinesModel copyWith({
    List<Routine>? routines,
    int? currentPage,
    int? totalPages,
  }) {
    return SavedRoutinesModel(
      routines: routines ?? this.routines,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}
