import 'package:classmate/features/search_fetures/data/models/search_routine.dart';

class JoinedRutines {
  List<Routine> routines;
  int currentPage;
  int totalPages;

  JoinedRutines({
    required this.routines,
    required this.currentPage,
    required this.totalPages,
  });

  factory JoinedRutines.fromJson(Map<String, dynamic> json) {
    var list = json['routines'] as List;
    List<Routine> routines = list.map((i) => Routine.fromJson(i)).toList();
    return JoinedRutines(
      routines: routines,
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
    );
  }

  Map<String, dynamic> toJson() => {
    'currentPage': currentPage,
    'totalPages': totalPages,
  };
}
