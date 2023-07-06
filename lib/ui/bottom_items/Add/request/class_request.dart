// ignore_for_file: avoid_print, unused_result

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:table/models/message_model.dart';
import 'package:table/ui/auth_Section/auth_controller/auth_controller.dart';
import 'package:table/ui/bottom_items/Home/Full_routine/request/routine_api.dart';
import '../../../../constant/constant.dart';
import '../../../../core/dialogs/alert_dialogs.dart';
import 'package:table/models/class_model.dart';

class ClassRequest {
  // ignore: body_might_complete_normally_nullable
  static Future<String?> addClass(
      WidgetRef ref, String routineId, context, ClassModel classModel) async {
    print("from add");
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? getToken = prefs.getString('Token');
      var url = Uri.parse('${Const.BASE_URl}/class/$routineId/addclass');

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

      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        print(res);
        // Navigator.pop(context);
        ref.refresh(routine_details_provider(routineId));
        //print response
        print("class created successfully");
        print(res);
        Alert.showSnackBar(context, 'class add successfully');
        return res['_id'];
      } else {
        var message = json.decode(response.body)["message"];

        Alert.errorAlertDialog(context, message);
      }
    } catch (e) {
      print("from server");
      print(e);
      Alert.handleError(context, e);
    }
  }

  Future<void> editClass(context, WidgetRef ref, String classId, routineId,
      ClassModel classModel) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    final String? getToken = prefs.getString('Token');

    print("******************from edit");

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
      print(res);

      if (response.statusCode == 200) {
        Message message =
            Message(message: json.decode(response.body)["message"]);

        print("Routine created successfully");
        Alert.showSnackBar(context, message.message);
        Navigator.pop(context);

        ref.refresh(routine_details_provider(routineId));
        print(res);
      } else {
        Message message =
            Message(message: json.decode(response.body)["message"]);
        Alert.showSnackBar(context, message.message);
      }
    } catch (e) {
      Alert.handleError(context, e.toString());
    }
  }

  // delete class

  static Future<void> deleteClass(
      context, WidgetRef ref, String classId, String routineId) async {
    // Obtain shared preferences.
    final String? getToken = await AuthController.getToken();
    Uri uri = Uri.parse('${Const.BASE_URl}/class/delete/$classId');
    Map<String, String>? headers = {'Authorization': 'Bearer $getToken'};

    try {
      final response = await http.delete(uri, headers: headers);

      final res = json.decode(response.body);
      print(res);

      if (response.statusCode == 200) {
        print("Class Deleted successfully $res ");
        Alert.showSnackBar(context, 'Class Deleted successfully');
        ref.refresh(routine_details_provider(routineId));

        print(res);
      } else {
        throw Exception(json.decode(response.body));
      }
    } catch (e) {
      print(e);
      Alert.handleError(context, e.toString());
    }
  }
}
