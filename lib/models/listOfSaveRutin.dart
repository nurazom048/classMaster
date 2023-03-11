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
