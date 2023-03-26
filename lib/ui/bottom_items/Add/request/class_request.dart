// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../../core/dialogs/Alart_dialogs.dart';
import '../../../../helper/constant/constant.dart';
import 'package:table/models/class_model.dart';

class ClassRequest {
  Future<void> addClass(String rutinId, context, ClassModel classModel) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? getToken = prefs.getString('Token');
      var url = Uri.parse('${Const.BASE_URl}/class/$rutinId/addclass/');

      final response = await http.post(url, body: {
        "name": classModel.className.toString(),
        "instuctor_name": classModel.instructorName.toString(),
        "room": classModel.roomNumber.toString(),
        "subjectcode": classModel.subjectCode.toString(),
        "start": classModel.startingPeriod.toString(),
        "end": classModel.endingPeriod.toString(),
        "has_class": "has_class",
        "weekday": classModel.weekday.toString(),
        "start_time": classModel.startTime.toString(),
        "end_time": classModel.endTime.toString(),
      }, headers: {
        'Authorization': 'Bearer $getToken'
      });

      print("  RES ..${json.decode(response.body)}");

      //
      var message = json.decode(response.body)["message"];
      print(message);

      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        Navigator.pop(context);

        //print response
        print("rutin created successfully");
        print(res);
      } else {
        Alart.errorAlartDilog(context, message);
      }
    } catch (e) {
      print("from server");
      print(e);
      //Alart.handleError(context, e);
    }
  }

//   Future<void> editClass(context) async {
//     // Obtain shared preferences.
//     final prefs = await SharedPreferences.getInstance();
//     final String? getToken = prefs.getString('Token');

//     final response = await http.post(
//         Uri.parse('${Const.BASE_URl}/class/eddit/${widget.classId}'),
//         body: {
//           "name": _className.text,
//           "instuctor_name": _instructorController.text,
//           "room": _roomController.text,
//           "subjectcode": _subCodeController.text,
//           "start": _startPeriodController.text,
//           "end": _endPeriodController.text,
//           "has_class": "has_class",
//           "weekday": _selectedDay.toString(),
//           "start_time": "${startTime.toIso8601String()}",
//           "end_time": "${endTime.toIso8601String()}",
//         },
//         headers: {
//           'Authorization': 'Bearer $getToken'
//         });
//     message = json.decode(response.body)["message"];
//     print(message);

//     if (response.statusCode == 200) {
//       //.. responce
//       final res = json.decode(response.body);
//       Navigator.pop(context);

//       //print response
//       print("rutin created successfully");
//       print(res);
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }

// // find class
//   Future<void> findClass() async {
//     // Obtain shared preferences.
//     final prefs = await SharedPreferences.getInstance();
//     final String? getToken = prefs.getString('Token');

//     final response = await http.get(
//         Uri.parse('${Const.BASE_URl}/class/find/class/${widget.classId}'),
//         headers: {'Authorization': 'Bearer $getToken'});

//     print(response.statusCode);
//     //.. responce
//     if (response.statusCode == 200) {
//       var decodedres = json.decode(response.body);
//       print(decodedres);
//       //
//       _className.text = json.decode(response.body)["classs"]["name"];
//       _instructorController.text =
//           json.decode(response.body)["classs"]["instuctor_name"];
//       _roomController.text = json.decode(response.body)["classs"]["room"];
//       _subCodeController.text =
//           json.decode(response.body)["classs"]["subjectcode"];

//       //
//       setState(() {
//         _selectedDay = json.decode(response.body)["classs"]["weekday"];
//         startTime =
//             DateTime.parse(json.decode(response.body)["classs"]["start_time"]);
//         endTime =
//             DateTime.parse(json.decode(response.body)["classs"]["end_time"]);

//         //
//         startTimeDemo =
//             DateTime.parse(json.decode(response.body)["classs"]["start_time"]);
//         endTimDemo =
//             DateTime.parse(json.decode(response.body)["classs"]["end_time"]);

//         show = true;

//         //
//         _startPeriodController.text =
//             json.decode(response.body)["classs"]["start"].toString();
//         _endPeriodController.text =
//             json.decode(response.body)["classs"]["end"].toString();
//       });

//       // print("${s.runtimeType}   vhey");
//     } else {
//       Alart.handleError(context, message);
//       throw Exception('Failed to load data');
//     }
//   }
}
