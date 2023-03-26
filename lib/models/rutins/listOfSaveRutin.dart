// ignore_for_file: non_constant_identifier_names

import 'rutins.dart';

class ListOfSaveRutins {
  ListOfSaveRutins({
    required this.savedRoutines,
    this.currentPage,
    this.totalPages,
  });

  List<Routine> savedRoutines;
  int? currentPage = 1;
  int? totalPages = 1;

  factory ListOfSaveRutins.fromJson(Map<String, dynamic> json) {
    List<Routine> routines = List<Routine>.from(
        json["savedRoutines"].map((x) => Routine.fromJson(x)));

    //
    return ListOfSaveRutins(
      savedRoutines: routines,
      currentPage: json["currentPage"],
      totalPages: json["totalPages"],
    );
  }
}

//
class ListOfUploedRutins {
  ListOfUploedRutins({
    required this.rutins,
    this.currentPage,
    this.totalPages,
  });

  List<Routine> rutins;
  int? currentPage;
  int? totalPages;

  factory ListOfUploedRutins.fromJson(Map<String, dynamic> json) {
    List<Routine> routines =
        List<Routine>.from(json["rutins"].map((x) => Routine.fromJson(x)));
    return ListOfUploedRutins(
      rutins: routines,
      currentPage: json["currentPage"],
      totalPages: json["totalPages"],
    );
  }
}
