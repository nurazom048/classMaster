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
  // ==========================================================
  // Add New Class
  // ==========================================================
  //
  // Creates a new class inside a routine.
  // After successful creation:
  // 1. Refresh routine details provider
  // 2. Show success message
  // 3. Return newly created class id
  //
  static Future<String> addClass(
    WidgetRef ref,
    String routineId,
    context,
    ClasssModel classModel,
    DateTime startTime,
    DateTime endTime,
  ) async {
    try {
      // Auth token + required request headers
      final headers = await LocalData.getHeader();

      // API endpoint
      final url = Uri.parse('${Const.BASE_URl}/class/$routineId/addclass');

      // Send create class request
      final response = await http.post(
        url,
        headers: headers,
        body: {
          // Class information from model
          ...classModel.toRequestBody(),

          // Backend expects formatted datetime strings
          "startTime": endMaker(startTime.toIso8601String()),
          "endTime": endMaker(endTime.toIso8601String()),
        },
      );

      // Class created successfully
      if (response.statusCode == 201) {
        final res = json.decode(response.body);

        // Reload routine details so UI updates instantly
        ref.refresh(routineDetailsProvider(routineId));

        Alert.showSnackBar(context, 'Class added successfully');

        return res["class"]["id"];
      }

      // Backend validation / business logic error
      final message = json.decode(response.body)["message"];
      Alert.errorAlertDialog(context, message);
    } catch (e) {
      // Keep only error logs for debugging
      print("Add Class Error: $e");

      Alert.handleError(context, e);
      return 'Failed to add $e';
    }

    return 'Failed to add';
  }

  // ==========================================================
  // Edit Existing Class
  // ==========================================================
  //
  // Updates class information.
  // After successful update:
  // 1. Refresh routine details
  // 2. Show success message
  // 3. Close edit screen
  //
  Future<void> editClass(
    context,
    WidgetRef ref,
    String classId,
    String routineId,
    DateTime startTime,
    DateTime endTime,
    ClasssModel classModel,
  ) async {
    try {
      // Auth token + request headers
      final headers = await LocalData.getHeader();

      // Send update request
      final response = await http.post(
        Uri.parse('${Const.BASE_URl}/class/edit/$classId'),
        headers: headers,
        body: classModel.toRequestBody(),
      );

      final responseBody = json.decode(response.body);

      // Update successful
      if (response.statusCode == 200) {
        await LocalData.setHerder(response);

        // Refresh routine details to get latest class data
        ref.refresh(routineDetailsProvider(routineId));

        Alert.showSnackBar(context, responseBody["message"]);

        // Close edit page
        Navigator.pop(context);

        return;
      }

      // Validation / business error
      Alert.showSnackBar(context, responseBody["message"]);
    } catch (e) {
      print("Edit Class Error: $e");

      Alert.handleError(context, e.toString());
    }
  }

  // ==========================================================
  // Delete Class
  // ==========================================================
  //
  // Removes a class permanently.
  // After successful deletion:
  // 1. Refresh routine details
  // 2. Show success message
  //
  static Future<void> removeClass(
    context,
    WidgetRef ref,
    String classId,
    String routineId,
  ) async {
    try {
      // Auth token + request headers
      final headers = await LocalData.getHeader();

      // API endpoint
      final uri = Uri.parse('${Const.BASE_URl}/class/remove/$classId');

      // Send delete request
      final response = await http.delete(uri, headers: headers);

      // Delete successful
      if (response.statusCode == 200) {
        await LocalData.setHerder(response);

        // Refresh routine details to remove deleted class from UI
        ref.refresh(routineDetailsProvider(routineId));

        Alert.showSnackBar(context, 'Class deleted successfully');

        return;
      }

      Alert.handleError(context, json.decode(response.body));
    } catch (e) {
      print("Delete Class Error: $e");

      Alert.handleError(context, e.toString());
    }
  }
}
