// ignore_for_file: non_constant_identifier_names

import 'package:table/models/rutins/rutins.dart';
import 'dart:convert';

class ListOfSaveRutins {
  ListOfSaveRutins({
    required this.savedRoutines,
    this.currentPage,
    this.totalPages,
  });

  List<Routine> savedRoutines;
  int? currentPage = 1;
  int? totalPages = 1;

  // factory ListOfSaveRutins.fromJson(Map<String, dynamic> json) {
  //   List<Routine> routines = List<Routine>.from(
  //       json["savedRoutines"].map((x) => Routine.fromJson(x)));
  factory ListOfSaveRutins.fromJson(Map<String, dynamic> json) {
    List<Routine> routines = List<Routine>.from(json["savedRoutines"].map((x) =>
        Routine.fromJson(x["_id"], x["name"], Owner.fromJson(x["ownerid"]),
            LastSummary.fromJson(x["last_summary"]))));
    //
    return ListOfSaveRutins(
      savedRoutines: routines,
      currentPage: json["currentPage"],
      totalPages: json["totalPages"],
    );
  }
}

class ListOfUploadedRutins {
  ListOfUploadedRutins({
    required this.rutins,
    this.currentPage,
    this.totalPages,
  });

  List<Routine> rutins;
  int? currentPage;
  int? totalPages;

  factory ListOfUploadedRutins.fromJson(Map<String, dynamic> json) {
    List<Routine> routines = [];

    if (json["rutins"] != null) {
      routines = List<Routine>.from(json["rutins"].map((x) => Routine.fromJson(
          x["_id"],
          x["name"],
          Owner.fromJson(x["ownerid"]),
          LastSummary.fromJson(x["last_summary"]))));
    }

    return ListOfUploadedRutins(
      rutins: routines,
      currentPage: json["currentPage"],
      totalPages: json["totalPages"],
    );
  }
}
