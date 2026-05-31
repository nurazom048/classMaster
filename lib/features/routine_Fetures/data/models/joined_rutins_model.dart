// import 'package:classmate/features/routine_Fetures/data/models/routine_model.dart';

// class JoinedRoutines {
//   List<Routine> routines;
//   int currentPage;
//   int totalPages;

//   JoinedRoutines({
//     required this.routines,
//     required this.currentPage,
//     required this.totalPages,
//   });

//   factory JoinedRoutines.fromJson(Map<String, dynamic> json) {
//     var list = json['routines'] as List;
//     List<Routine> routines = list.map((i) => Routine.fromJson(i)).toList();
//     return JoinedRoutines(
//       routines: routines,
//       currentPage: json['currentPage'],
//       totalPages: json['totalPages'],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     'currentPage': currentPage,
//     'totalPages': totalPages,
//   };
// }
