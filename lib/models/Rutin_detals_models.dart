// class RutinDetalsModels {
//   List<Classes> priodes;
//   List<Classes> Classes;
//   List<Classes> monday;
//   List<Classes> tuesday;
//   List<Classes> wednesday;
//   List<Classes> thursday;
//   List<Classes> friday;
//   List<Classes> saturday;

//   RutinDetalsModels(
//       {required this.priodes,
//       required this.Classes,
//       required this.monday,
//       required this.tuesday,
//       required this.wednesday,
//       required this.thursday,
//       required this.friday,
//       required this.saturday});

//   RutinDetalsModels.fromJson(Map< String, dynamic> json) {
//     if (json['priodes'] != null) {
//       priodes = List<Priodes>();
//       json['priodes'].forEach((v) {
//         priodes.add(Priodes.fromJson(v));
//       });
//     }
//     if (json['Classes'] != null) {
//       Classes = List<Classes>();
//       json['Classes'].forEach((v) {
//         Classes.add(Classes.fromJson(v));
//       });
//     }
//     if (json['Monday'] != null) {
//       monday = List<Monday>();
//       json['Monday'].forEach((v) {
//         monday.add(Monday.fromJson(v));
//       });
//     }
//     if (json['Tuesday'] != null) {
//       tuesday = List<Tuesday>();
//       json['Tuesday'].forEach((v) {
//         tuesday.add(Tuesday.fromJson(v));
//       });
//     }
//     if (json['Wednesday'] != null) {
//       wednesday = List<Wednesday>();
//       json['Wednesday'].forEach((v) {
//         wednesday.add(Wednesday.fromJson(v));
//       });
//     }
//     if (json['Thursday'] != null) {
//       thursday = <Classes>[];
//       json['Thursday'].forEach((v) {
//         thursday.add(Thursday.fromJson(v));
//       });
//     }
//     if (json['Friday'] != null) {
//       friday = <Classes>[];
//       json['Friday'].forEach((v) {
//         friday.add(Null.fromJson(v));
//       });
//     }
//     if (json['Saturday'] != null) {
//       saturday = <Classes>[];
//       json['Saturday'].forEach((v) {
//         saturday.add(Saturday.fromJson(v));
//       });
//     }
//   }

//   Map< String, dynamic> toJson() {
//     final Map< String, dynamic> data = Map< String, dynamic>();
//     data['priodes'] = priodes.map((v) => v.toJson()).toList();
//     data['Classes'] = Classes.map((v) => v.toJson()).toList();
//     data['Monday'] = monday.map((v) => v.toJson()).toList();
//     data['Tuesday'] = tuesday.map((v) => v.toJson()).toList();
//     data['Wednesday'] = wednesday.map((v) => v.toJson()).toList();
//     data['Thursday'] = thursday.map((v) => v.toJson()).toList();
//     data['Friday'] = friday.map((v) => v.toJson()).toList();
//     data['Saturday'] = saturday.map((v) => v.toJson()).toList();
//     return data;
//   }
// }

// class Priodes {
//   late  String startTime;
//   late  String endTime;
//   late  String sId;

//   Priodes({required this.startTime, required this.endTime, required this.sId});

//   Priodes.fromJson(Map< String, dynamic> json) {
//     startTime = json['start_time'];
//     endTime = json['end_time'];
//     sId = json['_id'];
//   }

//   Map< String, dynamic> toJson() {
//     final Map< String, dynamic> data = Map< String, dynamic>();
//     data['start_time'] = startTime;
//     data['end_time'] = endTime;
//     data['_id'] = sId;
//     return data;
//   }
// }

// class Classes {
//   late String sId;
//   late String name;
//   late String instuctorName;
//   late String room;
//   late String subjectcode;
//   late  int start;
//  late int end;
//  late  int weekday;
//   late String startTime;
//   late String endTime;
//   late String hasClass;

//   Classes(
//       {required this.sId,
//       required this.name,
//       required this.instuctorName,
//       required this.room,
//       required this.subjectcode,
//       required this.start,
//       required this.end,
//       required this.weekday,
//       required this.startTime,
//       required this.endTime,
//       required this.hasClass});

//   Classes.fromJson(Map< String, dynamic> json) {
//     sId = json['_id'];
//     name = json['name'];
//     instuctorName = json['instuctor_name'];
//     room = json['room'];
//     subjectcode = json['subjectcode'];
//     start = json['start'];
//     end = json['end'];
//     weekday = json['weekday'];
//     startTime = json['start_time'];
//     endTime = json['end_time'];
//     hasClass = json['has_class'];
//   }

//   Map< String, dynamic> toJson() {
//     final Map< String, dynamic> data = Map< String, dynamic>();
//     data['_id'] = sId;
//     data['name'] = name;
//     data['instuctor_name'] = instuctorName;
//     data['room'] = room;
//     data['subjectcode'] = subjectcode;
//     data['start'] = start;
//     data['end'] = end;
//     data['weekday'] = weekday;
//     data['start_time'] = startTime;
//     data['end_time'] = endTime;
//     data['has_class'] = hasClass;
//     return data;
//   }
// }
