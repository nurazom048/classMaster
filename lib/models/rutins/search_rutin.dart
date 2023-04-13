import 'package:table/models/rutins/rutins.dart';

// class RutinQuarry {
//   List<Routine> rutins;
//   int currentPage;
//   int totalPages;

//   RutinQuarry({
//     required this.rutins,
//     required this.currentPage,
//     required this.totalPages,
//   });

//   factory RutinQuarry.fromJson(Map<String, dynamic> json) {
//     return RutinQuarry(
//       rutins:
//           List<Routine>.from(json['rutins'].map((x) => Routine.fromJson(x))),
//       currentPage: json['currentPage'],
//       totalPages: json['totalPages'],
//     );
//   }
// }

class RutinQuarry {
  RutinQuarry({
    required this.rutins,
    this.currentPage,
    this.totalPages,
  });

  List<Routine> rutins;
  int? currentPage;
  int? totalPages;

  factory RutinQuarry.fromJson(Map<String, dynamic> json) {
    List<Routine> routines = List<Routine>.from(json["rutins"].map((x) =>
        Routine.fromJson(x["_id"], x["name"], Owner.fromJson(x["ownerid"]),
            LastSummary.fromJson(x["last_summary"]))));

    return RutinQuarry(
      rutins: routines,
      currentPage: json["currentPage"],
      totalPages: json["totalPages"],
    );
  }
}
