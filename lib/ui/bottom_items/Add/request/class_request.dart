// ignore_for_file: avoid_print, unused_result

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:classmate/local%20data/local_data.dart';
import 'package:classmate/models/message_model.dart';
import '../../../../constant/constant.dart';
import '../../../../core/dialogs/alert_dialogs.dart';
import 'package:classmate/models/class_model.dart';

import '../../Home/Full_routine/controller/riutine_details.controller.dart';

class ClassRequest {
  // ignore: body_might_complete_normally_nullable
  static Future<String?> addClass(
      WidgetRef ref, String routineId, context, ClassModel classModel) async {
    print("from add");
    try {
      final headers = await LocalData.getHerder();
      var url = Uri.parse('${Const.BASE_URl}/class/$routineId/addclass');

      final response = await http.post(
        url,
        body: {
          "name": classModel.className.toString(),
          "instuctor_name": classModel.instructorName.toString(),
          "room": classModel.roomNumber.toString(),
          "subjectcode": classModel.subjectCode.toString(),
          "start": classModel.startingPeriod.toString(),
          "end": classModel.endingPeriod.toString(),
          "weekday": classModel.weekday.toString(),
        },
        headers: headers,
      );

      print("  RES ..${json.decode(response.body)}");

      //

      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        // print(res);
        // Navigator.pop(context);
        ref.refresh(routineDetailsProvider(routineId));
        //print response
        print("class created successfully");
        // print(res);
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
    final Map<String, String> headers = await LocalData.getHerder();

    print("******************from edit");

    try {
      final response = await http.post(
        Uri.parse('${Const.BASE_URl}/class/eddit/$classId'),
        headers: headers,
        body: {
          "name": classModel.className.toString(),
          "room": classModel.roomNumber.toString(),
          "subjectcode": classModel.subjectCode.toString(),
          "instuctor_name": classModel.instructorName.toString(),
          "start": classModel.startingPeriod.toString(),
          "end": classModel.endingPeriod.toString(),
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

  // delete class

  static Future<void> deleteClass(
      context, WidgetRef ref, String classId, String routineId) async {
    // Obtain shared preferences.
    Uri uri = Uri.parse('${Const.BASE_URl}/class/delete/$classId');
    final Map<String, String> headers = await LocalData.getHerder();

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
        // throw Exception(json.decode(response.body));
      }
    } catch (e) {
      print(e);
      Alert.handleError(context, e.toString());
    }
  }
}
