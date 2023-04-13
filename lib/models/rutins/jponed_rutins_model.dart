import 'package:table/models/rutins/rutins.dart';

class JoinRutinsModel {
  JoinRutinsModel({
    required this.rutins,
    this.currentPage,
    this.totalPages,
  });

  List<Routine> rutins;
  int? currentPage;
  int? totalPages;

  factory JoinRutinsModel.fromJson(Map<String, dynamic> json) {
    List<Routine> routines = [];

    if (json["rutins"] != null) {
      routines = List<Routine>.from(json["rutins"].map((x) => Routine.fromJson(
          x["_id"],
          x["name"],
          Owner.fromJson(x["ownerid"]),
          LastSummary.fromJson(x["last_summary"]))));
    }

    return JoinRutinsModel(
      rutins: routines,
      currentPage: json["currentPage"],
      totalPages: json["totalPages"],
    );
  }
}
