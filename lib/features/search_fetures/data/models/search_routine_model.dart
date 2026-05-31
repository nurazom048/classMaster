import 'package:classmate/features/routine_Fetures/data/models/routine_model.dart';
import '../../../account_fetures/data/models/account_models.dart';
import 'dart:convert';

SearchRoutinesModel searchRoutinesResponseFromJson(String str) =>
    SearchRoutinesModel.fromJson(json.decode(str));

String searchRoutinesResponseToJson(SearchRoutinesModel data) =>
    json.encode(data.toJson());

class SearchRoutinesModel {
  final List<Routine> routines;
  final int currentPage;
  final int totalPages;
  final int totalCount;
  final String? message;

  const SearchRoutinesModel({
    required this.routines,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
    this.message,
  });

  factory SearchRoutinesModel.fromJson(Map<String, dynamic> json) {
    return SearchRoutinesModel(
      routines:
          json["routines"] == null
              ? []
              : List<Routine>.from(
                json["routines"].map((x) => Routine.fromJson(x)),
              ),
      currentPage: json["currentPage"] ?? 1,
      totalPages: json["totalPages"] ?? 0,
      totalCount: json["totalCount"] ?? 0,
      message: json["message"],
    );
  }

  SearchRoutinesModel copyWith({
    List<Routine>? routines,
    int? currentPage,
    int? totalPages,
    int? totalCount,
    String? message,
  }) {
    return SearchRoutinesModel(
      routines: routines ?? this.routines,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalCount: totalCount ?? this.totalCount,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "currentPage": currentPage,
      "totalPages": totalPages,
      "totalCount": totalCount,
      "message": message,
      "routines": routines.map((x) => x.toJson()).toList(),
    };
  }
}
