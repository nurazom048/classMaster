// ignore_for_file: avoid_print, unused_result

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:classmate/core/local%20data/local_data.dart';
import '../../../../core/export_core.dart';
import '../../presentation/providers/routine_details.controller.dart';
import '../../presentation/utils/popup.dart';
import '../models/class_model.dart';

class ClassRequest {
  //************************ Add Class Request ********************** */
  static Future<String> addClass(
    WidgetRef ref,
    String routineId,
    context,
    ClassModel classModel,
    DateTime startTime,
    DateTime endTime,
  ) async {
    try {
      final headers = await LocalData.getHeader();
      var url = Uri.parse('${Const.BASE_URl}/class/$routineId/addclass');

      final response = await http.post(
        url,
        body: {
          "name": classModel.className.toString(),
          "instructorName": classModel.instructorName.toString(),
          "room": classModel.roomNumber.toString(),
          "subjectCode": classModel.subjectCode.toString(),
          "startTime": endMaker(startTime.toIso8601String().toString()),
          "endTime": endMaker(endTime.toIso8601String().toString()),
          "weekday": classModel.weekday.toString(),
        },
        headers: headers,
      );

      // print("  RES ..${json.decode(response.body)}");

      if (response.statusCode == 201) {
        final res = json.decode(response.body);
        ref.refresh(routineDetailsProvider(routineId));
        print("class created successfully ${res["class"]['id']}");
        Alert.showSnackBar(context, 'class add successfully');
        return res["class"]['id'];
      } else {
        var message = json.decode(response.body)["message"];

        Alert.errorAlertDialog(context, message);
      }
    } catch (e) {
      print("from server");
      print(e);
      Alert.handleError(context, e);
      return 'Failed to add $e';
    }
    return 'Failed to add';
  }
  //************************* Edit Class Request ************************ */

  Future<void> editClass(context, WidgetRef ref, String classId, routineId,
      DateTime startTime, DateTime endTime, ClassModelUpdate classModel) async {
    // Obtain shared preferences.
    final Map<String, String> headers = await LocalData.getHeader();

    try {
      final response = await http.post(
        Uri.parse('${Const.BASE_URl}/class/edit/$classId'),
        headers: headers,
        body: {
          "name": classModel.className.toString(),
          "subjectCode": classModel.subjectCode.toString(),
          "instructorName": classModel.instructorName.toString(),
        },
      );

      final res = json.decode(response.body);
      print(res);

      if (response.statusCode == 200) {
        await LocalData.setHerder(response);
        Message message =
            Message(message: json.decode(response.body)["message"]);
        ref.refresh(routineDetailsProvider(routineId));

        print("Routine created successfully");
        Alert.showSnackBar(context, message.message);
        Navigator.pop(context);

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

  //************************* delete Class ************************ */

  static Future<void> removeClass(
    context,
    WidgetRef ref,
    String classId,
    String routineId,
  ) async {
    // Obtain shared preferences.
    Uri uri = Uri.parse('${Const.BASE_URl}/class/remove/$classId');
    final Map<String, String> headers = await LocalData.getHeader();

    try {
      final response = await http.delete(uri, headers: headers);

      final res = json.decode(response.body);
      print(res);

      if (response.statusCode == 200) {
        await LocalData.setHerder(response);

        print("Class Deleted successfully $res ");
        Alert.showSnackBar(context, 'Class Deleted successfully');
        ref.refresh(routineDetailsProvider(routineId));

        print(res);
      } else {
        Alert.handleError(context, json.decode(response.body));
      }
    } catch (e) {
      print(e);
      Alert.handleError(context, e.toString());
    }
  }
}
