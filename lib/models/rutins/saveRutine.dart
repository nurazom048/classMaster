// ignore_for_file: file_names

import 'package:table/models/rutins/search_rutin.dart';

class SaveRutineResponse {
  List<Routine> savedRoutines;
  int currentPage;
  int totalPages;

  SaveRutineResponse({
    required this.savedRoutines,
    required this.currentPage,
    required this.totalPages,
  });

  factory SaveRutineResponse.fromJson(Map<String, dynamic> json) {
    var list = json['savedRoutines'] as List;
    List<Routine> routines = list.map((i) => Routine.fromJson(i)).toList();
    return SaveRutineResponse(
      savedRoutines: routines,
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
    );
  }

  Map<String, dynamic> toJson() => {
        'currentPage': currentPage,
        'totalPages': totalPages,
      };
}
