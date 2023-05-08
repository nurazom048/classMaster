// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:table/models/message_model.dart';
import 'package:table/ui/server/rutinReq.dart';
import '../../../../constant/constant.dart';
import '../../../../core/dialogs/alart_dialogs.dart';
import 'package:table/models/class_model.dart';

class ClassRequest {
  static Future<void> addClass(
      WidgetRef ref, String rutinId, context, ClassModel classModel) async {
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
        "num": classModel.weekday.toString(),
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
        // ignore: unused_result
        ref.refresh(rutins_detalis_provider(rutinId));
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

  Future<void> editClass(context, WidgetRef ref, String classId, rutinId,
      ClassModel classModel) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    print("from eddit");

    try {
      final response = await http.post(
        Uri.parse('${Const.BASE_URl}/class/eddit/$classId'),
        headers: {'Authorization': 'Bearer $getToken'},
        body: {
          "name": classModel.className.toString(),
          "room": classModel.roomNumber.toString(),
          "subjectcode": classModel.subjectCode.toString(),
          "instuctor_name": classModel.instructorName.toString(),
          "num": classModel.weekday.toString(),
          "start": classModel.startingPeriod.toString(),
          "end": classModel.endingPeriod.toString(),
        },
      );

      final res = json.decode(response.body);
      Message message = Message(message: json.decode(response.body)["message"]);
      print(res);

      if (response.statusCode == 200) {
        print("rutin created successfully");
        Alart.showSnackBar(context, message.message);
        Navigator.pop(context);
        // ignore: unused_result
        ref.refresh(rutins_detalis_provider(rutinId));
        print(res);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      Alart.handleError(context, e.toString());
    }
  }

  // delete class

  static Future<void> deleteClass(
      context, WidgetRef ref, String classId, String rutinId) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    print("from eddit");

    try {
      final response = await http.delete(
        Uri.parse('${Const.BASE_URl}/class/delete/$classId'),
        headers: {'Authorization': 'Bearer $getToken'},
      );

      final res = json.decode(response.body);
      Message message = json.decode(response.body)["message"];
      print(res);

      if (response.statusCode == 200) {
        print("rutin created successfully");
        Alart.showSnackBar(context, message.message);
        // ignore: unused_result
        ref.refresh(rutins_detalis_provider(rutinId));

        print(res);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      Alart.handleError(context, e.toString());
    }
  }
}
