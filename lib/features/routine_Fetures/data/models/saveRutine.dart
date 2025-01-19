// ignore_for_file: file_names

import 'package:classmate/features/search_fetures/data/models/search_rutin.dart';

class SaveRutileResponse {
  List<Routine> savedRoutines;
  int currentPage;
  int totalPages;

  SaveRutileResponse({
    required this.savedRoutines,
    required this.currentPage,
    required this.totalPages,
  });

  factory SaveRutileResponse.fromJson(Map<String, dynamic> json) {
    var list = json['savedRoutines'] as List;
    List<Routine> routines = list.map((i) => Routine.fromJson(i)).toList();
    return SaveRutileResponse(
      savedRoutines: routines,
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
    );
  }

  SaveRutileResponse copyWith({
    List<Routine>? savedRoutines,
    int? currentPage,
    int? totalPages,
  }) {
    return SaveRutileResponse(
      savedRoutines: savedRoutines ?? this.savedRoutines,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}
