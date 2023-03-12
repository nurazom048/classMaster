// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:table/models/rutinOverviewModel.dart';

class ListOfSaveRutins {
  ListOfSaveRutins({
    required this.savedRoutines,
  });

  List<RutinOverviewMode> savedRoutines;

  factory ListOfSaveRutins.fromJson(Map<String, dynamic> json) {
    List<RutinOverviewMode> routines = List<RutinOverviewMode>.from(
        json["savedRoutines"].map((x) => RutinOverviewMode.fromJson(x)));
    return ListOfSaveRutins(savedRoutines: routines);
  }

  Map<String, dynamic> toJson() => {
        "savedRoutines":
            List<dynamic>.from(savedRoutines.map((x) => x.toJson())),
      };
}

//
class ListOfUploedRutins {
  ListOfUploedRutins({
    required this.uploaded_rutin,
    this.currentPage,
    this.totalPages,
  });

  List<RutinOverviewMode> uploaded_rutin;
  int? currentPage;
  int? totalPages;

  factory ListOfUploedRutins.fromJson(Map<String, dynamic> json) {
    List<RutinOverviewMode> routines = List<RutinOverviewMode>.from(
        json["rutins"].map((x) => RutinOverviewMode.fromJson(x)));
    return ListOfUploedRutins(
      uploaded_rutin: routines,
      currentPage: json["currentPage"],
      totalPages: json["totalPages"],
    );
  }

  Map<String, dynamic> toJson() => {
        "rutins": List<dynamic>.from(uploaded_rutin.map((x) => x.toJson())),
      };
}
