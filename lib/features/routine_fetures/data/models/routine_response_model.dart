import 'routine_model.dart';

class RoutineResponse {
  final List<Routine> routines;
  final int currentPage;
  final int totalPages;
  final int totalCount;
  final String? message;

  RoutineResponse({
    required this.routines,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
    this.message,
  });

  factory RoutineResponse.fromJson(Map<String, dynamic> json) {
    final routinesList = json["routines"] ?? json["homeRoutines"] ?? json["savedRoutines"] ?? [];
    return RoutineResponse(
      routines: List<Routine>.from(
        (routinesList as List<dynamic>).map((x) => Routine.fromJson(x)),
      ),
      currentPage: json["currentPage"] ?? 1,
      totalPages: json["totalPages"] ?? 1,
      totalCount: json["totalCount"] ?? json["totalItems"] ?? 0,
      message: json["message"],
    );
  }

  Map<String, dynamic> toJson() => {
    "routines": routines.map((x) => x.toJson()).toList(),
    "currentPage": currentPage,
    "totalPages": totalPages,
    "totalCount": totalCount,
    "message": message,
  };

  RoutineResponse copyWith({
    List<Routine>? routines,
    int? currentPage,
    int? totalPages,
    int? totalCount,
    String? message,
  }) {
    return RoutineResponse(
      routines: routines ?? this.routines,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalCount: totalCount ?? this.totalCount,
      message: message ?? this.message,
    );
  }
}
