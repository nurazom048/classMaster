import 'rutins.dart';

class JoinRutinsModel {
  List<Routine> routines;
  int currentPage;
  int totalPages;

  JoinRutinsModel(
      {required this.routines,
      required this.currentPage,
      required this.totalPages});

  factory JoinRutinsModel.fromJson(Map<String, dynamic> json) {
    var routineList = json['routines'] as List;
    List<Routine> routines = routineList
        .map((routineJson) => Routine.fromJson(routineJson))
        .toList();
    return JoinRutinsModel(
        routines: routines,
        currentPage: json['currentPage'],
        totalPages: json['totalPages']);
  }
}
