// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../../core/dialogs/Alart_dialogs.dart';
import '../../../../helper/constant/constant.dart';
import 'package:table/models/class_model.dart';

class ClassRequest {
  Future<void> addClass(String rutinId, context, ClassModel classModel) async {
    print("from add");
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
      Alart.handleError(context, e);
    }
  }

  Future<void> editClass(context, String classId, ClassModel classModel) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    print("from eddit");

    try {
      final response = await http.post(
        Uri.parse(
          '${Const.BASE_URl}/class/eddit/$classId',
        ),
        headers: {'Authorization': 'Bearer $getToken'},
        body: {
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
        },
      );

      final res = json.decode(response.body);
      var message = json.decode(response.body)["message"];
      print(res);

      if (response.statusCode == 200) {
        Navigator.pop(context);

        print("rutin created successfully");
        print(res);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      Alart.handleError(context, e.toString());
    }
  }
}
